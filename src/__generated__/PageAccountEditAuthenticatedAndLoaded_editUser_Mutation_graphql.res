/* @sourceLoc PageAccountEditAuthenticatedAndLoaded.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  @live
  type rec usersPermissionsUserInput = {
    bio: option<string>,
    blocked: option<bool>,
    confirmationToken: option<string>,
    confirmed: option<bool>,
    email: option<string>,
    email_public: option<string>,
    fullname: option<string>,
    link_facebook: option<string>,
    link_instagram: option<string>,
    link_tiktok: option<string>,
    link_twitter: option<string>,
    link_website: option<string>,
    link_youtube: option<string>,
    password: option<string>,
    profilePicture: option<string>,
    provider: option<string>,
    resetPasswordToken: option<string>,
    role: option<string>,
    username: option<string>,
  }
  @live
  type rec response_updateUsersPermissionsUser_data_attributes = {
    email: string,
    username: string,
  }
  @live
  and response_updateUsersPermissionsUser_data = {
    attributes: option<response_updateUsersPermissionsUser_data_attributes>,
    @live id: option<string>,
  }
  @live
  and response_updateUsersPermissionsUser = {
    data: option<response_updateUsersPermissionsUser_data>,
  }
  @live
  type response = {
    updateUsersPermissionsUser: response_updateUsersPermissionsUser,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    data: usersPermissionsUserInput,
    @live id: string,
  }
}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{"usersPermissionsUserInput":{},"__root":{"data":{"r":"usersPermissionsUserInput"}}}`
  )
  @live
  let variablesConverterMap = ()
  @live
  let convertVariables = v => v->RescriptRelay.convertObj(
    variablesConverter,
    variablesConverterMap,
    Js.undefined
  )
  @live
  type wrapResponseRaw
  @live
  let wrapResponseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let wrapResponseConverterMap = ()
  @live
  let convertWrapResponse = v => v->RescriptRelay.convertObj(
    wrapResponseConverter,
    wrapResponseConverterMap,
    Js.null
  )
  @live
  type responseRaw
  @live
  let responseConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
  )
  @live
  let responseConverterMap = ()
  @live
  let convertResponse = v => v->RescriptRelay.convertObj(
    responseConverter,
    responseConverterMap,
    Js.undefined
  )
  type wrapRawResponseRaw = wrapResponseRaw
  @live
  let convertWrapRawResponse = convertWrapResponse
  type rawResponseRaw = responseRaw
  @live
  let convertRawResponse = convertResponse
}
module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live @obj external make_usersPermissionsUserInput: (
    ~bio: string=?,
    ~blocked: bool=?,
    ~confirmationToken: string=?,
    ~confirmed: bool=?,
    ~email: string=?,
    ~email_public: string=?,
    ~fullname: string=?,
    ~link_facebook: string=?,
    ~link_instagram: string=?,
    ~link_tiktok: string=?,
    ~link_twitter: string=?,
    ~link_website: string=?,
    ~link_youtube: string=?,
    ~password: string=?,
    ~profilePicture: string=?,
    ~provider: string=?,
    ~resetPasswordToken: string=?,
    ~role: string=?,
    ~username: string=?,
    unit
  ) => usersPermissionsUserInput = ""


  @live @obj external makeVariables: (
    ~data: usersPermissionsUserInput,
    ~id: string,
  ) => variables = ""


}

type relayOperationNode
type operationType = RescriptRelay.mutationNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "data"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "id"
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "data",
        "variableName": "data"
      },
      {
        "kind": "Variable",
        "name": "id",
        "variableName": "id"
      }
    ],
    "concreteType": "UsersPermissionsUserEntityResponse",
    "kind": "LinkedField",
    "name": "updateUsersPermissionsUser",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "UsersPermissionsUserEntity",
        "kind": "LinkedField",
        "name": "data",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "id",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "concreteType": "UsersPermissionsUser",
            "kind": "LinkedField",
            "name": "attributes",
            "plural": false,
            "selections": [
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "username",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "email",
                "storageKey": null
              }
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "PageAccountEditAuthenticatedAndLoaded_editUser_Mutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "PageAccountEditAuthenticatedAndLoaded_editUser_Mutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "a936811c4a52fbcb13eb372d8947c185",
    "id": null,
    "metadata": {},
    "name": "PageAccountEditAuthenticatedAndLoaded_editUser_Mutation",
    "operationKind": "mutation",
    "text": "mutation PageAccountEditAuthenticatedAndLoaded_editUser_Mutation(\n  $id: ID!\n  $data: UsersPermissionsUserInput!\n) {\n  updateUsersPermissionsUser(id: $id, data: $data) {\n    data {\n      id\n      attributes {\n        username\n        email\n      }\n    }\n  }\n}\n"
  }
};
})() `)


