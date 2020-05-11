module Cards.Backend.Lambda
       ( LambdaHttpEvent
       , LambdaContext
       , LambdaResult
       ) where

import Data.Function (($))
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Console (log)
import Prelude (discard)

type LambdaHttpEvent
  = { }

type LambdaContext
  = { functionName       :: String
    , functionVersion    :: String
    , invokedFunctionArn :: String
    , memoryLimitInMB    :: Int
    , awsRequestId       :: String
    , logGroupName       :: String
    , logStreamName      :: String
    }

type LambdaResult = { statusCode :: Int, body :: String }
