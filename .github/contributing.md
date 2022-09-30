# Contributing

Thanks for your interest in contributing. This guide is still quite new, thus
likely under-developed.

Open an issue if you have trouble getting started, and I'll make sure to help get
things updated accordingly, perhaps with your help :).

## Installation

- install [node.js](https://nodejs.org/en/), as specified by the version in `.nvmrc`
  - [fnm](https://github.com/Schniz/fnm) is recommended for installing & managing node.js versions
- install [pnpm](https://pnpm.io/) once node+npm are installed: `npm i -g pnpm`
- `pnpm install`

## Develop

- run a local copy of [witwiki](https://github.com/cdaringe/witwiki)
- `pnpm dev`
- open up the browser, `http://localhost:3000`
- make edits, do great work

### How it works

- the witwiki server, in dev mode, uses a light sqlite DB and hosts interesting dummy data
- wit-ml dev runs the following components:
  - the rescript compiler, actively compiling `.res` => `.js` (see `package.json->scripts->dev::rescript`)
  - an esbuild server (see `package.json->scripts->dev::esbuild`), watching the `lib/*` folder for freshly compiled artifacts
  - a dev server (see `.devserver/`), which ties the development web app together. it:
    - serves static content, like HTML, JS, and CSS for the web app
    - proxies app HTTP `/api/*` requests => the local witwiki server (e.g. `witiwiki/api/*`)

## Test

- TBD

## Checkin

- commit using [conventional commits style](https://www.conventionalcommits.org/en/v1.0.0/#summary)
- open a PR, fill it out!
