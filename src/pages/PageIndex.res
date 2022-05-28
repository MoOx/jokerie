open ReactNative
open ReactNative.Style
open ReactMultiversal

@react.component
let make = () => {
  let theme = T.useTheme()
  let {t} = NextI18Next.useTranslation()

  <WebsiteWrapper>
    <WebsiteHeader />
    <View style={array([Predefined.styles["flexGrow"], theme.styles["back"]])}>
      <ImageBackground
        style={imageStyle(~height=500.->dp, ())}
        source={Image.uriSource(
          ~uri="/andy-cheetham-IWnpFDTsJ6s-unsplash.jpg",
          (),
        )->Image.Source.fromUriSource}>
        <ViewContained>
          <SpacedView horizontal=S>
            <Spacer size=XL />
            <Text style={array([Font.ios["title1"], T.themeDark.styles["text"]])}>
              {t(. "Index-Baseline")->React.string}
            </Text>
            <Spacer size=XL />
          </SpacedView>
        </ViewContained>
      </ImageBackground>
    </View>
    <WebsiteFooter />
  </WebsiteWrapper>
}

let default = make

// Node.js code must be in `pages` folder to be eliminated properly
// let getStaticProps: Next.Page.GetStaticProps.t<'props, 'params, 'previewData> = ({locale}) => {
//   NextI18Next.serverSideTranslations(locale, ["common"])->Promise.then(serverSideTranslations =>
//     Promise.resolve({
//       "props": serverSideTranslations,
//     })
//   )
// }
