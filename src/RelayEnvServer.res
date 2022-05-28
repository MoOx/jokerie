// https://reverecre.github.io/relay-nextjs/docs/configuration#routing-integration
let createServerEnvironment = (session: Js.Nullable.t<Auth.session>) => {
  // Js.Console.log(("createServerEnvironment", session))
  RelayEnv.makeEnvironment(session, None, true)
}
