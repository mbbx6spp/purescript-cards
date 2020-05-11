module Cards.Common
       ( Suit (..)
       , CardColor (..)
       , Rank (..)
       , Card
       , Deck
       ) where

import Data.List (List, (:))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Show (class Show)

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

data Card = MkCard { rank :: Rank, suit :: Suit }
derive instance genericCard :: Generic Card _
instance showCard :: Show Card where show = genericShow

-- | Produce `CardColor` for a given `Suit`
cardColor :: Suit -> CardColor
cardColor Hearts   = Red
cardColor Diamonds = Red
cardColor _        = Black

type Deck = List Card
