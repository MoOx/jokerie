// open ReactNative
// open ReactNative.Style
// open ReactMultiversal

let defaultUserNamePrefix = "user_"

@react.component
let make = (~name) => {
  if name->Js.String.startsWith(defaultUserNamePrefix) {
    ""
  } else {
    name
  }
}
