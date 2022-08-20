import * as common from "./common.mjs";
import * as path from "path";
async function buildAll() {
  await common.buildMonaco();
  await common.build({
    ...common.buildCommon,
    entryPoints: [path.resolve(common.rootDirname, "lib/es6/src/App.bs.js")],
    bundle: true,
    outdir: path.resolve(common.publicDir, "js"),
  });
}
