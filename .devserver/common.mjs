import * as path from "path";
export const projectDirname = path.resolve(
  import.meta.url.replace("file://", ""),
  ".."
);

export const nodeModulesDirname = path.join(projectDirname, "node_modules");
export const servedir = path.resolve(process.cwd(), "public");
export const bsbLockFilename = path.resolve(projectDirname, ".bsb.lock");
export const log = (...args) => console.info(`[devserver]`, ...args);
export const logError = (...args) =>
  console.error(`[devserver / ERROR]`, ...args);
