type scope = {@meth "setExtra": (string, string) => unit}

type event
type eventHint
type breadcrumb
type breadcrumbHint
type integration
type transport

type options = {
  blacklistUrls: option<array<Js.Re.t>>,
  whitelistUrls: option<array<Js.Re.t>>,
  debug: option<bool>,
  enabled: option<bool>,
  dsn: option<string>,
  defaultIntegrations: option<integration>,
  integrations: option<array<integration>>,
  ignoreErrors: option<array<Js.Re.t>>,
  transport: option<transport>,
  transportOptions: option<Js.Dict.t<string>>,
  release: option<string>,
  environment: option<string>,
  dist: option<string>,
  maxBreadcrumbs: option<int>,
  logLevel: option<int>,
  sampelRage: option<int>,
  attachStacktrace: option<bool>,
  beforeSend: option<(~event: event, ~hint: eventHint=?) => Js.Promise.t<Js.Nullable.t<event>>>,
  beforeBreadcrumb: option<
    (~breadcrumb: breadcrumb, ~hint: breadcrumbHint=?) => Js.Promise.t<Js.Nullable.t<event>>,
  >,
}

type extras<'user, 'extra> = {
  user: option<'user>,
  // req: option<'req>,
  tags: option<Js.Dict.t<string>>,
  extra: 'extra,
  // fingerprint: option<'fingerprint>,
  level: option<[#debug | #info | #warning | #error | #fatal]>,
}
@obj
external extras: (
  ~user: 'user=?,
  // ~req,
  ~tags: Js.Dict.t<string>=?,
  ~extra: 'extra=?,
  unit,
) => extras<'user, 'extra> = ""

module Browser = {
  @module("@sentry/browser")
  external make: option<options> => unit = "init"

  @module("@sentry/browser")
  external capturePromiseException: exn => unit = "captureException"

  @module("@sentry/browser")
  external captureException: 'a => unit = "captureException"

  @module("@sentry/browser")
  external captureMessage: string => unit = "captureMessage"

  @module("@sentry/browser")
  external captureMessageWithExtra: (string, extras<'user, 'extra>) => unit = "captureMessage"

  @module("@sentry/browser")
  external showReportDialog: unit => unit = "showReportDialog"

  @module("@sentry/browser")
  external withScope: scope => unit = "withScope"
}

module Node = {
  @module("@sentry/node")
  external make: option<options> => unit = "init"

  @module("@sentry/node")
  external capturePromiseException: exn => unit = "captureException"

  @module("@sentry/node")
  external captureException: 'a => unit = "captureException"

  @module("@sentry/node")
  external captureMessage: string => unit = "captureMessage"

  @module("@sentry/node")
  external withScope: scope => unit = "withScope"
}
