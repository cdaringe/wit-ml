import * as http from "http";
import * as fs from "fs";
import * as path from "path";
import * as cp from "child_process";
import { serve } from "./.devserver/esbuild.mjs";
import { log, logError, servedir } from "./.devserver/common.mjs";

const isJavasriptReq = (req) =>
  req.url?.endsWith(".js") || req.headers["accept"].match(/javascript/);
const isHtmlReq = (req) =>
  req.url?.endsWith(".html") || req.headers["accept"].match(/html/);

async function dev() {
  log(`starting dev server`);
  try {
    const { host, port } = await serve();

    log(`esbuild listening on ${host}:${port}`);
    http
      .createServer((req, res) => {
        const url = req.url || "";
        if (isJavasriptReq(req)) {
          log(`esbuild: ${url}`);
          proxyToEsbuild({ host, req, res, port });
        } else if (isHtmlReq(req)) {
          log(`html: ${url}`);
          fs.createReadStream(path.join(servedir, "index.html")).pipe(res, {
            end: true,
          });
        } else if (req.url?.includes("..")) {
          log(`forbidden: ${url}`);
          res.writeHead(409, { "Content-Type": "text/html" });
          res.end("<h1>get lost</h1>");
        } else if (url.includes("api/")) {
          log(`api: ${url}`);
          proxyToApi({ host, req, port: 9999, res });
        } else {
          // ultra basic static handler
          // https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
          res.writeHead(200, {
            "content-type": url.endsWith("js")
              ? "text/javascript"
              : url.endsWith("css")
              ? "text/css"
              : "application/octet-stream",
          });
          fs.createReadStream(path.join(servedir, req.url)).pipe(res, {
            end: true,
          });
        }
      })
      .listen(3000);
    log(`devserver listening on http://localhost:3000`);
  } catch (err) {
    logError(err);
    return dev();
  }
}

const proxyToEsbuild = ({ host, req, port, res }) =>
  req
    .pipe(
      http.request(
        {
          hostname: host,
          port: port,
          path: req.url,
          method: req.method,
          headers: req.headers,
        },
        (proxyRes) => {
          // If esbuild returns "not found", send a custom 404 page
          if (proxyRes.statusCode === 404) {
            res.writeHead(404, { "Content-Type": "text/html" });
            res.end("<h1>A custom 404 page</h1>");
            return;
          }

          // Otherwise, forward the response from esbuild to the client
          res.writeHead(proxyRes.statusCode, proxyRes.headers);
          proxyRes.pipe(res, { end: true });
        }
      ),
      { end: true }
    )
    .on("error", (err) => {
      res.end();
      logError(`proxy->esbuild fail: ${err}\n(${req.host} ${req.url})`);
    });

const proxyToApi = ({ host, req, port, res }) => {
  const proxyReq = http.request(
    {
      hostname: host,
      port: port,
      path: req.url,
      method: req.method,
      headers: req.headers,
    },
    (proxyRes) => {
      if (proxyRes.statusCode === 404) {
        res.writeHead(404, { "Content-Type": "text/html" });
        res.end("<h1>A custom 404 page</h1>");
        return;
      }

      // Otherwise, forward the response from esbuild to the client
      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res, { end: true });
    }
  );
  req.pipe(proxyReq, { end: true }).on("error", (err) => {
    res.statusCode = 500;
    res.end();
    logError(`proxy->api fail: ${err}\n(${req.host} ${req.url})`);
  });
};

process.on("exit", (code) => logError(`exiting with code ${code}`));

const [rescript, ...rparams] = "rescript build -w".split(/\s+/);
cp.spawn(rescript, rparams, { stdio: "inherit" });
cp.exec("tailwindcss -i ./src/app.css -o ./public/css/app.css --watch", {
  stdio: "inherit",
});
dev();
