module Main where

import           Configuration.Dotenv (defaultConfig, loadFile)
import           Lib

main :: IO ()
main = do
  loadFile defaultConfig

  dates <- getStartDates
  if hasNewCourses dates then
    sendEmailNotification $ getNewCourse dates
  else
    putStrLn "There aren't new courses available."
