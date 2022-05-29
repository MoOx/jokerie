open ReScriptJs

// https://reverecre.github.io/relay-nextjs/docs/configuration#routing-integration
let clientEnv = ref(None)
let getClientEnvironment = (session: Js.Nullable.t<Auth.session>) => {
  if Js.typeof(Js.window) === #undefined {
    Js.Console.log(("getClientEnvironment", "undefined bye"))
    None
  } else {
    if clientEnv.contents === None {
      // Js.Console.log(("getClientEnvironment", "defining!", session))
      clientEnv.contents = Some(
        RelayEnv.makeEnvironment(
          session,
          RelayNextJs.getRelaySerializedState()->Option.flatMap(state => state.records),
          false,
        ),
      )
    }
    // Js.Console.log(("getClientEnvironment", "here you go", clientEnv.contents))
    clientEnv.contents
  }
}
