open ReactNative
open! TextInput
open! Style

let paddingRatio = 1.25

@react.component
let make = (
  // ~placeholderExpandedFontSize: float=17.,
  // ~placeholderFontSize: float=12.,
  ~note: option<string>=?,
  ~noteStyle: option<t>=?,
  ~padding: float=16.,
  ~placeholder: option<string>=?,
  ~placeholderExpandedStyle: option<t>=?,
  ~placeholderStyle: option<t>=?,
  ~style as containerStyle: option<t>=?,
  ~styleFocused as textInputStyleFocused: option<t>=?,
  ~textInputStyle: option<t>=?,
  ~textInputRef: option<ref>=?,
  // TextInput props
  ~allowFontScaling: option<bool>=?,
  ~autoCapitalize: option<autoCapitalize>=?,
  ~autoComplete: option<autoComplete>=?,
  ~autoCorrect: option<bool>=?,
  ~autoFocus: option<bool>=?,
  ~blurOnSubmit: option<bool>=?,
  ~caretHidden: option<bool>=?,
  ~clearButtonMode: option<
    @string
    [
      | #never
      | @as("while-editing") #whileEditing
      | @as("unless-editing") #unlessEditing
      | #always
    ],
  >=?,
  ~clearTextOnFocus: option<bool>=?,
  ~contextMenuHidden: option<bool>=?,
  ~defaultValue: option<string>=?,
  ~disableFullscreenUI: option<bool>=?,
  ~editable: option<bool>=?,
  ~enablesReturnKeyAutomatically: option<bool>=?,
  ~importantForAutofill: option<importantForAutofill>=?,
  ~inlineImageLeft: option<string>=?,
  ~inlineImagePadding: option<float>=?,
  ~inputAccessoryViewID: option<string>=?,
  ~keyboardAppearance: option<keyboardAppearance>=?,
  ~keyboardType: option<
    @string
    [
      | #default
      | @as("number-pad") #numberPad
      | @as("decimal-pad") #decimalPad
      | #numeric
      | @as("email-address") #emailAddress
      | @as("phone-pad") #phonePad
      | @as("ascii-capable") #asciiCapable
      | @as("numbers-and-punctuation") #numbersAndPunctuation
      | #url
      | @as("name-phone-pad") #namePhonePad
      | #twitter
      | @as("web-search") #webSearch
      | @as("visible-password") #visiblePassword
    ],
  >=?,
  ~maxFontSizeMultiplier: option<float>=?,
  ~maxLength: option<int>=?,
  ~multiline: option<bool>=?,
  ~numberOfLines: option<int>=?,
  ~onBlur: option<Event.targetEvent => unit>=?,
  ~onChange: option<changeEvent => unit>=?,
  ~onChangeText: option<string => unit>=?,
  ~onContentSizeChange: option<contentSizeChangeEvent => unit>=?,
  ~onEndEditing: option<editingEvent => unit>=?,
  ~onFocus: option<Event.targetEvent => unit>=?,
  ~onKeyPress: option<keyPressEvent => unit>=?,
  ~onPressIn: option<Event.pressEvent => bool>=?,
  ~onPressOut: option<Event.pressEvent => bool>=?,
  ~onScroll: option<scrollEvent => unit>=?,
  ~onSelectionChange: option<selectionChangeEvent => unit>=?,
  ~onSubmitEditing: option<editingEvent => unit>=?,
  //   ~placeholder: option<string>=?,
  //   ~placeholderTextColor: option<Color.t>=?,
  ~returnKeyLabel: option<string>=?,
  ~returnKeyType: option<
    @string
    [
      | @as("done") #done_
      | #go
      | #next
      | #search
      | #send
      | #none
      | #previous
      | #default
      | @as("emergency-call") #emergencyCall
      | #google
      | #join
      | #route
      | #yahoo
    ],
  >=?,
  ~rejectResponderTermination: option<bool>=?,
  ~scrollEnabled: option<bool>=?,
  ~secureTextEntry: option<bool>=?,
  ~selection: option<selection>=?,
  ~selectionColor: option<Color.t>=?,
  ~selectTextOnFocus: option<bool>=?,
  ~showSoftInputOnFocus: option<bool>=?,
  ~spellCheck: option<bool>=?,
  ~textBreakStrategy: option<textBreakStrategy>=?,
  ~textContentType: option<textContentType>=?,
  ~underlineColorAndroid: option<Color.t>=?,
  ~value: option<string>=?,
  // rescript-react-native 0.68 View props
  ~accessibilityActions: option<array<Accessibility.actionInfo>>=?,
  ~accessibilityElementsHidden: option<bool>=?,
  ~accessibilityHint: option<string>=?,
  ~accessibilityIgnoresInvertColors: option<bool>=?,
  ~accessibilityLabel: option<string>=?,
  ~accessibilityLabelledBy: option<array<string>>=?,
  ~accessibilityLiveRegion: option<Accessibility.liveRegion>=?,
  ~accessibilityRole: option<Accessibility.role>=?,
  ~accessibilityState: option<Accessibility.state>=?,
  ~accessibilityValue: option<Accessibility.value>=?,
  ~accessibilityViewIsModal: option<bool>=?,
  ~accessible: option<bool>=?,
  ~collapsable: option<bool>=?,
  ~hitSlop: option<View.edgeInsets>=?,
  ~importantForAccessibility: option<
    @string
    [
      | #auto
      | #yes
      | #no
      | @as("no-hide-descendants") #noHideDescendants
    ],
  >=?,
  ~nativeID: option<string>=?,
  ~needsOffscreenAlphaCompositing: option<bool>=?,
  ~onAccessibilityAction: option<Accessibility.actionEvent => unit>=?,
  ~onAccessibilityEscape: option<unit => unit>=?,
  ~onAccessibilityTap: option<unit => unit>=?,
  ~onLayout: option<Event.layoutEvent => unit>=?,
  ~onMagicTap: option<unit => unit>=?,
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
  ~pointerEvents: option<
    @string
    [
      | #auto
      | #none
      | @as("box-none") #boxNone
      | @as("box-only") #boxOnly
    ],
  >=?,
  ~removeClippedSubviews: option<bool>=?,
  ~renderToHardwareTextureAndroid: option<bool>=?,
  ~shouldRasterizeIOS: option<bool>=?,
  // ~style: option<Style.t>=?,
  ~testID: option<string>=?,
  ~children: option<React.element>=?,
) => {
  // // react-native-web 0.17 View props
  // // TextInput conflict // ~href: string=?,
  // // TextInput conflict // ~hrefAttrs: Web.hrefAttrs=?,
  // // react-native-web 0.17 View props, ClickProps
  // ~onClick: option<ReactEvent.Mouse.t => unit>=?,
  // ~onClickCapture: option<ReactEvent.Mouse.t => unit>=?,
  // ~onContextMenu: option<ReactEvent.Mouse.t => unit>=?,
  // // react-native-web 0.17 View props, FocusProps
  // // TextInput conflict // ~onFocus: option<ReactEvent.Focus.t => unit>=?,
  // // TextInput conflict // ~onBlur: option<ReactEvent.Focus.t => unit>=?,
  // // react-native-web 0.17 View props, KeyboardProps
  // ~onKeyDown: option<ReactEvent.Keyboard.t => unit>=?,
  // ~onKeyDownCapture: option<ReactEvent.Keyboard.t => unit>=?,
  // ~onKeyUp: option<ReactEvent.Keyboard.t => unit>=?,
  // ~onKeyUpCapture: option<ReactEvent.Keyboard.t => unit>=?,
  // // react-native-web 0.17 View props, Mouse forwarded props
  // ~onMouseDown: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseEnter: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseLeave: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseMove: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseOut: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseOver: option<ReactEvent.Mouse.t => unit>=?,
  // ~onMouseUp: option<ReactEvent.Mouse.t => unit>=?,

  let (isFocused, isFocused_set) = React.useState(_ => false)
  let handleFocus = React.useCallback1(e => {
    onFocus->Option.map(cb => cb(e))->ignore
    isFocused_set(_ => true)
  }, [])
  let handleBlur = React.useCallback1(e => {
    onBlur->Option.map(cb => cb(e))->ignore
    isFocused_set(_ => false)
  }, [])

  let (trackedValue, trackedValue_set) = React.useState(_ => value->Option.getWithDefault(""))
  let handleChangeText = React.useCallback1(newValue => {
    onChangeText->Option.map(cb => cb(newValue))->ignore
    trackedValue_set(_ => newValue)
  }, [])
  let placeholderExpanded = value->Option.getWithDefault(trackedValue) === "" && !isFocused
  <View style=?{containerStyle}>
    {placeholder
    ->Option.map(placeholder => {
      <View
        pointerEvents=#none
        style={arrayOption([
          Some(
            viewStyle(
              ~position=#absolute,
              ~top=(placeholderExpanded ? padding : padding /. 2.)->dp,
              ~paddingHorizontal=padding->dp,
              (),
            ),
          ),
        ])}>
        <Text
          style={arrayOption([
            placeholderStyle,
            !placeholderExpanded ? None : placeholderExpandedStyle,
          ])}>
          {placeholder->React.string}
        </Text>
      </View>
    })
    ->Option.getWithDefault(React.null)}
    <TextInput
      style={arrayOption([
        Some(
          viewStyle(
            ~paddingTop=(padding *. paddingRatio)->dp,
            ~paddingBottom=(padding *. 2. -. padding *. paddingRatio)->dp,
            ~paddingHorizontal=padding->dp,
            (),
          ),
        ),
        textInputStyle,
        !isFocused ? None : textInputStyleFocused,
      ])}
      ref=?textInputRef
      ?allowFontScaling
      ?autoCapitalize
      ?autoComplete
      ?autoCorrect
      ?autoFocus
      ?blurOnSubmit
      ?caretHidden
      ?clearButtonMode
      ?clearTextOnFocus
      ?contextMenuHidden
      ?defaultValue
      ?disableFullscreenUI
      ?editable
      ?enablesReturnKeyAutomatically
      ?importantForAutofill
      ?inlineImageLeft
      ?inlineImagePadding
      ?inputAccessoryViewID
      ?keyboardAppearance
      ?keyboardType
      ?maxFontSizeMultiplier
      ?maxLength
      ?multiline
      ?numberOfLines
      onBlur={handleBlur}
      ?onChange
      onChangeText={handleChangeText}
      ?onContentSizeChange
      ?onEndEditing
      onFocus={handleFocus}
      ?onKeyPress
      ?onPressIn
      ?onPressOut
      ?onScroll
      ?onSelectionChange
      ?onSubmitEditing
      // placeholder
      // placeholderTextColor
      ?returnKeyLabel
      ?returnKeyType
      ?rejectResponderTermination
      ?scrollEnabled
      ?secureTextEntry
      ?selection
      ?selectionColor
      ?selectTextOnFocus
      ?showSoftInputOnFocus
      ?spellCheck
      ?textBreakStrategy
      ?textContentType
      ?underlineColorAndroid
      ?value
      ?accessibilityActions
      ?accessibilityElementsHidden
      ?accessibilityHint
      ?accessibilityIgnoresInvertColors
      ?accessibilityLabel
      ?accessibilityLabelledBy
      ?accessibilityLiveRegion
      ?accessibilityRole
      ?accessibilityState
      ?accessibilityValue
      ?accessibilityViewIsModal
      ?accessible
      ?collapsable
      ?hitSlop
      ?importantForAccessibility
      ?nativeID
      ?needsOffscreenAlphaCompositing
      ?onAccessibilityAction
      ?onAccessibilityEscape
      ?onAccessibilityTap
      ?onLayout
      ?onMagicTap
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
      ?pointerEvents
      ?removeClippedSubviews
      ?renderToHardwareTextureAndroid
      ?shouldRasterizeIOS
      // style
      ?testID
      // react-native-web 0.17 View props
      // TextInput conflict // ?href
      // TextInput conflict // ?hrefAttrs
      // TextInput conflict // ?onBlur
      // ?onClick
      // ?onClickCapture
      // ?onContextMenu
      // // TextInput conflict // ?onFocus
      // ?onKeyDown
      // ?onKeyDownCapture
      // ?onKeyUp
      // ?onKeyUpCapture
      // ?onMouseDown
      // ?onMouseEnter
      // ?onMouseLeave
      // ?onMouseMove
      // ?onMouseOut
      // ?onMouseOver
      // ?onMouseUp
      ?children
    />
    {note
    ->Option.map(note =>
      <View style={viewStyle(~position=#absolute, ~bottom=-15.->dp, ~left=5.->dp, ())}>
        <Text style=?noteStyle> {note->React.string} </Text>
      </View>
    )
    ->Option.getWithDefault(React.null)}
  </View>
}
