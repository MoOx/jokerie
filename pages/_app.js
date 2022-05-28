import * as React from "react";
import { init } from "@socialgouv/matomo-next";
import { appWithTranslation } from "next-i18next";

import { RelayEnvironmentProvider } from "react-relay/hooks";
import { getInitialPreloadedQuery, getRelayProps } from "relay-nextjs/app";
import { getClientEnvironment } from "../src/RelayEnvClient.bs";
import { SessionProvider } from "next-auth/react";

// react-native-web static init
if (typeof window === "undefined") {
  require("react-native").Dimensions.set({
    window: {
      width: 360,
      height: 640,
    },
    screen: {
      width: 360,
      height: 640,
    },
  });
}

const clientEnv = getClientEnvironment();
const initialPreloadedQuery = getInitialPreloadedQuery({
  createClientEnvironment: () => getClientEnvironment(),
});

function App({ Component, pageProps: { session, ...pageProps } }) {
  console.log("App", session, pageProps);

  React.useEffect(() => {
    if (process.env.NODE_ENV !== "development") {
      init({
        url: "https://a.moox.fr",
        jsTrackerFile: "m.js",
        phpTrackerFile: "m",
        siteId: 5,
      });
    }
  }, []);
  const relayProps = getRelayProps(pageProps, initialPreloadedQuery);
  const env = relayProps.preloadedQuery?.environment ?? clientEnv;

  return (
    <SessionProvider session={session}>
      <RelayEnvironmentProvider environment={env}>
        <Component {...pageProps} {...relayProps} />
      </RelayEnvironmentProvider>
    </SessionProvider>
  );
}

export default appWithTranslation(App);
