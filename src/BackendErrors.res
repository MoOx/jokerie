open ReScriptJs

@send external everyWithIndex: (array<'a>, ('a, int) => bool) => bool = "every"

let arrayOfStringEquals = (a: array<string>, b: array<string>) => {
  a->Array.length == b->Array.length && a->everyWithIndex((val, index) => Some(val) === b[index])
}

type rec error = {
  details: option<details>,
  message: option<string>,
  name: option<[#ApplicationError | #ValidationError]>,
  path: option<array<string>>,
}
and details = {errors: option<array<error>>}

type extensions = {
  code: option<[#BAD_USER_INPUT | #STRAPI_APPLICATION_ERROR]>,
  error: option<error>,
}
type errorWrapper = {
  message: option<string>,
  extensions: option<extensions>,
}
type t = {errors: option<array<errorWrapper>>}
type sourcedT = {
  message: string,
  source: option<t>,
}

let flattenErrorWrapper = (errors: array<errorWrapper>): array<error> => {
  errors->Array.reduce([], (acc, error) => {
    error.extensions
    ->Option.flatMap(extension => extension.error)
    ->Option.flatMap(error => {
      if (
        error.details
        ->Option.map(details => details.errors->Option.getWithDefault([])->Array.length > 0)
        ->Option.getWithDefault(false)
      ) {
        error.details
        ->Option.flatMap(details => details.errors)
        ->Option.map(ers => acc->Array.concat(ers))
      } else {
        Some(acc->Array.concat([error]))
      }
    })
    ->Option.getWithDefault(acc)
  })
}

let flattenError = (error: t): array<error> => {
  error.errors->Option.map(flattenErrorWrapper)->Option.getWithDefault([])
}

let pathEquals = (path: option<array<string>>, path2: array<string>) => {
  path->Option.map(arrayOfStringEquals(path2))->Option.getWithDefault(false)
}

let filterByPath = (errors: option<array<error>>, path: array<string>) => {
  errors
  ->Option.map(errors => {
    let matchingErrors = errors->Array.keep(error => error.path->pathEquals(path))
    (matchingErrors, errors->Array.keep(error => matchingErrors->Js.Array.indexOf(error) == -1))
  })
  ->Option.getWithDefault(([], []))
}

let refineError = (error: RescriptRelay.mutationError): array<error> => {
  let e: sourcedT = error->Obj.magic
  e.source
  ->Option.map(s => s->flattenError)
  ->Option.getWithDefault([{message: Some(e.message), details: None, path: None, name: None}])
}

let refineErrors = (errors: option<array<RescriptRelay.mutationError>>): option<array<error>> => {
  errors->Option.map(errors => errors->Obj.magic->flattenErrorWrapper)
}

let filterByMessage = (errors: option<array<error>>, message: string) => {
  errors
  ->Option.map(errors => {
    let matchingErrors =
      errors->Array.keep(error => error.message->Option.getWithDefault("") == message)
    (matchingErrors, errors->Array.keep(error => matchingErrors->Js.Array.indexOf(error) == -1))
  })
  ->Option.getWithDefault(([], []))
}

// let filterByMessages = (errors: option<array<error>>, message: array<string>) => {
//   errors
//   ->Option.map(errors => {
//     let matchingErrors =
//       errors->Array.keep(error => error.message->Option.getWithDefault("") == message)
//     (matchingErrors, errors->Array.keep(error => matchingErrors->Js.Array.indexOf(error) == -1))
//   })
//   ->Option.getWithDefault(([], []))
// }

let report = (errors: array<error>) =>
  errors->Array.forEach(err => {
    err.message
    ->Option.getWithDefault("unknown backend error")
    ->Sentry.Browser.captureMessageWithExtra(Sentry.extras(~extra={"error": err}, ()))
  })
