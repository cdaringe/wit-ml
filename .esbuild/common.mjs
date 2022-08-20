import * as esbuild from "esbuild";
import * as path from "path";
import * as fs from "fs-extra";

export const rootDirname = path.resolve(
  path.dirname(import.meta.url.replace("file://", "")),
  `..`
);
export const publicDir = path.resolve(rootDirname, "public");
export const publicVendorDir = path.resolve(publicDir, "vendor");
export const publicMonacoDir = path.resolve(publicVendorDir, "monaco");

export function build(opts) {
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

export const buildMonaco = async () => {
  await fs.remove(publicMonacoDir).catch(() => null);
  /**
   * esbuild config for monaco editor
   * @see https://github.com/microsoft/monaco-editor/blob/35eb0efbc039827432002ccc17b120eb0874d70f/samples/browser-esm-esbuild/build.js
   */
  const workerEntryPoints = [
    "vs/basic-languages/markdown/markdown.js",
    "vs/language/json/json.worker.js",
    "vs/language/css/css.worker.js",
    "vs/language/html/html.worker.js",
    "vs/language/typescript/ts.worker.js",
    "vs/editor/editor.worker.js",
  ];

  return build({
    entryPoints: workerEntryPoints.map((entry) =>
      path.resolve(rootDirname, `node_modules/monaco-editor/esm/${entry}`)
    ),
    bundle: true,
    format: "iife",
    outbase: path.resolve(rootDirname, "node_modules/monaco-editor/esm/"),
    outdir: publicMonacoDir,
  });
};

export const buildCommon = {
  loader: {
    ".eot": "file",
    ".woff": "file",
    ".woff2": "file",
    ".svg": "file",
    ".ttf": "file",
  },
};

buildMonaco();
