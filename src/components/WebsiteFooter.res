open ReactNative
open ReactNative.Style
open ReactMultiversal

@react.component
let make = () => {
  let theme = T.useTheme()
  <View style={array([theme.styles["back"]])}>
    <ViewContained>
      <SpacedView vertical=S horizontal=S style={Predefined.styles["rowSpaceBetween"]}>
        <Text style={array([Font.ios["caption"], theme.styles["textLight1"]])}>
          {`© 2022 Jokerie`->React.string}
        </Text>
        <LinkText
          style={array([Font.ios["caption"], theme.styles["textLight1"]])} href="https://moox.io">
          {`Made by MoOx`->React.string}
        </LinkText>
      </SpacedView>
    </ViewContained>
  </View>
}

let default = make
