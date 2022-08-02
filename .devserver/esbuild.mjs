import * as esbuild from "esbuild";
import { servedir } from "./common.mjs";

export const serve = () =>
  esbuild.serve(
    { servedir },
    {
      bundle: true,
      format: "esm",
      entryPoints: ["lib/es6/src/App.bs.js"],
      outdir: "public/js",
      splitting: true,
    }
  );
