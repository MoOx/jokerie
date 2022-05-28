// export { getStaticPaths } from "../src/pages/PagePasswordForgot.bs.js";
// export { getStaticProps } from "../src/pages/PagePasswordForgot.bs.js";
import page from "../../src/pages/PageAuthPasswordForgot.bs.js";
export default page;

import { serverSideTranslations } from "next-i18next/serverSideTranslations";

export async function getStaticProps({ locale }) {
  return {
    props: {
      ...(await serverSideTranslations(locale, ["common"])),
    },
  };
}
