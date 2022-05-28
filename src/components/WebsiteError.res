open ReactNative
open ReactNative.Style
open ReactMultiversal
@react.component
let make = () => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()

  <WebsiteWrapper>
    <WebsiteHeader noLogin=true noCreate=true />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <SpacedView horizontal=S vertical=None>
        <ViewContained contentContainerStyle={Predefined.styles["alignCenter"]} maxWidth={340.->dp}>
          <Spacer size=XL />
          <Text style={array([Font.iosEm["largeTitle"], theme.styles["text"]])}>
            {t(. "-UnexpectedError")->React.string}
          </Text>
        </ViewContained>
      </SpacedView>
    </View>
    <WebsiteFooter />
  </WebsiteWrapper>
}
