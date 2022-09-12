import * as esbuild from "esbuild";
import * as path from "path";
import * as fs from "fs-extra";
import * as common from "../common.mjs";

export const publicMonacoDir = path.resolve(common.publicVendorDir, "monaco");

export const build = async () => {
  await fs.remove(publicMonacoDir).catch(() => null);
  /**
   * esbuild config for monaco editor
   * @see https://github.com/microsoft/monaco-editor/blob/35eb0efbc039827432002ccc17b120eb0874d70f/samples/browser-esm-esbuild/build.js
   */
  const workerEntryPoints = [
    "vs/basic-languages/markdown/markdown.js",
    // "vs/language/json/json.worker.js",
    // "vs/language/css/css.worker.js",
    // "vs/language/html/html.worker.js",
    // "vs/language/typescript/ts.worker.js",
    "vs/editor/editor.worker.js",
  ];

  return common.build({
    entryPoints: workerEntryPoints.map((entry) =>
      path.resolve(
        common.rootDirname,
        `node_modules/monaco-editor/esm/${entry}`
      )
    ),
    bundle: true,
    format: "iife",
    outbase: path.resolve(
      common.rootDirname,
      "node_modules/monaco-editor/esm/"
    ),
    minify: true,
    outdir: publicMonacoDir,
  });
};
