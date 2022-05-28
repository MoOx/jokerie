open ReactNative
open ReactNative.Style
open ReactMultiversal

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
  // let email_ref = React.useRef(Js.Nullable.null)
  let email_change = React.useCallback1(text => email_set(_ => text), [])
  let (password, password_set) = React.useState(_ => "")
  let password_change = React.useCallback1(text => password_set(_ => text), [])
  let password_ref = React.useRef(Js.Nullable.null)

  let (backendSimpleError, backendSimpleError_set) = React.useState(_ => None)
  React.useEffect1(() => {
    backendSimpleError
    ->Option.map(backendSimpleError => {
      Js.Console.warn2("login error", backendSimpleError)
      if backendSimpleError !== "CredentialsSignin" {
        Sentry.Browser.captureMessage(backendSimpleError)
      }
    })
    ->ignore
    None
  }, [backendSimpleError])
  let handleSubmit = React.useCallback2(() => {
    backendSimpleError_set(_ => None)
    Auth.login(email, password, router, result => backendSimpleError_set(_ => result.error))
  }, (email, password))

  let error_email = None
  let hasError_email = error_email->Option.isSome

  let error_password = None
  let hasError_password = error_password->Option.isSome

  <WebsiteWrapper>
    <WebsiteHeader noLogin=true />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "AuthLogin-Title")->React.string}
          </Text>
          <Spacer />
          <View style={viewStyle(~width=100.->pct, ())}>
            <TextInputPlus
              style={viewStyle(~width=100.->pct, ())}
              textInputStyle={array([
                Font.ios["body"],
                theme.styles["text"],
                viewStyle(
                  ~width=100.->pct,
                  ~borderWidth=1.,
                  ~borderColor=hasError_email ? theme.colors.systemRed : theme.colors.textLight1,
                  ~borderStyle=#solid,
                  ~borderRadius=6.,
                  (),
                ),
              ])}
              styleFocused={array([
                viewStyle(
                  ~borderColor=hasError_email ? theme.colors.systemRed : theme.colors.systemBlue,
                  (),
                ),
              ])}
              placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
              placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
              placeholder={t(. "-Form-Placeholder-email")}
              value={email}
              onChangeText={email_change}
              autoFocus=true
              keyboardType=#emailAddress
              textContentType=#emailAddress
              returnKeyType=#next
              onSubmitEditing={_ => handleSubmit()}
            />
          </View>
          <Spacer size=M />
          <Spacer size=XS />
          <TextInputPlus
            textInputRef={password_ref->Ref.value}
            style={array([viewStyle(~width=100.->pct, ())])}
            textInputStyle={array([
              Font.ios["body"],
              theme.styles["text"],
              viewStyle(
                ~width=100.->pct,
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
            value={password}
            onChangeText={password_change}
            textContentType=#password
            secureTextEntry={true}
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
          {backendSimpleError
          ->Option.map(_backendSimpleError => <>
            <Spacer />
            <MessageBox
              color=#yellow
              title={t(. "AuthLogin-MessageError")}
              detail={t(. "AuthLogin-MessageErrorDetail")}
              detailHref="/auth/password-forgot"
            />
          </>)
          ->Option.getWithDefault(React.null)}
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
            href="/auth/password-forgot"
            underlineOnFocus={true}
            style={array([Font.ios["footnote"], Font.weight["300"], theme.styles["textBlue"]])}>
            {t(. "AuthLogin-PasswordForgot")->React.string}
          </LinkText>
          <Spacer size=XL />
        </ViewContained>
      </SpacedView>
    </View>
    <WebsiteFooter />
  </WebsiteWrapper>
}

let default = make
