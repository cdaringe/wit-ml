import staticMw from "serve-static";
import { projectDirname } from "./common.mjs";
import { join } from "path";

export const create = () => staticMw(join(projectDirname, "public"));
