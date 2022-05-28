open ReScriptJs

@val external process: 'a = "process"

exception Graphql_error(string)

let endpoint = "http://localhost:1337/graphql"

type variableFromSessionTrick = {uuidFromSession: option<bool>}

let makeFetchQuery: Js.Nullable.t<Auth.session> => RescriptRelay.Network.fetchFunctionPromise = (
  session: Js.Nullable.t<Auth.session>,
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  Js.Console.log4("Fetch query", session, operation, variables)

  let actualVariables: Js.JSON.t = if Obj.magic(variables).uuidFromSession === Some(true) {
    Js.Dict.fromArray([
      (
        "uuid",
        session
        ->Js.Nullable.toOption
        ->Option.flatMap(session => session.user)
        ->Option.flatMap(user => user.id->Js.Nullable.toOption)
        ->Option.getWithDefault(""),
      ),
    ])->Obj.magic
  } else {
    variables
  }

  open Fetch
  fetchWithInit(
    endpoint,
    RequestInit.make(
      ~method_=Post,
      // ~credentials=Include,
      ~body=Js.Dict.fromArray([
        ("query", Js.JSON.Encode.string(operation.text)),
        ("variables", actualVariables),
      ])
      ->Js.JSON.Encode.object
      ->Js.JSON.stringify
      ->BodyInit.make,
      ~headers=HeadersInit.make({
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": session
        ->Js.Nullable.toOption
        ->Option.flatMap(session => session.user)
        ->Option.flatMap(user => user.jwt->Js.Nullable.toOption)
        ->Option.map(jwt => "Bearer " ++ jwt)
        ->Option.getWithDefault(""),
      }),
      (),
    ),
  )
  ->Promise.then(resp =>
    if Response.ok(resp) {
      //resp->Response.json
      resp->Response.text
    } else {
      Js.Console.warn4("Fetch query error", session, operation, actualVariables)
      if process["env"]["NODE_ENV"] !== "development" {
        Sentry.Browser.captureMessageWithExtra(
          "Grapqhl error",
          Sentry.extras(
            ~user=session->Js.Nullable.toOption->Option.flatMap(session => session.user),
            ~extra={
              "operation": operation,
              "variables": actualVariables,
            },
            (),
          ),
        )
      }
      Promise.reject(Graphql_error("Request failed: " ++ Response.statusText(resp)))
    }
  )
  ->Promise.then(respText => {
    respText->RelayNextJs.parseExnWithReviver(RelayNextJs.withHydrateDatetime)->Promise.resolve
  })
}

let makeNetwork = (session: Js.Nullable.t<Auth.session>) =>
  RescriptRelay.Network.makePromiseBased(~fetchFunction=makeFetchQuery(session), ())

let makeEnvironment = (
  session: Js.Nullable.t<Auth.session>,
  records: option<RescriptRelay.recordSourceRecords>,
  isServer: bool,
) =>
  RescriptRelay.Environment.make(
    ~network=makeNetwork(session),
    ~store=RescriptRelay.Store.make(
      ~source=RescriptRelay.RecordSource.make(~records?, ()),
      ~gcReleaseBufferSize=10 /* This sets the query cache size to 10 */,
      (),
    ),
    ~isServer,
    (),
  )
