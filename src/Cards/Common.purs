module Cards.Common where

import Data.Show (class Show)

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data Suit = Hearts | Diamonds | Spades | Clubs

derive instance genericSuit :: Generic Suit _
instance showSuit :: Show Suit where show = genericShow

data CardColor = Red | Black

derive instance genericCardColor :: Generic CardColor _
instance showCardColor :: Show CardColor where show = genericShow

data Rank
  = Ace
  | King
  | Queen
  | Jack
  | Ten
  | Nine
  | Eight
  | Seven
  | Six
  | Five
  | Four
  | Three
  | Two

derive instance genericRank :: Generic Rank _
instance showRank :: Show Rank where show = genericShow

