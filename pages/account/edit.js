// export { getStaticPaths } from "../src/pages/PageAccountEdit.bs.js";
// export { getStaticProps } from "../src/pages/PageAccountEdit.bs.js";
import page from "../../src/pages/PageAccountEdit.bs.js";
// export default page;
// import { node as pageQuery } from "../../src/__generated__/PageAccountEdit_getUser_Query_graphql.bs.js";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";

// export async function getStaticProps({ locale }) {
//   return {
//     props: {
//       ...(await serverSideTranslations(locale, ["common"])),
//     },
//   };
// }

import { getSession } from "next-auth/react";
export default page;
export async function getServerSideProps(context) {
  const session = await getSession(context);
  if (session === null) {
    return {
      redirect: {
        destination: "/auth/login?next=" + encodeURIComponent(context.pathname),
        permanent: false,
      },
    };
  }

  return {
    props: {
      session,
      ...(await serverSideTranslations(context.locale, ["common"])),
    },
  };
}

// import { withRelay } from "relay-nextjs";
// import * as RelayEnvClient from "../../src/RelayEnvClient.bs";
// import * as RelayEnvServer from "../../src/RelayEnvServer.bs";

// export default withRelay(page, null, {
//   // fallback: <Loading />,
//   variablesFromContext: (ctx) => {
//     // console.log("variablesFromContext", ctx);
//     // return ctx.query;
//     return { uuidFromSession: true };
//   },
//   createClientEnvironment: () => RelayEnvClient.getClientEnvironment(),
//   serverSideProps: getServerSideProps,
//   createServerEnvironment: async (ctx, serverSideProps) => {
//     console.log("serverSideProps.props.session", serverSideProps.props.session);
//     return RelayEnvServer.createServerEnvironment(
//       serverSideProps.props.session
//     );
//   },
// });
