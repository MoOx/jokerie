open ReactNative
open ReactNative.Style

let defaultIsActive = (href: string, router: Next.Router.router) =>
  router.asPath === href || router.asPath ++ "/" === href

@react.component
let make = (
  ~accessibilityLabel: option<string>=?,
  ~activeStyle: option<t>=?,
  ~children: React.element,
  ~href: string,
  ~isActive: (string, Next.Router.router) => bool=defaultIsActive,
  ~numberOfLines: option<int>=?,
  ~style as styl: option<t>=?,
  ~onPress: option<Event.pressEvent => unit>=?,
  ~underline: bool=false,
  ~underlineOnFocus: bool=false,
) => {
  let router = Next.Router.useRouter()
  let accessibilityRole = #link
  let style = arrayOption([styl, isActive(href, router) ? activeStyle : None])
  href->Js.String.startsWith("/")
    ? <Next.Link href={href}>
        <TextUnderlined
          href
          ?accessibilityLabel
          accessibilityRole
          ?numberOfLines
          style
          ?onPress
          underline
          underlineOnFocus>
          {children}
        </TextUnderlined>
      </Next.Link>
    : <TextUnderlined
        href
        ?accessibilityLabel
        accessibilityRole
        ?numberOfLines
        style
        onPress={event => {
          onPress->Option.map(onPress => onPress(_))->ignore
          Linking.openURL(href)->ignore
          event->Event.PressEvent.preventDefault
        }}
        underline
        underlineOnFocus>
        {children}
      </TextUnderlined>
}
