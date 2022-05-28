open ReactNative
open ReactNative.Style
open ReactMultiversal

let styles = {
  "container": style(
    ~borderRadius=6.,
    ~justifyContent=#center,
    ~alignItems=#center,
    ~borderWidth=1.,
    (),
  ),
  "rounded": style(~borderRadius=100., ()),
  "activityIndicatorContainer": style(
    ~zIndex=1,
    ~position=#absolute,
    ~top=0.->dp,
    ~bottom=0.->dp,
    ~left=0.->dp,
    ~right=0.->dp,
    ~justifyContent=#center,
    ~alignItems=#center,
    (),
  ),
}->StyleSheet.create

type mode =
  | Contained
  | ContainedInverted
  | Outlined

@react.component
let make = (
  ~accessibilityLabel=?,
  ~activityIndicator=false,
  ~children,
  ~color as c1="black",
  ~color2 as c2="white",
  ~horizontalSpace as horizontal: SpacedView.size=M,
  ~mode: mode=Contained,
  ~round=false,
  ~style as s=?,
  ~textStyle=?,
  ~verticalSpace as vertical: SpacedView.size=S,
  _,
) =>
  <View
    ?accessibilityLabel
    style={arrayOption([
      Some(
        switch mode {
        | Contained => array([styles["container"], style(~backgroundColor=c1, ~borderColor=c1, ())])
        | ContainedInverted =>
          array([styles["container"], style(~backgroundColor=c1, ~borderColor="transparent", ())])
        | Outlined => array([styles["container"], style(~backgroundColor=c2, ~borderColor=c1, ())])
        },
      ),
      round ? Some(styles["rounded"]) : None,
      s,
    ])}>
    <SpacedView horizontal vertical>
      {activityIndicator
        ? <View style={styles["activityIndicatorContainer"]}>
            <ActivityIndicator
              size=ActivityIndicator.Size.small
              color={switch mode {
              | Contained => c2
              | ContainedInverted
              | Outlined => c1
              }}
            />
          </View>
        : React.null}
      <Text
        style={arrayOption([
          Some(
            switch mode {
            | Contained => style(~color=c2, ())
            | ContainedInverted => style(~color=c1, ())
            | Outlined => style(~color=c1, ())
            },
          ),
          Some(style(~opacity=activityIndicator ? 0. : 1., ())),
          textStyle,
        ])}>
        children
      </Text>
    </SpacedView>
  </View>
