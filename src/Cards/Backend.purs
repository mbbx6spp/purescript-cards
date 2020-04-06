module Cards.Backend (main) where

import Prelude
import Control.Monad (void)
import Data.Unit (Unit)
import Data.Maybe (Maybe (..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.HTTP (Server)
import Node.Process (lookupEnv)
import Node.Express.App (App, listenHttp, get, use)
import Node.Express.Handler (Handler)
import Node.Express.Response (sendJson, setStatus)

indexHandler :: Handler
indexHandler = sendJson { status: "OK" }

setupRoutes :: App
setupRoutes = do
  liftEffect $ log "Setting up routes"
  
  get "/" indexHandler

main :: Effect Unit
main =
  void $ listenHttp setupRoutes 8080 (\_ -> log $ "Listening on port " <> show 8080)
