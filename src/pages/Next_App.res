@react.component
let make = (~session: Js.Nullable.t<Auth.session>, ~children) => {
  // Js.Console.log(("Next_App session", session))
  <Auth.SessionProvider session={session->Js.Nullable.toOption}> {children} </Auth.SessionProvider>
}
