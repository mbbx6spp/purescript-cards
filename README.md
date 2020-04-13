# Welcome to PureScript

This is an intro project for PureScript that models a card game where we will render the cards on the client side.

## Your Project

On the front-end,
- edit `public/style.css` for styles
- edit `src/Frontend.purs` for the PureScript entrypoint module for the frontend code.
- the PureScript code transpiles to Javascript in the `output/` directory.

On the back-end,
- your app starts at `src/Backend.purs`
- add JavaScript dependencies and scripts in `package.json`
- add PureScript dependencies in `spago.dhall`
- safely store app secrets in `.env` (nobody can see this but you and people you invite)

## Yarn scripts

- `~build`: will in a forever loop build using the purescript compiler whenever any `.purs` or `.js` files change under `src/`
- `~test`: will in a forever loop run stubbed out tests via `spago test` whenever any `.purs` or `.js` files changes under `test/`
- `server`: will run the backend server on port 8080

## On-boarding tests

If you are starting with this project you should check the following:
- load the Nix shell without error
- run `node --version` and get back 12.15.0
- run `yarn versions` and get back a list of all the versions relied upon by yarn
- run `yarn install --dev` will install your project dependencies including dev dependencies under `node_modules/`
- run `yarn build` will compile your `.purs` files under `src/` and output JavaScript to the `output/` directory.
- run `yarn ~build` and change a .purs file under `src/` then see it rerun upon file save
- run `yarn test` which will run on single run of the stubbed out test suite (defined in `test/Main.purs`)
- run `yarn ~test` which will run in a loop and rerun test suite when files under `test/` or `src/` change
- run `yarn server` which will run a HTTP server - the `Cards.Backend` module main - bound to port 8080.
