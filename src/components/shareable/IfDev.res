open ReScriptJs

open ReactNative
open ReactNative.Style
open ReactMultiversal

@val external process: 'a = "process"
@inline
let mode = "development"

module Render = {
  @react.component
  let make = (~children: unit => React.element) => {
    process["env"]["NODE_ENV"] === mode ? children() : React.null
  }
}

let makeProps = Render.makeProps
let make = Render.make

module Dump = {
  @react.component
  let make = (~children: 'a) => {
    let theme = T.useTheme(~mode=#dark, ())
    <Render>
      {() =>
        <SpacedView style={array([theme.styles["back"], viewStyle(~borderRadius=4., ())])}>
          <Text style={array([theme.styles["text"], textStyle(~fontFamily="monospace", ())])}>
            {children
            ->Obj.magic
            ->Js.JSON.stringifyAnyWithIndent(2)
            ->Option.getWithDefault("Failed to stringify")
            ->React.string}
          </Text>
        </SpacedView>}
    </Render>
  }
}
