import * as http from "http";
import * as fs from "fs";
import * as path from "path";
import * as cp from "child_process";
import { serve } from "./esbuild.mjs";
import { bsbLockFilename, log, logError, servedir } from "./common.mjs";
import { create as tinymceStatic } from "./tinymce.middleware.mjs";
import { create as publicStatic } from "./publicdir.middleware.mjs";
import { create as api } from "./api.middleware.mjs";
import { create as esbuild } from "./esbuild.middleware.mjs";

import express from "express";

async function dev() {
  log(`starting dev server`);
  let appServer = null;
  let devserver = null;
  try {
    const app = express();
    devserver = await serve();
    const { host, port } = devserver;
    const esbuildUrl = `http://${host}:${port}`;
    log(`esbuild listening on ${esbuildUrl}`);
    app.use(api());
    app.use(publicStatic());
    app.use(tinymceStatic());
    app.use(esbuild(esbuildUrl));
    appServer = app.listen(3000);
    log(`devserver listening on http://localhost:3000`);
  } catch (err) {
    logError(err);
    devserver?.stop();
    appServer?.close(() => {
      setTimeout(dev, 1_000);
    });
  }
}
process.on("exit", (code) => logError(`exiting with code ${code}`));

dev();
