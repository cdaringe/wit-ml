import { createProxyMiddleware } from "http-proxy-middleware";

export const create = () =>
  createProxyMiddleware("/api", {
    changeOrigin: true,
    target: `http://127.0.0.1:9999`,
    logLevel: "debug",
  });
