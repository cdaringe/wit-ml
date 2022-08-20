const esbuild = require("esbuild");
const path = require("path");
const fs = require("fs");

const rootDirname = path.resolve(__dirname, `..`);
/**
 * esbuild config for monaco editor
 * @see https://github.com/microsoft/monaco-editor/blob/35eb0efbc039827432002ccc17b120eb0874d70f/samples/browser-esm-esbuild/build.js
 */
const workerEntryPoints = [
  "vs/language/json/json.worker.js",
  "vs/language/css/css.worker.js",
  "vs/language/html/html.worker.js",
  "vs/language/typescript/ts.worker.js",
  "vs/editor/editor.worker.js",
];

function build(opts) {
  return esbuild.build(opts).then(({ errors, warnings, ..._rest }) => {
    if (errors.length > 0) {
      console.error(errors);
      throw new Error(errors[0]);
    }
    if (warnings.length > 0) {
      console.error(result.warnings);
    }
  });
}

export const buildMonaco = () =>
  build({
    entryPoints: workerEntryPoints.map((entry) =>
      path.resolve(rootDirname, `node_modules/monaco-editor/esm/${entry}`)
    ),
    bundle: true,
    format: "iife",
    outbase: path.resolve(rootDirname, "node_modules/monaco-editor/esm/"),
    outdir: path.join(__dirname, "dist"),
  });
