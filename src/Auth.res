module Session = {
  type user = {
    name: Js.nullable<string>,
    email: Js.nullable<string>,
    image: Js.nullable<string>,
    // defined in
    // pages/api/auth/[...nextauth].js / session
    id: Js.nullable<string>,
    jwt: Js.nullable<string>,
  }
}
include NextAuth.MakeSession(Session)

let login = (email, password, router, onError) => {
  NextAuth.signInUsingWithOptions(
    "credentials",
    {
      "email": email,
      "password": password,
      "redirect": false,
    },
  )
  ->Promise.then(result => {
    Js.Console.log2("login", result)
    if result.ok {
      router->Next.Router.push(
        // result.url->Option.getWithDefault("/") // will contain /auth/login itself...
        router.query->Js.Dict.get("next")->Option.getWithDefault("/"),
      )
    } else {
      onError(result)
    }
    Promise.resolve()
  })
  ->ignore
}

let logout = NextAuth.signOut
