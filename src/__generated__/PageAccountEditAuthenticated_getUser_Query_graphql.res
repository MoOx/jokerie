/* @sourceLoc PageAccountEditAuthenticated.res */
/* @generated */
%%raw("/* @generated */")
module Types = {
  @@ocaml.warning("-30")

  type rec response_usersPermissionsUser_data_attributes = {
    bio: option<string>,
    email: string,
    fullname: option<string>,
    username: string,
  }
  and response_usersPermissionsUser_data = {
    attributes: option<response_usersPermissionsUser_data_attributes>,
    @live id: option<string>,
  }
  and response_usersPermissionsUser = {
    data: option<response_usersPermissionsUser_data>,
  }
  type response = {
    usersPermissionsUser: option<response_usersPermissionsUser>,
  }
  @live
  type rawResponse = response
  @live
  type variables = {
    uuid: string,
  }
  @live
  type refetchVariables = {
    uuid: option<string>,
  }
  @live let makeRefetchVariables = (
    ~uuid=?,
    ()
  ): refetchVariables => {
    uuid: uuid
  }

}

module Internal = {
  @live
  let variablesConverter: Js.Dict.t<Js.Dict.t<Js.Dict.t<string>>> = %raw(
    json`{}`
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

type queryRef

module Utils = {
  @@ocaml.warning("-33")
  open Types
  @live @obj external makeVariables: (
    ~uuid: string,
  ) => variables = ""


}

type relayOperationNode
type operationType = RescriptRelay.queryNode<relayOperationNode>


let node: operationType = %raw(json` (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "uuid"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "id",
        "variableName": "uuid"
      }
    ],
    "concreteType": "UsersPermissionsUserEntityResponse",
    "kind": "LinkedField",
    "name": "usersPermissionsUser",
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
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "fullname",
                "storageKey": null
              },
              {
                "alias": null,
                "args": null,
                "kind": "ScalarField",
                "name": "bio",
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
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "PageAccountEditAuthenticated_getUser_Query",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "PageAccountEditAuthenticated_getUser_Query",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "ff55255b1dbca6400d69d6dc0f3c306b",
    "id": null,
    "metadata": {},
    "name": "PageAccountEditAuthenticated_getUser_Query",
    "operationKind": "query",
    "text": "query PageAccountEditAuthenticated_getUser_Query(\n  $uuid: ID!\n) {\n  usersPermissionsUser(id: $uuid) {\n    data {\n      id\n      attributes {\n        username\n        email\n        fullname\n        bio\n      }\n    }\n  }\n}\n"
  }
};
})() `)

include RescriptRelay.MakeLoadQuery({
    type variables = Types.variables
    type loadedQueryRef = queryRef
    type response = Types.response
    type node = relayOperationNode
    let query = node
    let convertVariables = Internal.convertVariables
});
