import staticMw from "serve-static";
import { projectDirname, nodeModulesDirname } from "./common.mjs";
import { join, relative } from "path";

const tinymceDirname = relative(projectDirname, join(nodeModulesDirname));

export const create = () => staticMw(tinymceDirname);
