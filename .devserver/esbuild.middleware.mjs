import { createProxyMiddleware } from "http-proxy-middleware";

export const create = (target) =>
  createProxyMiddleware("/", {
    target,
    pathRewrite: (path, req) => {
      /**
       * SPA apps use load the entrypoint. Dangerously detect page requests,
       * reply with the app entry :)
       */
      if (req.headers.accept?.match(/html/)) {
        return "/";
      }
      return path;
    },
  });
