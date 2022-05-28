open ReScriptJs

open ReactNative
open ReactNative.Style
open ReactMultiversal

let backendErrorCode_bad_parameters = "Please provide a valid email address"

module PasswordForgotMutation = %relay(`
  mutation PageAuthPasswordForgotMutation($email: String!) {
    forgotPassword(email: $email) {
      ok
    }
  }
`)

@react.component
let make = () => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()

  let (email, email_set) = React.useState(_ => "")
  let (email_note, email_note_set) = React.useState(_ => "")
  let email_change = React.useCallback1(text => email_set(_ => text), [])

  let (success, success_set) = React.useState(_ => false)
  let (backendErrors, backendErrors_set) = React.useState(_ => None)
  let (backendRemainingErrors, backendRemainingErrors_set) = React.useState(_ => [])

  let (forgotPassword_mutate, _forgotPassword_isMutating) = PasswordForgotMutation.use()
  let handleSubmit = React.useCallback1(() => {
    success_set(_ => false)

    let clientSideErrors = ref(false)
    if email->Js.String.length < 3 {
      email_note_set(_ => t(. "-Form-ValidationError-email"))
      clientSideErrors.contents = true
    }

    if clientSideErrors.contents === false {
      backendErrors_set(_ => None)
      forgotPassword_mutate(
        ~variables={
          email: email,
        },
        ~onError=error => {
          Js.Console.log2("onError", error)
          backendErrors_set(_ => Some(error->BackendErrors.refineError))
        },
        ~onCompleted=(completeResult, errors) => {
          Js.Console.log3("onCompleted", completeResult, errors)
          backendErrors_set(_ => errors->BackendErrors.refineErrors)
          if completeResult.forgotPassword->Option.map(fp => fp.ok)->Option.getWithDefault(false) {
            // backendErrors_set(_ => None)
            success_set(_ => true)
          }
          // } else {
          //   email_note_set(_ => t(. "-Form-ValidationError-email"))
          // }
        },
        (),
      )->ignore
    }
  }, [email])

  React.useEffect1(() => {
    let remainingErrors = backendErrors->Option.getWithDefault([])
    Js.Console.warn(remainingErrors)
    let (new_email_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["email"])
      let (errors2, ignoredErrors) =
        Some(ignoredErrors)->BackendErrors.filterByMessage(backendErrorCode_bad_parameters)
      let errors = errors->Array.concat(errors2)
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError) if er.message === Some(backendErrorCode_bad_parameters) => (
            selected->Array.concat([t(. "-Form-ValidationError-email")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some("email is a required field") => (
            selected->Array.concat([t(. "-Form-ValidationError-email")]),
            rejected,
          )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_email_note !== email_note {
      email_note_set(_ => new_email_note)
    }

    if remainingErrors->Js.Array.length > 0 {
      backendRemainingErrors_set(_ => remainingErrors)
      remainingErrors->BackendErrors.report
    } else {
      backendRemainingErrors_set(_ => [])
    }

    None
  }, [backendErrors])

  let email_hasError = email_note !== ""

  <WebsiteWrapper>
    <WebsiteHeader />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "AuthPasswordForgot-Title")->React.string}
          </Text>
          <Spacer />
          <TextInputPlus
            style={array([viewStyle(~width=100.->pct, ())])}
            textInputStyle={array([
              Font.ios["body"],
              theme.styles["text"],
              viewStyle(
                ~borderWidth=1.,
                ~borderColor=email_hasError ? theme.colors.systemRed : theme.colors.textLight1,
                ~borderStyle=#solid,
                ~borderRadius=6.,
                (),
              ),
            ])}
            styleFocused={array([
              viewStyle(
                ~borderColor=email_hasError ? theme.colors.systemRed : theme.colors.systemBlue,
                (),
              ),
            ])}
            placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
            placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
            placeholder={t(. "-Form-Placeholder-email")}
            noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
            note=email_note
            value={email}
            onChangeText={email_change}
            autoFocus=true
            keyboardType=#emailAddress
            textContentType=#emailAddress
            returnKeyType=#send
            onSubmitEditing={_ => handleSubmit()}
          />
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
                  title={t(. "AuthPasswordForgot-MessageSuccess")}
                  detail={t(. "AuthPasswordForgot-MessageSuccessDetail")}
                />
              </>}
          {backendRemainingErrors->Js.Array.length === 0
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#red
                  title={t(. "AuthPasswordForgot-MessageError")}
                  detail={t(. "AuthPasswordForgot-MessageErrorDetail")}
                  detailHref="/auth/signup"
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
