Project Objective
1. Source the data from popular job platform JOBSDB, which can guarantee the data is up-to-date and is really the requirment of employers
2. Find out what technical skills are needed the most for being a data analyst.
3. How many job posts are open to FG?
4. In general, how many years of experience for a candidate are needed?

Methodology
Source data: 
Ulitizing Webdriver, Selenium, BS4 and all related python packages for the web-crawling. The data collected includes the job title, employer name, working locaiton, job highlight, job description and job requirement 

Data cleaning:
Using pandas for transforming the data into dataframe, and do some data cleaning, like removing unnecessary space data, united some words with different variations into one.

Extraction of Experience and essential skills:
This will be done by NLP in the spacy in python. Build different patterns for the entity ruler as well as the matcher for capturing the desired text
