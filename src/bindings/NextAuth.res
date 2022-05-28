type s<'user> = {
  user: option<'user>,
  expires: option<string>,
}

// type defaultUser = {
//   name: Js.nullable<string>,
//   email: Js.nullable<string>,
//   image: Js.nullable<string>,
// }

// type defaultSession = {
//   user: option<defaultUser>,
//   expires: option<string>,
// }

module type S = {
  type user
}

module MakeSession = (Session: S) => {
  type session = s<Session.user>

  type useSessionResult = {
    data: Js.nullable<session>,
    status: @string [#loading | #authenticated | #unauthenticated],
  }

  @module("next-auth/react")
  external useSession: unit => useSessionResult = "useSession"

  type useSessionOptions = {
    required: bool,
    onUnauthenticated: unit => unit,
  }
  @module("next-auth/react")
  external useSessionWithOptions: useSessionOptions => useSessionResult = "useSession"

  module SessionProvider = {
    @react.component @module("next-auth/react")
    external make: (~session: option<session>, ~children: React.element=?) => React.element =
      "SessionProvider"
  }
}

type signInResult = {
  error: option<string>,
  status: int,
  ok: bool,
  url: option<string>,
}

@module("next-auth/react")
external signIn: unit => Js.Promise.t<signInResult> = "signIn"

@module("next-auth/react")
external signInWithOptions: (_, 'options) => Js.Promise.t<signInResult> = "signIn"

@module("next-auth/react")
external signInUsing: string => Js.Promise.t<signInResult> = "signIn"

@module("next-auth/react")
external signInUsingWithOptions: (string, 'options) => Js.Promise.t<signInResult> = "signIn"
// @module("next-auth/react")
// external signInGoogle: @as("google") _ => unit = "signIn"

@module("next-auth/react")
external signOut: unit => unit = "signOut"

@module("next-auth/react")
external getSession: unit => Js.Promise.t<string> = "getSession"

@module("next-auth/react")
external getSessionWithContext: 'context => Js.Promise.t<string> = "getSession"

@module("next-auth/react")
external getCsrfToken: unit => Js.Promise.t<string> = "getCsrfToken"
