open ReactMultiversal

@react.component
let make = (
  ~href,
  // ButtonView props
  ~accessibilityLabel=?,
  ~activityIndicator=?,
  ~children,
  ~color=?,
  ~color2=?,
  ~horizontalSpace: option<SpacedView.size>=?,
  ~mode: option<ButtonView.mode>=?,
  ~round=?,
  ~style=?,
  ~textStyle=?,
  ~verticalSpace: option<SpacedView.size>=?,
  (),
) =>
  <LinkView href>
    <ButtonView
      ?accessibilityLabel
      ?activityIndicator
      ?color
      ?color2
      ?horizontalSpace
      ?mode
      ?round
      ?style
      ?textStyle
      ?verticalSpace>
      children
    </ButtonView>
  </LinkView>
