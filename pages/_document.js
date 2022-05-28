import * as React from "react";
import Document, { Html, Head, Main, NextScript } from "next/document";
import { AppRegistry } from "react-native";
import { getThemeHtmlId, getThemeStyleSheet } from "../src/T.bs.js";
import { createRelayDocument } from "relay-nextjs/document";

let appName = "App";

// Force Next-generated DOM elements to fill their parent's height
const normalizeNextElements = `
  html, body { height: 100%; }
  #__next {
    display: flex;
    flex-direction: column;
    height: 100%;
  }
`;

export default class extends Document {
  static async getInitialProps(ctx) {
    // relay init
    const relayDocument = createRelayDocument();
    const originalRenderPage = ctx.renderPage;
    ctx.renderPage = () =>
      originalRenderPage({ enhanceApp: (App) => relayDocument.enhance(App) });

    // react-native-web init
    AppRegistry.registerComponent(appName, () => Main);
    const { getStyleElement } = AppRegistry.getApplication(appName);

    const initialProps = await Document.getInitialProps(ctx);

    return {
      ...initialProps,
      // relay
      relayDocument,
      // react-native-web
      styles: React.Children.toArray([
        <style dangerouslySetInnerHTML={{ __html: normalizeNextElements }} />,
        getStyleElement(),
        getThemeStyleSheet(),
      ]),
    };
  }

  render() {
    const { relayDocument } = this.props;
    return (
      <Html className={getThemeHtmlId()}>
        <Head>
          <relayDocument.Script />
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}
