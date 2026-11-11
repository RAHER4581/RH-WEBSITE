import { readFileSync, writeFileSync } from "node:fs";

const files = ["index.html", "styles.css", "admin.css", "app.js", "admin.js", "mobile-nav.js"];
const assets = Object.fromEntries(files.map((path) => [path, readFileSync(path, "utf8")]));
const worker = readFileSync("worker.js", "utf8");
const marker = ' const url=new URL(req.url),path=url.pathname.replace(/\\/$/,"");let m;';
if (!worker.includes(marker)) throw new Error("Worker routing marker not found");

const staticCode = `const STATIC_ASSETS = ${JSON.stringify(assets)};
const STATIC_MIME = {"html":"text/html; charset=utf-8","css":"text/css; charset=utf-8","js":"application/javascript; charset=utf-8"};
`;
const route = ` const url=new URL(req.url),path=url.pathname.replace(/\\/$/,"");let m;
 if(req.method==="GET"&&!path.startsWith("/api")&&!path.startsWith("/media/")){
  const name=path===""?"index.html":path.slice(1),body=STATIC_ASSETS[name];
  if(body!==undefined){const ext=name.split(".").pop().toLowerCase();return new Response(body,{headers:{...headers,"Content-Type":STATIC_MIME[ext]||"application/octet-stream","Cache-Control":"public, max-age=300"}})}
  return new Response(STATIC_ASSETS["index.html"],{headers:{...headers,"Content-Type":STATIC_MIME.html,"Cache-Control":"no-store"}})
 }`;
writeFileSync("worker.bundle.js", staticCode + worker.replace(marker, route));
