open ReactNative
open ReactNative.Style
open ReactMultiversal

@react.component
let make = () => {
  <View style={array([Predefined.styles["flex"], Predefined.styles["justifyCenter"]])}>
    <ActivityIndicator size=ActivityIndicator.Size.large />
  </View>
}
