open ReScriptJs

open ReactNative
open ReactNative.Style
open ReactMultiversal

@react.component
let make = (~noCreate=false, ~noLogin=false) => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()

  let router = Next.Router.useRouter()
  let session = Auth.useSession()

  <View style={array([theme.styles["back"]])}>
    <ViewContained>
      <SpacedView vertical=S horizontal=S style={Predefined.styles["rowSpaceBetween"]}>
        <LinkView href="/" style={Predefined.styles["flexShrink"]}>
          <SVGJokerie
            height={50.->dp}
            style={viewStyle(~maxWidth=100.->pct, ~minWidth=50.->dp, ())}
            fill=theme.colors.main
          />
        </LinkView>
        <Spacer />
        <View style={array([Predefined.styles["flexShrink"], Predefined.styles["rowWrapCenter"]])}>
          {switch session.status {
          | #unauthenticated => <>
              {noCreate
                ? React.null
                : <LinkView href="/auth/signup">
                    <SpacedView horizontal=S vertical=XS>
                      <Text
                        style={array([
                          Font.ios["button"],
                          Font.weight["400"],
                          theme.styles["text"],
                          textStyle(~textAlign=#center, ()),
                        ])}>
                        {t(. "Header-SignUp")->React.string}
                      </Text>
                    </SpacedView>
                  </LinkView>}
              {noLogin
                ? React.null
                : <LinkButton
                    href={"/auth/login?next=" ++ Js.encodeURIComponent(router.pathname)}
                    mode=Outlined
                    color2=theme.colors.main
                    horizontalSpace=S
                    verticalSpace=XS
                    textStyle={array([
                      Font.ios["button"],
                      Font.weight["400"],
                      theme.styles["textOnMain"],
                      textStyle(~textAlign=#center, ()),
                    ])}>
                    {t(. "Header-SignIn")->React.string}
                  </LinkButton>}
            </>
          | #loading => <ActivityIndicator size=ActivityIndicator.Size.small />
          | #authenticated => <>
              {session.data
              ->Js.Nullable.toOption
              ->Option.flatMap(sessionData => sessionData.user)
              ->Option.map(user => {
                user.name
                ->Js.Nullable.toOption
                ->Option.map(name => {
                  <Text style={array([Font.ios["footnote"], theme.styles["text"]])}>
                    {User.username(name)->React.string}
                  </Text>
                })
                ->Option.getWithDefault(React.null)
              })
              ->Option.getWithDefault(React.null)}
              <Spacer size=XXS />
              <TouchableOpacity onPress={_ => Auth.logout()}>
                <Text style={array([Font.ios["body"], theme.styles["text"]])}>
                  {`⨯`->React.string}
                </Text>
              </TouchableOpacity>
            </>
          }}
        </View>
      </SpacedView>
    </ViewContained>
  </View>
}

let default = make
