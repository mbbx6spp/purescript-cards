module Main where

import Prelude
import Effect (Effect)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Effect.Console (log)


data Suit = Hearts | Diamonds | Spades | Clubs

derive instance genericSuit :: Generic Suit _
instance showSuit :: Show Suit where show = genericShow

main :: Effect Unit
main = do
  log "Hello sailor!"