// open ReactNative
// open ReactNative.Style
// open ReactMultiversal

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let session = Auth.useSession()

  React.useEffect2(() => {
    if router.isReady && session.status === #unauthenticated {
      router->Next.Router.replace("/")
    }
    None
  }, (router, session.status))

  let maybeUserId =
    session.data
    ->Js.Nullable.toOption
    ->Option.flatMap(s => s.user)
    ->Option.flatMap(user => user.id->Js.Nullable.toOption)

  React.useEffect2(() => {
    if router.isReady && session.status === #authenticated && maybeUserId->Option.isNone {
      let msg = "Something is wrong with the session, no user id"
      msg->Js.Console.error2(session.data)
      msg->Sentry.Browser.captureMessageWithExtra(Sentry.extras(~user=session.data, ()))
      router->Next.Router.replace("/")
    }
    None
  }, (router, session.status))

  maybeUserId
  ->Option.map(userId => <PageAccountEditAuthenticated userId />)
  ->Option.getWithDefault(<WebsiteLoader />)
}

let default = make
