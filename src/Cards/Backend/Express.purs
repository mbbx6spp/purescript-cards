module Cards.Backend.Express (main) where

-- External dependencies
import Prelude (bind, discard)
import Control.Monad (void)
import Data.Function (($))
import Data.Semigroup ((<>))
import Data.Show (show)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.Express.App (App, listenHttp, get, use)
import Node.Express.Handler (Handler, next)
import Node.Express.Request (getOriginalUrl, getMethod)
import Node.Express.Response (sendJson, setStatus)

-- Internal app imports
import Cards.Backend.Core (drawAction, indexAction)

-- Our own Express middleware
logger :: Handler
logger = do
  url <- getOriginalUrl
  method <- getMethod
  liftEffect $ log (">>> " <> show method <> " " <> url)
  next

-- HTTP wrapping handler for Express.js
indexHandler :: Handler
indexHandler = do
  info <- indexAction
  setStatus 200
  sendJson { status: "OK", info: info }

drawHandler :: Handler
drawHandler = do
  cards <- drawAction
  setStatus 200
  sendJson { cards: cards }

setupRoutes :: App
setupRoutes = do
  liftEffect $ log "Setting up routes"
  use logger
  get "/" indexHandler
  get "/draw" drawHandler

main :: Effect Unit
main =
  void $ listenHttp setupRoutes 8080 (\_ -> log $ "Listening on port " <> show 8080)
