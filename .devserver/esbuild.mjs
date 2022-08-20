import * as esbuild from "esbuild";
import { servedir } from "./common.mjs";
import { buildCommon } from "../.esbuild/common.mjs";

export const serve = () =>
  esbuild.serve(
    { servedir },
    {
      entryPoints: ["lib/es6/src/App.bs.js"],
      bundle: true,
      format: "esm",
      outdir: "public/js",
      splitting: true,
      ...buildCommon,
    }
  );
