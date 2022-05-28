open ReactNative.Style

@react.component
let make = (
  ~accessibilityLabel=?,
  ~href,
  ~style as styl=?,
  ~activeStyle=?,
  ~children,
  ~onPress: option<ReactNative.Event.pressEvent => unit>=?,
) =>
  <LinkText
    ?accessibilityLabel
    href
    style={arrayOption([Some(style(~display=#flex, ~flexDirection=#column, ())), styl])}
    ?activeStyle
    ?onPress>
    children
  </LinkText>
