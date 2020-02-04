module Main where

import           Configuration.Dotenv (defaultConfig, loadFile)
import           Lib
import           System.Directory
import           System.Environment

main :: IO ()
main = do
  hasDotEnv <- doesFileExist ".env"
  if hasDotEnv then
    putStrLn "Loading config from .env file..."
    >> loadFile defaultConfig
  else
    putStrLn "Loading config from environment variables..."
    >> getEnvironment
  dates <- getStartDates
  if hasNewCourses dates then
    sendEmailNotification $ getNewCourse dates
  else
    putStrLn "There aren't new courses available."
