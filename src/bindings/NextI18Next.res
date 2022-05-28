@module("next-i18next/serverSideTranslations")
external serverSideTranslations: (string, array<string>) => Js.Promise.t<Js.t<'a>> =
  "serverSideTranslations"

type translation = {t: (. string) => string}
@module("next-i18next")
external useTranslation: unit => translation = "useTranslation"
