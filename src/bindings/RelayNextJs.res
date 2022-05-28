open ReScriptJs

// https://github.com/RevereCRE/relay-nextjs/blob/6c56e286c685d3fe65bda06d6ef7c922af752fb5/src/wired/serialized_state.ts#L4
type serializedState = {
  records: option<RescriptRelay.recordSourceRecords>,
  // query
  // variables
}
@module("relay-nextjs")
external getRelaySerializedState: unit => option<serializedState> = "getRelaySerializedState"

type jsonReviver
@val external parseExnWithReviver: (string, jsonReviver) => Js.JSON.t = "JSON.parse"

@module("relay-nextjs/date")
external withHydrateDatetime: jsonReviver = "withHydrateDatetime"
