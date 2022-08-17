import * as path from "path";
export const servedir = path.resolve(process.cwd(), "public");
export const log = (...args) => console.info(`[devserver]`, ...args);
export const logError = (...args) =>
  console.error(`[devserver / ERROR]`, ...args);
