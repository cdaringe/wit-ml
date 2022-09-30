const path = require("path");
const fs = require("fs");

const rootDirname = __dirname;
const cssDirname = path.join(rootDirname, "public/css");
const cssFilenames = fs
  .readdirSync(cssDirname)
  .map((v) => path.resolve(cssDirname, v));
console.log(cssFilenames);

const compiledRelativeDirname = "lib/es6";
module.exports = {
  components: `${compiledRelativeDirname}/**/[A-Z]*.js`,
  getExampleFilename(componentPath) {
    const exampleDirname = path.dirname(
      componentPath.replace(compiledRelativeDirname + "/", "")
    );
    const [, exampleBasename] = componentPath.match(/([a-zA-Z0-9]*)\.bs\.js/);
    const filename = path.join(exampleDirname, `${exampleBasename}.md`);
    console.log({ exampleDirname, filename });
    return filename;
  },
  require: [...cssFilenames],
  webpackConfig: {
    module: {
      rules: [
        {
          test: /\.css$/i,
          use: ["style-loader", "css-loader"],
        },
      ],
    },
  },
};
