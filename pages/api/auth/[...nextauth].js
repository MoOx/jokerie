import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";

export default NextAuth({
  // Configure one or more authentication providers
  providers: [
    // https://next-auth.js.org/providers/apple
    // https://next-auth.js.org/providers/facebook
    // https://next-auth.js.org/providers/google
    // https://next-auth.js.org/providers/instagram
    // https://next-auth.js.org/providers/twitter
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: {
          label: "Email",
          type: "text",
        },
        password: {
          label: "Password",
          type: "password",
        },
      },
      async authorize(credentials) {
        let response = await fetch(
          process.env.NEXT_PUBLIC_API_URL + "/auth/local",
          {
            method: "POST",
            headers: {
              Accept: "application/json",
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              identifier: credentials.email,
              password: credentials.password,
            }),
          }
        );
        const data = await response.json();

        if (data) {
          console.log("User authorized", data.user);
          return { ...data.user, jwt: data.jwt };
        }
        return null;
      },
    }),
  ],
  session: {
    strategy: "jwt",
    maxAge: 60 * 60, // 60 * 60 * 24 * 30,
  },
  jwt: {
    // strapi
    // ? https://github.com/nextauthjs/next-auth/discussions/727
    // async encode() {},
    // async decode() {},
  },
  // https://next-auth.js.org/configuration/callbacks
  callbacks: {
    // async signIn({ user, account, profile, email, credentials }) {
    //   return true
    // },
    // async redirect({ url, baseUrl }) {
    //   return baseUrl
    // },
    async session({ session, token }) {
      // if (user) {
      //   session.user.name = user.username;
      // }
      if (session.user) {
        if (token.id && session.user.id !== token.id) {
          session.user.id = token.id;
        }
        session.user.jwt = token.jwt;
      }
      // console.log("session", session, token);
      return session;
    },
    async jwt({ token, user, account, profile, isNewUser }) {
      // console.log("jwt", token, user, account, profile, isNewUser);
      if (user) {
        // if (account.type == "credentials") {
        token.id = user.id;
        token.name = user.username;
        token.jwt = user.jwt;
        // } else {
        //   let response = await fetch(
        //     process.env.NEXT_PUBLIC_API_URL +
        //       `/auth/${account.provider}/callback?access_token=${account?.accessToken}`,
        //     params
        //   );
        //   const data = await response.json();
        //   token.jwt = data.jwt;
        //   token.id = data.user.id;
        // }
      }
      return token;
    },
  },
  pages: {
    newUser: "/auth/signup",
    signIn: "/auth/login",
  },
  debug: true,
});
