open ReactNative
open ReactNative.Style

let styles = {
  "wrapper": style(
    ~flexGrow=1.,
    ~flexShrink=1.,
    ~width=100.->pct,
    // be careful if full with content
    // inside have shadow, overflow hidden will cut it (eg: login screen focused field on mobile)
    // ~overflow=#hidden,
    ~alignItems=#center,
    (),
  ),
  "container": style(~flexGrow=1., ~flexShrink=1., ~width=100.->pct, ()),
}->StyleSheet.create

let defaultMaxWidth = ref(980.->dp)
// let defaultMinWidth = ref(360.->dp)

@react.component
let make = (
  ~style as wrapperStyle=?,
  ~contentContainerStyle=?,
  ~maxWidth as maxW=defaultMaxWidth.contents,
  // ~minWidth as minW=defaultMinWidth.contents,
  ~children,
  (),
) =>
  <View style={arrayOption([Some(styles["wrapper"]), wrapperStyle])}>
    <View
      style={arrayOption([
        Some(styles["container"]),
        Some(style(~maxWidth=maxW, ())),
        // Some(style(~minWidth=minW, ())),
        contentContainerStyle,
      ])}>
      children
    </View>
  </View>
