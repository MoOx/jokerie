open ReScriptJs

let usernameDefaultPrefix = "user_"

let username = (name: string): string => {
  if name->Js.String.startsWith(usernameDefaultPrefix) {
    "..."
  } else {
    name
  }
}

let useRedirectNewUser = () => {
  let router = Next.Router.useRouter()
  let session = Auth.useSession()

  let sessionStatus = session.status
  let isAutoUsername =
    session.data
    ->Js.Nullable.toOption
    ->Option.flatMap(data => data.user)
    ->Option.flatMap(user => user.name->Js.Nullable.toOption)
    ->Option.getWithDefault("")
    ->Js.String.startsWith(usernameDefaultPrefix)

  React.useEffect3(() => {
    if (
      router.isReady &&
      sessionStatus === #authenticated &&
      isAutoUsername &&
      router.pathname !== "/account/edit" &&
      // because login already does a redirect
      router.pathname !== "/auth/login"
    ) {
      let timeout = Js.setTimeout(() => {
        Js.Console.warn4(
          "new user detected, redirecting to profile edition",
          sessionStatus,
          isAutoUsername,
          router.pathname,
        )
        router->Next.Router.push("/account/edit?next=" ++ Js.encodeURIComponent(router.pathname))
      }, 10)
      Some(() => Js.clearTimeout(timeout))
    } else {
      None
    }
  }, (router.pathname, sessionStatus, isAutoUsername))
}
