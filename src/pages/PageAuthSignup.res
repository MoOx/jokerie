open ReScriptJs

open ReactNative
open ReactNative.Style
open ReactMultiversal

module CreateUserMutation = %relay(`
  mutation PageAuthSignup_createUser_Mutation(
    $input: UsersPermissionsRegisterInput!
  ) {
    register(input: $input) {
      jwt
      user {
        email
      }
    }
  }
`)

let backendErrorCode_email_alreadyTaken = "Email is already taken"

@react.component
let make = () => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()
  let router = Next.Router.useRouter()
  let session = Auth.useSession()

  React.useEffect2(() => {
    if router.isReady && session.status === #authenticated {
      router->Next.Router.replace("/")
    }
    None
  }, (router, session.status))

  let (email, email_set) = React.useState(_ => "")
  let (email_note, email_note_set) = React.useState(_ => "")
  let email_change = React.useCallback1(text => email_set(_ => text), [])
  let (password, password_set) = React.useState(_ => "")
  let (password_note, password_note_set) = React.useState(_ => "")
  let password_change = React.useCallback1(text => password_set(_ => text), [])
  let (emailTaken_error, emailTaken_error_set) = React.useState(_ => false)

  let (success, success_set) = React.useState(_ => false)
  let (backendErrors, backendErrors_set) = React.useState(_ => None)
  let (backendRemainingErrors, backendRemainingErrors_set) = React.useState(_ => [])

  let (createUser_mutate, createUser_isMutating) = CreateUserMutation.use()
  let handleSubmit = React.useCallback2(() => {
    success_set(_ => false)

    let clientSideErrors = ref(false)
    if password->Js.String.length < 6 {
      password_note_set(_ => t(. "-Form-ValidationError-password"))
      clientSideErrors.contents = true
    }

    if clientSideErrors.contents === false {
      emailTaken_error_set(_ => false)
      backendErrors_set(_ => None)

      let date = Js.Date.make()
      let stringDate =
        date->Js.Date.getUTCFullYear->Js.Int.toString ++
        (date->Js.Date.getUTCMonth + 1)->Js.Int.toString->Js.String.padStart(2, "0") ++
        date->Js.Date.getUTCDate->Js.Int.toString->Js.String.padStart(2, "0") ++
        date->Js.Date.getUTCHours->Js.Int.toString->Js.String.padStart(2, "0") ++
        date->Js.Date.getUTCMinutes->Js.Int.toString->Js.String.padStart(2, "0") ++
        date->Js.Date.getUTCSeconds->Js.Int.toString->Js.String.padStart(2, "0")

      createUser_mutate(
        ~variables={
          input: {
            username: Username.defaultUserNamePrefix ++
            stringDate ++
            Js.Math.random()->Js.Float.toString,
            email: email,
            password: password,
          },
        },
        ~onError=error => {
          Js.Console.log2("onError", error)
          backendErrors_set(_ => Some(error->BackendErrors.refineError))
        },
        ~onCompleted=(completeResult, errors) => {
          Js.Console.log3("onCompleted", completeResult, errors)
          backendErrors_set(_ => errors->BackendErrors.refineErrors)
          if completeResult.register.jwt->Option.isSome {
            success_set(_ => true)
            // email_set(_ => "")
            // password_set(_ => "")
          }
        },
        (),
      )->ignore
    }
  }, (email, password))

  React.useEffect1(() => {
    if success && backendErrors->Option.getWithDefault([])->Array.length === 0 {
      Auth.login(email, password, router, ignore)
    }
    None
  }, [success])

  React.useEffect1(() => {
    let remainingErrors = backendErrors->Option.getWithDefault([])
    let (new_email_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["email"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError) if er.message === Some("email is a required field") => (
            selected->Array.concat([t(. "-Form-ValidationError-email")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some("email must be a valid email") => (
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

    let (new_password_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["password"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError) if er.message === Some("password is a required field") => (
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

    let (new_emailTaken_error, remainingErrors) =
      Some(remainingErrors)->BackendErrors.filterByMessage(backendErrorCode_email_alreadyTaken)
    if new_emailTaken_error->Array.length > 0 {
      emailTaken_error_set(_ => true)
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
  let password_hasError = password_note !== ""

  <WebsiteWrapper>
    <WebsiteHeader noCreate=true />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "AuthSignup-Title")->React.string}
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
            returnKeyType=#next
            onSubmitEditing={_ => handleSubmit()}
          />
          <Spacer size=M />
          <Spacer size=XS />
          <TextInputPlus
            style={array([viewStyle(~width=100.->pct, ())])}
            textInputStyle={array([
              Font.ios["body"],
              theme.styles["text"],
              viewStyle(
                ~borderWidth=1.,
                ~borderColor=password_hasError ? theme.colors.systemRed : theme.colors.textLight1,
                ~borderStyle=#solid,
                ~borderRadius=6.,
                (),
              ),
            ])}
            styleFocused={array([
              viewStyle(
                ~borderColor=password_hasError ? theme.colors.systemRed : theme.colors.systemBlue,
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
            textContentType=#newPassword
            secureTextEntry={true}
            onSubmitEditing={_ => handleSubmit()}
          />
          <Spacer size=M />
          <Spacer size=XS />
          <TouchableOpacity onPress={_ => handleSubmit()} style={viewStyle(~width=100.->pct, ())}>
            <ButtonView
              mode=Contained color={theme.colors.main} activityIndicator=createUser_isMutating>
              <Text style={array([Font.iosEm["button"], theme.styles["textOnMain"]])}>
                {t(. "-Continue")->React.string}
              </Text>
            </ButtonView>
          </TouchableOpacity>
          {!success
            ? React.null
            : <>
                <Spacer /> <MessageBox color=#green title={t(. "AuthSignup-MessageSuccess")} />
              </>}
          {!emailTaken_error
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#yellow
                  title={t(. "AuthSignup-MessageError-email-alreadyTaken")}
                  detail={t(. "AuthSignup-MessageErrorDetail-email-alreadyTaken")}
                  detailHref={"/auth/login"}
                />
              </>}
          {backendRemainingErrors->Js.Array.length === 0
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#red
                  title={t(. "AuthSignup-MessageError")}
                  detail={t(. "AuthSignup-MessageErrorDetail")}
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
            underlineOnFocus={true}
            style={array([Font.ios["footnote"], Font.weight["300"], theme.styles["textBlue"]])}>
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
