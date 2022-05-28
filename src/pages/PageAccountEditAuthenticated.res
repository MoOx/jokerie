// open ReactNative
// open ReactNative.Style
// open ReactMultiversal

module GetUserQuery = %relay(`
  query PageAccountEditAuthenticated_getUser_Query($uuid: ID!) {
    usersPermissionsUser(id: $uuid) {
      data {
        id
        attributes {
          username
          email
          # provider
          # confirmed
          # blocked
          # role
          # profilePicture
          fullname
          bio
          # link_website
          # link_instagram
          # link_tiktok
          # link_facebook
          # link_youtube
          # email_public
          # link_twitter
          # createdAt
          # updatedAt
        }
      }
    }
  }
`)

@react.component
let make = (~userId) => {
  open ReScriptJs
  Js.Console.log(("userId", userId))

  let queryData = GetUserQuery.use(
    ~variables={
      uuid: userId,
    },
    (),
  )

  Js.Console.log(("queryData", queryData))
  switch queryData.usersPermissionsUser {
  | None => <WebsiteLoader />
  | Some(user) => {
      Js.Console.log(("user", user))
      user.data
      ->Option.flatMap(data => data.attributes)
      ->Option.map(userDataAttributes =>
        <PageAccountEditAuthenticatedAndLoaded userId userDataAttributes />
      )
      ->Option.getWithDefault(<WebsiteError />)
    }
  }
}
