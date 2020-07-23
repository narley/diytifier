{-# LANGUAGE OverloadedStrings #-}

module Lib where

import           Control.Lens
import           Control.Monad
import           Data.List
import           Data.Text          hiding (concat, filter, intercalate,
                                     intersperse, length, map, null)
import           Network.Wreq
import           System.Environment (getEnv)
import           Text.HTML.Scalpel
import           Text.Regex.TDFA

data Course
  = CourseStartDate Text
  | CourseEndDate Text
  deriving (Show, Eq)

urlToScrape :: IO String
urlToScrape = getEnv "URL_TO_SCRAPE"

sendEmailEndpoint :: IO String
sendEmailEndpoint = getEnv "SEND_EMAIL_ENDPOINT"

currentCoursesDates :: [String]
currentCoursesDates = ["15/01/2020","22/04/2020"]
-- currentCoursesDates = ["01/01/2020", "10/02/2020"]

getStartDates :: IO [String]
getStartDates = do
  url <- urlToScrape
  maybeCourseCells <- scrapeURL url courseCell
  case maybeCourseCells of
    Just cells -> return $ filter ((>0) . length) cells
    Nothing    -> return $ []
  where
    courseCell :: Scraper String [String]
    courseCell = chroots (("div" @: [hasClass "courseCell"]) // "p") $ do
      txt <- text "p"
      dates <- return $ matchDates txt
      return dates

    matchDates :: String -> String
    matchDates str = str =~ ("[0-9]+/[0-9]+/[0-9]+" :: String)

hasNewCourses :: [String] -> Bool
hasNewCourses xs =
  if (null $ currentCoursesDates \\ xs) then
    False
  else
    True

getNewCourse :: [String] -> [String]
getNewCourse newDates = newDates \\ currentCoursesDates

sendEmailNotification :: [String] -> IO ()
sendEmailNotification dates = do
  emailEndpoint <- sendEmailEndpoint
  let stringDates = intercalate "," dates
  let textDates = pack stringDates
  opts <- return $ defaults & param "dates" .~ textDates : []
  resp <- getWith opts emailEndpoint
  putStrLn "Email sent!"
