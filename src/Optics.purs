module Optics where

import Control.Applicative (pure)
import Control.Bind (bind, discard)
import Control.Category ((>>>))
import Data.Function (($))
import Data.JSDate (JSDate, now)
import Data.Lens
import Data.Lens.Record (prop)
import Data.Symbol (SProxy (..))
import Data.Maybe (Maybe (..))
import Data.Semigroup ((<>))
import Data.Show (class Show, show)
import Data.Tuple (Tuple (..))
import Data.Unit (Unit, unit)
import Effect (Effect)
import Effect.Console (log)

type UserStats =
  { followers :: Int
  , following :: Int
  , views     :: Int
  , rescues   :: Int
  , comments  :: Int
  }

type UserPrefs =
  { autoRefresh        :: Maybe Boolean
  , commentDisplayMode :: Maybe CommentDisplayMode
  }

data CommentDisplayMode = Hide | Shrink | Expand

instance showCommentDisplayMode :: Show CommentDisplayMode where
  show Hide   = "hide"
  show Shrink = "shrink"
  show Expand = "expand"

type User =
  { nickname :: String
  , isGroup  :: Boolean
  , stats    :: UserStats
  , prefs    :: UserPrefs
  }

type Comment =
  { subject :: Maybe String
  , time    :: JSDate
  , content :: String
  , author  :: User
  }

comment1 :: JSDate -> Comment
comment1 date =
  { author: author1
  , content: "Promoting JavaScript is just as bad as voting for a Republican."
  , subject: Nothing
  , time: date
  }

author1 :: User
author1 =
  { nickname: "mbbx6spp"
  , isGroup: false
  , stats:
    { followers: 10
    , following: 15
    , views: 100
    , rescues: 0
    , comments: 5
    }
  , prefs:
    { autoRefresh: Just true
    , commentDisplayMode: Just Hide
    }
  }

-- Without lenses, prisms, traversals, or folds
getNickname :: User -> String
getNickname { nickname } = nickname

getFollowers :: User -> Int
getFollowers { stats: { followers } } = followers

getFollowing :: User -> Int
getFollowing { stats: { following } } = following


-- TODO: Use options to do this...
_nickname :: forall a r. Lens' { nickname :: a | r } a
_nickname = prop (SProxy :: SProxy "nickname")

_followers :: Lens' UserStats Int
_followers = prop (SProxy :: SProxy "followers")

_following :: Lens' UserStats Int
_following = prop (SProxy :: SProxy "following")

_stats :: Lens' User UserStats
_stats = prop (SProxy :: SProxy "stats")

main :: Effect Unit
main = do
  date <- now
  log $ "comment:   " <> show (comment1 date)
  log $ "nickname:  " <> show (getNickname author1)
  log $ "followers: " <> show (getFollowers author1)
  log $ "following: " <> show (getFollowing author1)

  log $ "nicknameL:  " <> show (view (_nickname) author1)
  log $ "followersL: " <> show (view (_followers >>> _stats) author1)
  log $ "followingL: " <> show (view (_following >>> _stats) author1)
  pure unit

