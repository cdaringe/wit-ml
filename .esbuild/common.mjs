import * as esbuild from "esbuild";
import * as path from "path";
import * as fs from "fs-extra";

export const log = (...msg) => console.log("[wit-esbuild]", ...msg);

export const rootDirname = path.resolve(
  path.dirname(import.meta.url.replace("file://", "")),
  `..`
);
export const publicDir = path.resolve(rootDirname, "public");
export const publicVendorDir = path.resolve(publicDir, "vendor");

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

export const buildCommon = {
  loader: {
    ".css": "file",
    ".eot": "file",
    ".woff": "file",
    ".woff2": "file",
    ".svg": "file",
    ".ttf": "file",
  },
};
