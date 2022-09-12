import * as common from "./common.mjs";
import * as path from "path";
import { build } from "./components/_all.mjs";

async function buildAll() {
  common.log("starting build");
  await build();
  common.log("build complete");
}

buildAll();
