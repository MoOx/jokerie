const webpack = require("webpack");
const { withSentryConfig } = require("@sentry/nextjs");

const bsconfigJson = require("./bsconfig.json");
const packageJson = require("./package.json");
const modulesToTranspile = [
  // rescript & rescript deps
  "rescript",
  ...bsconfigJson["bs-dependencies"],
  ...Object.keys(packageJson.dependencies).filter((dep) =>
    dep.startsWith("react-native")
  ),
];
const withTM = require("next-transpile-modules")(modulesToTranspile);

const { i18n } = require("./next-i18next.config");

const config = {
  reactStrictMode: true,

  experimental: {
    reactRoot: "concurrent",
  },

  compiler: {
    relay: {
      src: "./",
      artifactDirectory: "./__generated__",
      language: "typescript",
    },
  },

  i18n,

  env: {
    ENV: process.env.NODE_ENV,
  },

  // rescript
  pageExtensions: ["jsx", "js", "bs.js"],

  webpack: (config, options) => {
    // https://reverecre.github.io/relay-nextjs/docs/installation-and-setup
    if (!options.isServer) {
      // Ensures no server modules are included on the client.
      config.plugins.push(
        new webpack.IgnorePlugin({ resourceRegExp: /lib\/server/ })
      );
    }

    config.resolve.alias = {
      ...(config.resolve.alias || {}),
      // Transform all direct `react-native` imports to `react-native-web`
      "react-native$": "react-native-web",
    };
    config.resolve.extensions = [
      ".web.js",
      ".web.jsx",
      ".web.ts",
      ".web.tsx",
      ...config.resolve.extensions,
    ];
    return config;
  },
};

const sentryWebpackPluginOptions = {
  // Additional config options for the Sentry Webpack plugin. Keep in mind that
  // the following options are set automatically, and overriding them is not
  // recommended:
  //   release, url, org, project, authToken, configFile, stripPrefix,
  //   urlPrefix, include, ignore
  silent: true, // Suppresses all logs
  // For all available options, see:
  // https://github.com/getsentry/sentry-webpack-plugin#options.
};

module.exports = withSentryConfig(withTM(config), sentryWebpackPluginOptions);
