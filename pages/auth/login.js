// export { getStaticPaths } from "../src/pages/PageAuthLogin.bs.js";
// export { getStaticProps } from "../src/pages/PageAuthLogin.bs.js";
import page from "../../src/pages/PageAuthLogin.bs.js";
export default page;

import { serverSideTranslations } from "next-i18next/serverSideTranslations";

export async function getStaticProps({ locale }) {
  return {
    props: {
      ...(await serverSideTranslations(locale, ["common"])),
    },
  };
}
