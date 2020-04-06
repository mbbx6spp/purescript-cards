module Cards.Common where

import Data.Show (class Show)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data Suit = Hearts | Diamonds | Spades | Clubs

derive instance genericSuit :: Generic Suit _
instance showSuit :: Show Suit where show = genericShow

