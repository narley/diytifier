# diytifier

A simple tooling to get notifications about free DIY courses at a local university.

## Motivation

Twice I was late to enrol to the course as it becomes fully booked quite quickly.
So decided to create this tool in order to get a bit of advantage. :)
And it was also another excuse to put into practice what I've being learning about Haskell.

## How does it work?

It simply scrape the university's course page and check whether or not a new course was made available.
If the course is available then it will then send a request to a Google Appscript endpoint to send an email to myself about the course (easier this way rather trying to figure out how to send emails via Haskell).
The tool runs in a cron job every 4 hours.

## Final Note

 This is a toy app and written by someone who is learning Haskell.
 So do not expect good practice or amazing code.
 Cheers!!
