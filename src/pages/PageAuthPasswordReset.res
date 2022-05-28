open ReScriptJs

open ReactNative
open ReactNative.Style
open ReactMultiversal

let backendErrorCode_token_incorrect = "Incorrect code provided"
let backendErrorCode_bad_parameters = "Incorrect params provided"
let backendErrorCode_passwordDoNotMatch = "Passwords do not match"
let backendErrorCode_passwordLength = "password must be at least 6 characters"

module PasswordResetMutation = %relay(`
  mutation PageAuthPasswordResetMutation(
    $password: String!
    $passwordConfirmation: String!
    $code: String!
  ) {
    resetPassword(
      password: $password
      passwordConfirmation: $passwordConfirmation
      code: $code
    ) {
      jwt
    }
  }
`)

@react.component
let make = () => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()
  let router = Next.Router.useRouter()

  let (password, password_set) = React.useState(_ => "")
  let password_change = React.useCallback1(text => password_set(_ => text), [])
  let (password_note, password_note_set) = React.useState(_ => "")
  let (passwordConfirmation, passwordConfirmation_set) = React.useState(_ => "")
  let passwordConfirmation_change = React.useCallback1(
    text => passwordConfirmation_set(_ => text),
    [],
  )
  let (passwordConfirmation_note, passwordConfirmation_note_set) = React.useState(_ => "")
  let (tokenInvalid_error, tokenInvalid_error_set) = React.useState(_ => false)

  let isReady = router.isReady
  let queryParameter_code = router.query->Js.Dict.get("code")
  React.useEffect2(() => {
    if isReady && queryParameter_code->Option.isNone {
      Js.Console.warn("No code provided")
      // router->Next.Router.push("/auth/login")
      tokenInvalid_error_set(_ => true)
    }
    None
  }, (isReady, queryParameter_code))

  let (success, success_set) = React.useState(_ => false)
  let (backendErrors, backendErrors_set) = React.useState(_ => None)
  let (backendRemainingErrors, backendRemainingErrors_set) = React.useState(_ => [])

  let (passwordReset_mutate, _passwordReset_isMutating) = PasswordResetMutation.use()
  let handleSubmit = React.useCallback3(() => {
    success_set(_ => false)
    passwordReset_mutate(
      ~variables={
        password: password,
        passwordConfirmation: passwordConfirmation,
        code: queryParameter_code->Option.getWithDefault(""),
      },
      ~onError=error => {
        Js.Console.log2("onError", error)
        backendErrors_set(_ => Some(error->BackendErrors.refineError))
      },
      ~onCompleted=(completeResult, errors) => {
        Js.Console.log3("onCompleted", completeResult, errors)
        backendErrors_set(_ => errors->BackendErrors.refineErrors)
        if (
          completeResult.resetPassword
          ->Option.map(r => r.jwt->Option.isSome)
          ->Option.getWithDefault(false)
        ) {
          success_set(_ => true)
        }
      },
      (),
    )->ignore
  }, (password, passwordConfirmation, queryParameter_code))

  React.useEffect1(() => {
    let (error_codeExpired, remainingErrors) =
      backendErrors->BackendErrors.filterByMessage(backendErrorCode_token_incorrect)

    if error_codeExpired->Array.length > 0 {
      tokenInvalid_error_set(_ => true)
    }

    let (new_password_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["password"])
      let (errors2, ignoredErrors) =
        Some(ignoredErrors)->BackendErrors.filterByMessage(backendErrorCode_bad_parameters)
      // let (errors3, ignoredErrors) =
      //   Some(ignoredErrors)->BackendErrors.filterByMessage(backendErrorCode_passwordLength)
      let errors = errors->Array.concat(errors2)
      // ->Array.concat(errors3)
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError)
          if er.message === Some(backendErrorCode_bad_parameters) &&
            password->Js.String.length === 0 => (
            selected->Array.concat([t(. "-Form-ValidationError-password")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some(backendErrorCode_passwordLength) => (
            selected->Array.concat([t(. "-Form-ValidationError-password")]),
            rejected,
          )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_password_note !== password_note {
      password_note_set(_ => new_password_note)
    }

    let (new_passwordConfirmation_note, remainingErrors) = {
      let (errors, ignoredErrors) =
        Some(remainingErrors)->BackendErrors.filterByPath(["passwordConfirmation"])
      let (errors2, ignoredErrors) =
        Some(ignoredErrors)->BackendErrors.filterByMessage(backendErrorCode_passwordDoNotMatch)
      let (errors3, ignoredErrors) =
        Some(ignoredErrors)->BackendErrors.filterByMessage(backendErrorCode_bad_parameters)
      let errors = errors->Array.concat(errors2)->Array.concat(errors3)
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError)
          if er.message === Some(backendErrorCode_bad_parameters) &&
            password->Js.String.length > 0 => (
            selected->Array.concat([t(. "-Form-ValidationError-password")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some(backendErrorCode_passwordDoNotMatch) => (
            selected->Array.concat([t(. "-Form-ValidationError-passwordConfirmation")]),
            rejected,
          )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_passwordConfirmation_note !== passwordConfirmation_note {
      passwordConfirmation_note_set(_ => new_passwordConfirmation_note)
    }

    if remainingErrors->Js.Array.length > 0 {
      backendRemainingErrors_set(_ => remainingErrors)
      remainingErrors->Array.forEach(err => {
        err.message
        ->Option.getWithDefault("unknown backend error")
        ->Sentry.Browser.captureMessageWithExtra(Sentry.extras(~extra={"error": err}, ()))
      })
    } else if (
      remainingErrors->Js.Array.length === 0 && backendRemainingErrors->Js.Array.length > 0
    ) {
      backendRemainingErrors_set(_ => [])
    }

    None
  }, [backendErrors])

  let hasError_password = password_note !== ""
  let hasError_passwordConfirmation = passwordConfirmation_note !== ""

  <WebsiteWrapper>
    <WebsiteHeader noLogin=true />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "AuthPasswordReset-Title")->React.string}
          </Text>
          <Spacer />
          <View style={viewStyle(~width=100.->pct, ())}>
            <TextInputPlus
              style={array([viewStyle(~width=100.->pct, ())])}
              textInputStyle={array([
                Font.ios["body"],
                theme.styles["text"],
                viewStyle(
                  ~borderWidth=1.,
                  ~borderColor=hasError_password ? theme.colors.systemRed : theme.colors.textLight1,
                  ~borderStyle=#solid,
                  ~borderRadius=6.,
                  (),
                ),
              ])}
              styleFocused={array([
                viewStyle(
                  ~borderColor=hasError_password ? theme.colors.systemRed : theme.colors.systemBlue,
                  (),
                ),
              ])}
              placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
              placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
              placeholder={t(. "-Form-Placeholder-password")}
              noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
              note=password_note
              value={password}
              onChangeText={password_change}
              textContentType=#password
              secureTextEntry={true}
              onSubmitEditing={_ => handleSubmit()}
            />
          </View>
          <Spacer size=M />
          <Spacer size=XS />
          <View style={viewStyle(~width=100.->pct, ())}>
            <TextInputPlus
              style={array([viewStyle(~width=100.->pct, ())])}
              textInputStyle={array([
                Font.ios["body"],
                theme.styles["text"],
                viewStyle(
                  ~borderWidth=1.,
                  ~borderColor=hasError_passwordConfirmation
                    ? theme.colors.systemRed
                    : theme.colors.textLight1,
                  ~borderStyle=#solid,
                  ~borderRadius=6.,
                  (),
                ),
              ])}
              styleFocused={array([
                viewStyle(
                  ~borderColor=hasError_password ? theme.colors.systemRed : theme.colors.systemBlue,
                  (),
                ),
              ])}
              placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
              placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
              placeholder={t(. "-Form-Placeholder-passwordConfirmation")}
              noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
              note=passwordConfirmation_note
              value={passwordConfirmation}
              onChangeText={passwordConfirmation_change}
              textContentType=#password
              secureTextEntry={true}
              onSubmitEditing={_ => handleSubmit()}
            />
          </View>
          <Spacer size=M />
          <Spacer size=XS />
          <TouchableOpacity onPress={_ => handleSubmit()} style={viewStyle(~width=100.->pct, ())}>
            <ButtonView mode=Contained color={theme.colors.main} activityIndicator=false>
              <Text style={array([Font.iosEm["button"], theme.styles["textOnMain"]])}>
                {t(. "-Continue")->React.string}
              </Text>
            </ButtonView>
          </TouchableOpacity>
          {!success
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#green
                  title={t(. "AuthPasswordReset-MessageSuccess")}
                  detail={t(. "AuthPasswordReset-MessageSuccessDetail")}
                  detailHref={"/auth/login"}
                />
              </>}
          {!tokenInvalid_error
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#red
                  title={t(. "AuthPasswordReset-MessageError")}
                  detail={t(. "AuthPasswordReset-MessageErrorDetail")}
                />
              </>}
          {backendRemainingErrors->Js.Array.length === 0
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#red
                  title={t(. "AuthPasswordReset-MessageError")}
                  detail={t(. "AuthPasswordReset-MessageErrorDetail")}
                />
              </>}
          <Spacer size=L />
          <View
            style={viewStyle(
              ~width=50.->pct,
              ~backgroundColor=theme.colors.systemGray5,
              ~height=1.->dp,
              (),
            )}
          />
          <Spacer size=L />
          <LinkText
            href="/auth/login"
            style={array([
              Font.ios["footnote"],
              Font.weight["300"],
              theme.styles["textBlue"],
              textStyle(~textDecorationLine=#underline, ()),
            ])}>
            {t(. "AuthLogin-Title")->React.string}
          </LinkText>
          <Spacer size=XL />
          <IfDev.Dump> {backendRemainingErrors} </IfDev.Dump>
        </ViewContained>
      </SpacedView>
    </View>
    <WebsiteFooter />
  </WebsiteWrapper>
}

let default = make
