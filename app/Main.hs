module Main where

import qualified MyLib

main :: IO ()
main = do
  putStrLn MyLib.definition
  
