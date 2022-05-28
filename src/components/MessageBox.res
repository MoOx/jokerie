open ReactNative
open ReactNative.Style
open ReactMultiversal

@react.component
let make = (~title, ~detail=?, ~detailHref=?, ~color: [#green | #yellow | #red]=#yellow) => {
  let theme = T.useTheme()
  let (borderColor, backgroundColor, backgroundColorAlpha) = switch color {
  | #green => (theme.colors.systemGreen, Predefined.Colors.Ios.light.green, 0.05)
  | #yellow => (theme.colors.systemOrange, Predefined.Colors.Ios.light.yellow, 0.35)
  | #red => (theme.colors.systemRed, Predefined.Colors.Ios.light.red, 0.05)
  }
  <SpacedView
    vertical=S
    horizontal=S
    style={array([
      viewStyle(
        ~borderColor,
        ~borderWidth=1.,
        ~borderRadius=6.,
        ~backgroundColor={
          open RescriptTinycolor.TinyColor
          backgroundColor
          ->makeFromString
          ->Option.map(c => c->setAlpha(backgroundColorAlpha, _))
          ->Option.map(c => c->toString)
          ->Option.getWithDefault("")
        },
        (),
      ),
    ])}>
    <Text
      style={array([
        Font.iosEm["subhead"],
        theme.styles["text"],
        textStyle(~textAlign=#center, ~opacity=0.75, ()),
      ])}>
      {title->React.string}
    </Text>
    {detail
    ->Option.map(detail => {
      <>
        <Spacer size=XXS />
        {detailHref
        ->Option.map(href => {
          <LinkText
            href
            underline={true}
            style={array([
              Font.ios["footnote"],
              theme.styles["text"],
              textStyle(~textAlign=#center, ~opacity=0.75, ()),
            ])}>
            {detail->React.string}
          </LinkText>
        })
        ->Option.getWithDefault(
          <Text
            style={array([
              Font.ios["footnote"],
              theme.styles["text"],
              textStyle(~textAlign=#center, ~opacity=0.75, ()),
            ])}>
            {detail->React.string}
          </Text>,
        )}
      </>
    })
    ->Option.getWithDefault(React.null)}
  </SpacedView>
}
