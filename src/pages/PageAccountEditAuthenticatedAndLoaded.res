open ReactNative
open ReactNative.Style
open ReactMultiversal

module EditUserMutation = %relay(`
  mutation PageAccountEditAuthenticatedAndLoaded_editUser_Mutation(
    $id: ID!
    $data: UsersPermissionsUserInput!
  ) {
    updateUsersPermissionsUser(id: $id, data: $data) {
      data {
        id
        attributes {
          username
          email
        }
      }
    }
  }
`)

let backendErrorCode_username_alreadyTaken = "Username is already taken"
let backendErrorCode_email_alreadyTaken = "Email is already taken"

@react.component
let make = (
  ~userId: string,
  ~userDataAttributes: PageAccountEditAuthenticated_getUser_Query_graphql.Types.response_usersPermissionsUser_data_attributes,
) => {
  open ReScriptJs

  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()
  // let router = Next.Router.useRouter()
  // let session = Auth.useSession()

  let (fullname, fullname_set) = React.useState(_ =>
    userDataAttributes.fullname->Option.getWithDefault("")
  )
  let (fullname_note, fullname_note_set) = React.useState(_ => "")
  let fullname_change = React.useCallback1(text => fullname_set(_ => text), [])

  let (username, username_set) = React.useState(_ => userDataAttributes.username)
  let (username_note, username_note_set) = React.useState(_ => "")
  let username_change = React.useCallback1(text => username_set(_ => text), [])

  let (bio, bio_set) = React.useState(_ => userDataAttributes.bio->Option.getWithDefault(""))
  let (bio_note, bio_note_set) = React.useState(_ => "")
  let bio_change = React.useCallback1(text => bio_set(_ => text), [])

  let (email, email_set) = React.useState(_ => userDataAttributes.email)
  let (email_note, email_note_set) = React.useState(_ => "")
  let email_change = React.useCallback1(text => email_set(_ => text), [])

  let (usernameTaken_error, usernameTaken_error_set) = React.useState(_ => false)
  let (emailTaken_error, emailTaken_error_set) = React.useState(_ => false)

  let (success, success_set) = React.useState(_ => false)
  let (backendErrors, backendErrors_set) = React.useState(_ => None)
  let (backendRemainingErrors, backendRemainingErrors_set) = React.useState(_ => [])

  let (editUser_mutate, editUser_isMutating) = EditUserMutation.use()
  let handleSubmit = React.useCallback5(() => {
    success_set(_ => false)

    let clientSideErrors = ref(false)

    if clientSideErrors.contents === false {
      usernameTaken_error_set(_ => false)
      emailTaken_error_set(_ => false)
      backendErrors_set(_ => None)

      editUser_mutate(
        ~variables={
          id: userId,
          data: {
            fullname: Some(fullname),
            username: Some(username),
            bio: Some(bio),
            email: Some(email),
            provider: None,
            password: None,
            resetPasswordToken: None,
            confirmationToken: None,
            confirmed: None,
            blocked: None,
            role: None,
            profilePicture: None,
            link_website: None,
            link_instagram: None,
            link_tiktok: None,
            link_facebook: None,
            link_youtube: None,
            link_twitter: None,
            email_public: None,
          },
        },
        ~onError=error => {
          Js.Console.log2("onError", error)
          backendErrors_set(_ => Some(error->BackendErrors.refineError))
        },
        ~onCompleted=(completeResult, errors) => {
          Js.Console.log3("onCompleted", completeResult, errors)
          backendErrors_set(_ => errors->BackendErrors.refineErrors)
          if completeResult.updateUsersPermissionsUser.data->Option.isSome {
            success_set(_ => true)
            // email_set(_ => "")
            // password_set(_ => "")
          }
        },
        (),
      )->ignore
    }
  }, (userId, fullname, username, bio, email))

  React.useEffect1(() => {
    let remainingErrors = backendErrors->Option.getWithDefault([])

    let (new_fullname_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["fullname"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        // | Some(#ValidationError) if er.message === Some("fullname is a required field") => (
        //     selected->Array.concat([t(. "-Form-ValidationError-fullname")]),
        //     rejected,
        //   )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_fullname_note !== fullname_note {
      fullname_note_set(_ => new_fullname_note)
    }

    let (new_username_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["username"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError)
          if er.message === Some("username must be at least 1 characters") => (
            selected->Array.concat([t(. "-Form-ValidationError-username")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some("username is a required field") => (
            selected->Array.concat([t(. "-Form-ValidationError-username")]),
            rejected,
          )
        | Some(#ValidationError) if er.message === Some("username must be a valid username") => (
            selected->Array.concat([t(. "-Form-ValidationError-username")]),
            rejected,
          )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_username_note !== username_note {
      username_note_set(_ => new_username_note)
    }

    let (new_bio_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["bio"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        // | Some(#ValidationError) if er.message === Some("bio is a required field") => (
        //     selected->Array.concat([t(. "-Form-ValidationError-bio")]),
        //     rejected,
        //   )
        | _ => (selected, rejected->Array.concat([er]))
        }
      })
      (msgs->Js.Array.joinWith(", "), ignoredErrors->Array.concat(rejectedErrors))
    }
    if new_bio_note !== bio_note {
      bio_note_set(_ => new_bio_note)
    }

    let (new_email_note, remainingErrors) = {
      let (errors, ignoredErrors) = Some(remainingErrors)->BackendErrors.filterByPath(["email"])
      let (msgs, rejectedErrors) = errors->Array.reduce(([], []), (
        (selected, rejected),
        er: BackendErrors.error,
      ) => {
        switch er.name {
        | Some(#ValidationError) if er.message === Some("email must be at least 1 characters") => (
            selected->Array.concat([t(. "-Form-ValidationError-email")]),
            rejected,
          )
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

    let (new_usernameTaken_error, remainingErrors) =
      Some(remainingErrors)->BackendErrors.filterByMessage(backendErrorCode_username_alreadyTaken)
    if new_usernameTaken_error->Array.length > 0 {
      usernameTaken_error_set(_ => true)
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

  let fullname_hasError = fullname_note !== ""
  let username_hasError = username_note !== ""
  let bio_hasError = bio_note !== ""
  let email_hasError = email_note !== ""

  <WebsiteWrapper>
    <WebsiteHeader noCreate=true />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "AccountEdit-Title")->React.string}
          </Text>
          <Spacer />
          <TextInputPlus
            style={array([viewStyle(~width=100.->pct, ())])}
            textInputStyle={array([
              Font.ios["body"],
              theme.styles["text"],
              viewStyle(
                ~borderWidth=1.,
                ~borderColor=fullname_hasError ? theme.colors.systemRed : theme.colors.textLight1,
                ~borderStyle=#solid,
                ~borderRadius=6.,
                (),
              ),
            ])}
            styleFocused={array([
              viewStyle(
                ~borderColor=fullname_hasError ? theme.colors.systemRed : theme.colors.systemBlue,
                (),
              ),
            ])}
            placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
            placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
            placeholder={t(. "-Form-Placeholder-fullname")}
            noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
            note=fullname_note
            value={fullname}
            onChangeText={fullname_change}
            autoFocus=true
            keyboardType=#default
            textContentType=#nickname
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
                ~borderColor=username_hasError ? theme.colors.systemRed : theme.colors.textLight1,
                ~borderStyle=#solid,
                ~borderRadius=6.,
                (),
              ),
            ])}
            styleFocused={array([
              viewStyle(
                ~borderColor=username_hasError ? theme.colors.systemRed : theme.colors.systemBlue,
                (),
              ),
            ])}
            placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
            placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
            placeholder={t(. "-Form-Placeholder-username")}
            noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
            note=username_note
            value={username}
            onChangeText={username_change}
            autoFocus=true
            keyboardType=#default
            textContentType=#username
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
                ~borderColor=bio_hasError ? theme.colors.systemRed : theme.colors.textLight1,
                ~borderStyle=#solid,
                ~borderRadius=6.,
                (),
              ),
            ])}
            styleFocused={array([
              viewStyle(
                ~borderColor=bio_hasError ? theme.colors.systemRed : theme.colors.systemBlue,
                (),
              ),
            ])}
            placeholderExpandedStyle={array([Font.ios["body"], theme.styles["textLight1"]])}
            placeholderStyle={array([Font.ios["caption1"], theme.styles["textLight2"]])}
            placeholder={t(. "-Form-Placeholder-bio")}
            noteStyle={array([Font.ios["caption2"], theme.styles["textRed"]])}
            note=bio_note
            value={bio}
            onChangeText={bio_change}
            autoFocus=true
            keyboardType=#default
            textContentType=#none
            returnKeyType=#next
            multiline={true}
            numberOfLines={3}
            // maxLength
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
          <TouchableOpacity onPress={_ => handleSubmit()} style={viewStyle(~width=100.->pct, ())}>
            <ButtonView
              mode=Contained color={theme.colors.main} activityIndicator=editUser_isMutating>
              <Text style={array([Font.iosEm["button"], theme.styles["textOnMain"]])}>
                {t(. "-Save")->React.string}
              </Text>
            </ButtonView>
          </TouchableOpacity>
          {!success
            ? React.null
            : <>
                <Spacer /> <MessageBox color=#green title={t(. "AccountEdit-MessageSuccess")} />
              </>}
          {!usernameTaken_error
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#yellow
                  title={t(. "AccountEdit-MessageError-username-alreadyTaken")}
                  detail={t(. "AccountEdit-MessageErrorDetail-username-alreadyTaken")}
                  detailHref={"/auth/login"}
                />
              </>}
          {!emailTaken_error
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#yellow
                  title={t(. "AccountEdit-MessageError-email-alreadyTaken")}
                  detail={t(. "AccountEdit-MessageErrorDetail-email-alreadyTaken")}
                  detailHref={"/auth/login"}
                />
              </>}
          {backendRemainingErrors->Js.Array.length === 0
            ? React.null
            : <>
                <Spacer />
                <MessageBox
                  color=#red
                  title={t(. "AccountEdit-MessageError")}
                  detail={t(. "AccountEdit-MessageErrorDetail")}
                />
              </>}
          <Spacer size=XL />
          <IfDev.Dump> {backendRemainingErrors} </IfDev.Dump>
        </ViewContained>
      </SpacedView>
    </View>
    <WebsiteFooter />
  </WebsiteWrapper>
}
