module Main where

import Prelude
import Effect (Effect)
import Data.Generic.Rep (class Generic)
import Effect.Console (log)


data Suit = Hearts | Diamonds | Spades | Clubs

derive instance genericSuit :: Generic Suit _
derive instance showSuit :: Show Suit

main :: Effect Unit
main = do
  log "Hello sailor!"