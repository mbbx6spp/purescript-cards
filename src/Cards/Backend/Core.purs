module Cards.Backend.Core
       ( drawAction
       , indexAction
       ) where

import Cards.Common (Card, Deck)
import Control.Applicative (class Applicative, pure)
import Control.Monad (class Monad)
import Data.Maybe (Maybe(..))

--- Dummy actions

drawAction :: forall f. Applicative f => f (Maybe Card)
drawAction = pure Nothing

indexAction :: forall m. Monad m => m (Record ())
indexAction = pure {}


