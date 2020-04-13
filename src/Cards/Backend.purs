module Cards.Backend (main) where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get, use)
import Node.Express.Handler (Handler, next)
import Node.Express.Request (getOriginalUrl, getMethod)
import Node.Express.Response (sendJson, setStatus)

-- our own middleware
logger :: Handler
logger = do
  url <- getOriginalUrl
  method <- getMethod
  liftEffect $ log (">>> " <> show method <> " " <> url)
  next

indexHandler :: Handler
indexHandler = do
  setStatus 200
  sendJson { status: "OK" }

setupRoutes :: App
setupRoutes = do
  liftEffect $ log "Setting up routes"
  use logger
  get "/" indexHandler

main :: Effect Unit
main =
  void $ listenHttp setupRoutes 8080 (\_ -> log $ "Listening on port " <> show 8080)
