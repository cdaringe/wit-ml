import { createProxyMiddleware } from "http-proxy-middleware";

export const create = () =>
  createProxyMiddleware("/api", {
    changeOrigin: true,
    target: `http://localhost:9999`,
    logLevel: "debug",
  });
