import { build as monaco } from "./monaco.mjs";
import { build as webapp } from "./webapp.mjs";

export const build = () => Promise.all([webapp(), monaco()]);
