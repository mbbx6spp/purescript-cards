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
