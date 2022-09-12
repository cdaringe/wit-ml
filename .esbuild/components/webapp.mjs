import * as path from "path";
import * as common from "../common.mjs";

export const build = async () => {
  await common.build({
    ...common.buildCommon,
    entryPoints: [path.resolve(common.rootDirname, "lib/es6/src/App.bs.js")],
    bundle: true,
    outdir: path.resolve(common.publicDir, "js"),
  });
};
