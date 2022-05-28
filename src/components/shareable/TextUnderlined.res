open ReactNative
open ReactNative.Style
open ReactNative.Text

@react.component
let make = React.forwardRef((~underline: bool=false,
~underlineOnFocus: bool=false,
~style as styl=?,
// ~children,
// Text props
~accessibilityActions: option<array<Accessibility.actionInfo>>=?,
~accessibilityHint: option<string>=?,
~accessibilityLabel: option<string>=?,
~accessibilityRole: option<Accessibility.role>=?,
~accessibilityState: option<Accessibility.state>=?,
~accessible: option<bool>=?,
~adjustsFontSizeToFit: option<bool>=?,
~allowFontScaling: option<bool>=?,
~android_hyphenationFrequency: option<android_hyphenationFrequency>=?,
~ariaLevel: option<int>=?,
~children: option<React.element>=?,
~dataDetectorTypes: option<array<dataDetectorType>>=?,
~disabled: option<bool>=?,
~ellipsizeMode: option<ellipsizeMode>=?,
~maxFontSizeMultiplier: option<int>=?,
~minimumFontScale: option<float>=?,
~nativeID: option<string>=?,
~numberOfLines: option<int>=?,
~onAccessibilityAction: option<Accessibility.actionEvent => unit>=?,
~onLayout: option<Event.layoutEvent => unit>=?,
~onLongPress: option<Event.pressEvent => unit>=?,
~onPress: option<Event.pressEvent => unit>=?,
~onPressIn: option<Event.pressEvent => unit>=?,
~onPressOut: option<Event.pressEvent => unit>=?,
~onTextLayout: option<Event.textLayoutEvent => unit>=?,
~pressRetentionOffset: option<View.edgeInsets>=?,
~selectable: option<bool>=?,
~selectionColor: option<string>=?,
// ~style: option<Style.t>=?,
~suppressHighlighting: option<bool>=?,
~testID: option<string>=?,
~textBreakStrategy: option<textBreakStrategy>=?,
~value: option<string>=?,
// Gesture Responder props
~onMoveShouldSetResponder: option<Event.pressEvent => bool>=?,
~onMoveShouldSetResponderCapture: option<Event.pressEvent => bool>=?,
~onResponderEnd: option<Event.pressEvent => unit>=?,
~onResponderGrant: option<Event.pressEvent => unit>=?,
~onResponderMove: option<Event.pressEvent => unit>=?,
~onResponderReject: option<Event.pressEvent => unit>=?,
~onResponderRelease: option<Event.pressEvent => unit>=?,
~onResponderStart: option<Event.pressEvent => unit>=?,
~onResponderTerminate: option<Event.pressEvent => unit>=?,
~onResponderTerminationRequest: option<Event.pressEvent => bool>=?,
~onStartShouldSetResponder: option<Event.pressEvent => bool>=?,
~onStartShouldSetResponderCapture: option<Event.pressEvent => bool>=?,
// react-native-web 0.17 View props
~href: option<string>=?,
~hrefAttrs: option<Web.hrefAttrs>=?,
// react-native-web 0.17 View props, ClickProps
~onClick: option<ReactEvent.Mouse.t => unit>=?,
~onClickCapture: option<ReactEvent.Mouse.t => unit>=?,
~onContextMenu: option<ReactEvent.Mouse.t => unit>=?,
// react-native-web 0.17 View props, FocusProps
~onFocus: option<ReactEvent.Focus.t => unit>=?,
~onBlur: option<ReactEvent.Focus.t => unit>=?,
// react-native-web 0.17 View props, KeyboardProps
~onKeyDown: option<ReactEvent.Keyboard.t => unit>=?,
~onKeyDownCapture: option<ReactEvent.Keyboard.t => unit>=?,
~onKeyUp: option<ReactEvent.Keyboard.t => unit>=?,
~onKeyUpCapture: option<ReactEvent.Keyboard.t => unit>=?,
// react-native-web 0.17 View props, Mouse forwarded props
~onMouseDown: option<ReactEvent.Mouse.t => unit>=?,
~onMouseEnter: option<ReactEvent.Mouse.t => unit>=?,
~onMouseLeave: option<ReactEvent.Mouse.t => unit>=?,
~onMouseMove: option<ReactEvent.Mouse.t => unit>=?,
~onMouseOut: option<ReactEvent.Mouse.t => unit>=?,
~onMouseOver: option<ReactEvent.Mouse.t => unit>=?,
~onMouseUp: option<ReactEvent.Mouse.t => unit>=?,
ref_) => {
  let (hasMouseFocus, hasMouseFocus_set) = React.useState(_ => false)
  let handleMouseEnter = React.useCallback1(_ => {
    onMouseEnter->Option.map(cb => cb(_))->ignore
    hasMouseFocus_set(_ => true)
  }, [])
  let handleMouseLeave = React.useCallback1(_ => {
    onMouseLeave->Option.map(cb => cb(_))->ignore
    hasMouseFocus_set(_ => false)
  }, [])
  let (hasFocus, hasFocus_set) = React.useState(_ => false)
  let handleFocus = React.useCallback1(_ => {
    onFocus->Option.map(cb => cb(_))->ignore
    hasFocus_set(_ => true)
  }, [])
  let handleBlur = React.useCallback1(_ => {
    onBlur->Option.map(cb => cb(_))->ignore
    hasFocus_set(_ => false)
  }, [])

  let style = Style.arrayOption([
    Some(
      textStyle(
        ~textDecorationLine=underline || (underlineOnFocus && (hasFocus || hasMouseFocus))
          ? #underline
          : #none,
        (),
      ),
    ),
    styl,
  ])
  <Text
    ref=?{ref_->Js.Nullable.toOption->Option.map(ReactNative.Ref.value)}
    style
    onMouseEnter=handleMouseEnter
    onMouseLeave=handleMouseLeave
    onFocus=handleFocus
    onBlur=handleBlur
    ?accessibilityActions
    ?accessibilityHint
    ?accessibilityLabel
    ?accessibilityRole
    ?accessibilityState
    ?accessible
    ?adjustsFontSizeToFit
    ?allowFontScaling
    ?android_hyphenationFrequency
    ?ariaLevel
    ?children
    ?dataDetectorTypes
    ?disabled
    ?ellipsizeMode
    ?maxFontSizeMultiplier
    ?minimumFontScale
    ?nativeID
    ?numberOfLines
    ?onAccessibilityAction
    ?onLayout
    ?onLongPress
    ?onPress
    ?onPressIn
    ?onPressOut
    ?onTextLayout
    ?pressRetentionOffset
    ?selectable
    ?selectionColor
    // ?style
    ?suppressHighlighting
    ?testID
    ?textBreakStrategy
    ?value
    ?onMoveShouldSetResponder
    ?onMoveShouldSetResponderCapture
    ?onResponderEnd
    ?onResponderGrant
    ?onResponderMove
    ?onResponderReject
    ?onResponderRelease
    ?onResponderStart
    ?onResponderTerminate
    ?onResponderTerminationRequest
    ?onStartShouldSetResponder
    ?onStartShouldSetResponderCapture
    ?href
    ?hrefAttrs
    ?onClick
    ?onClickCapture
    ?onContextMenu
    // ?onFocus
    // ?onBlur
    ?onKeyDown
    ?onKeyDownCapture
    ?onKeyUp
    ?onKeyUpCapture
    ?onMouseDown
    // ?onMouseEnter
    // ?onMouseLeave
    ?onMouseMove
    ?onMouseOut
    ?onMouseOver
    ?onMouseUp
  />
})
