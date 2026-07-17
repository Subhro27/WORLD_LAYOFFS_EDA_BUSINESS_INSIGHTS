/*========================================================================================================================
                                            WORLD LAYOFFS - EXPLORATORY DATA ANALYSIS (EDA)
==========================================================================================================================

Project      : World Layoffs Analysis
Dataset      : Cleaned World Layoffs Dataset
Database     : world_layoffs
Table Used   : layoffs_staging2

Objective
---------
Perform Exploratory Data Analysis (EDA) on the cleaned layoffs dataset to uncover meaningful business insights,
identify trends, and answer key analytical questions using SQL.

Business Questions
------------------
1. What is the largest layoff recorded?
2. Which companies laid off 100% of their workforce?
3. Which companies raised the most funding before shutting down?
4. Which companies had the highest total layoffs?
5. Which industries, countries, and locations were affected the most?
6. How did layoffs change over time?
7. Which startup stages experienced the highest layoffs?
8. Which companies had the highest layoffs each year?

Skills Demonstrated
-------------------
• Aggregate Functions
• GROUP BY
• ORDER BY
• Date Functions
• Common Table Expressions (CTEs)
• Window Functions
• Ranking Functions
• Running Totals
• Business Insight Generation

========================================================================================================================*/

/*========================================================================================================================
                                            STEP 1 : SELECT DATABASE
==========================================================================================================================

Purpose
-------
Select the database that contains the cleaned layoffs dataset.

========================================================================================================================*/

USE world_layoffs;

/*========================================================================================================================
                                        STEP 2 : VIEW THE CLEANED DATASET
==========================================================================================================================

Purpose
-------
Inspect the cleaned dataset before beginning the exploratory analysis.

Business Insight
----------------
Understanding the available columns and verifying the cleaned data ensures that
all further analysis is performed on accurate information.

========================================================================================================================*/

SELECT *
FROM layoffs_cleaned;

/*========================================================================================================================
                                    STEP 3 : FIND THE LARGEST LAYOFF EVENT
==========================================================================================================================

Purpose
-------
Identify the highest number of employees laid off in a single layoff event.

Business Insight
----------------
This helps us understand the most severe individual layoff event recorded in the dataset.
It also provides a quick overview of the scale of layoffs experienced during the period.

========================================================================================================================*/

SELECT MAX(total_laid_off) AS Maximum_Layoffs
FROM layoffs_cleaned;

/*========================================================================================================================
                            STEP 4 : FIND THE MAXIMUM AND MINIMUM LAYOFF PERCENTAGES
==========================================================================================================================

Purpose
-------
Determine the highest and lowest recorded layoff percentages in the dataset.

Business Insight
----------------
This helps identify the range of workforce reductions across companies.
A value of 1 represents a company that laid off 100% of its employees,
while smaller values indicate partial workforce reductions.

========================================================================================================================*/

SELECT
    MAX(percentage_laid_off) AS Maximum_Percentage,
    MIN(percentage_laid_off) AS Minimum_Percentage
FROM layoffs_cleaned
WHERE percentage_laid_off IS NOT NULL;

/*========================================================================================================================
                            STEP 5 : IDENTIFY COMPANIES THAT LAID OFF 100% OF THEIR WORKFORCE
==========================================================================================================================

Purpose
-------
Identify companies where the layoff percentage equals 100%.

Business Insight
----------------
A layoff percentage of 1 indicates that the company laid off its entire workforce,
which often suggests that the company shut down, ceased operations,
or experienced a complete business failure.

========================================================================================================================*/

SELECT *
FROM layoffs_cleaned
WHERE percentage_laid_off = 1;

/*========================================================================================================================
                    STEP 6 : HIGHEST FUNDED COMPANIES THAT LAID OFF THEIR ENTIRE WORKFORCE
==========================================================================================================================

Purpose
-------
Identify companies that laid off 100% of their workforce and rank them
by the amount of funding they raised.

Business Insight
----------------
This analysis highlights companies that received significant investor funding
but ultimately failed, showing that high investment does not always guarantee
business success.

========================================================================================================================*/

SELECT *
FROM layoffs_cleaned
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

/*========================================================================================================================
                                STEP 7 : COMPANIES WITH THE HIGHEST TOTAL LAYOFFS
==========================================================================================================================

Purpose
-------
Identify the companies that laid off the largest number of employees across all
recorded layoff events.

Business Insight
----------------
Some companies appear multiple times in the dataset because they conducted
layoffs on different dates. Summing the layoffs provides the total workforce
reduction for each company over the entire period.

========================================================================================================================*/

SELECT
    company,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY company
ORDER BY Total_Layoffs DESC;

/*========================================================================================================================
                                STEP 8 : TOTAL LAYOFFS BY LOCATION
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off in each location.

Business Insight
----------------
This analysis identifies the cities or regions that experienced the highest
number of layoffs, helping us understand which startup and technology hubs
were most affected.

========================================================================================================================*/

SELECT
    location,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY location
ORDER BY Total_Layoffs DESC;


/*========================================================================================================================
                                STEP 9 : TOTAL LAYOFFS BY COUNTRY
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off in each country.

Business Insight
----------------
This analysis identifies which countries experienced the highest number of layoffs,
providing a broader geographical perspective on the global impact of workforce reductions.

========================================================================================================================*/

SELECT
    country,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY country
ORDER BY Total_Layoffs DESC;

/*========================================================================================================================
                                STEP 10 : TOTAL LAYOFFS BY YEAR
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off each year.

Business Insight
----------------
Analyzing layoffs by year helps identify trends over time and highlights
which years experienced the most significant workforce reductions.

========================================================================================================================*/

SELECT
    YEAR(date) AS Layoff_Year,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY YEAR(date)
ORDER BY Layoff_Year;

/*========================================================================================================================
                                STEP 11 : TOTAL LAYOFFS BY INDUSTRY
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off in each industry.

Business Insight
----------------
This analysis identifies which industries experienced the greatest workforce
reductions, helping us understand which sectors were most affected during
the layoff period.

========================================================================================================================*/

SELECT
    industry,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY industry
ORDER BY Total_Layoffs DESC;


/*========================================================================================================================
                                STEP 12 : TOTAL LAYOFFS BY COMPANY STAGE
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off at different company funding stages.

Business Insight
----------------
This analysis helps determine whether startups, growth-stage companies,
or publicly listed organizations experienced the highest workforce reductions.

========================================================================================================================*/

SELECT
    stage,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY stage
ORDER BY Total_Layoffs DESC;

/*========================================================================================================================
                                STEP 13 : TOTAL LAYOFFS BY MONTH
==========================================================================================================================

Purpose
-------
Calculate the total number of employees laid off each month.

Business Insight
----------------
Monthly analysis helps identify when layoffs increased or decreased over time,
making it easier to spot trends, hiring freezes, or major economic events.

New SQL Concepts
----------------
• DATE_FORMAT()
• GROUP BY on formatted dates

========================================================================================================================*/

SELECT
    SUBSTRING(`date`, 1, 7) AS Month,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
WHERE `date` IS NOT NULL
GROUP BY Month
ORDER BY Month;

/*========================================================================================================================
                            STEP 14 : MONTHLY ROLLING TOTAL OF LAYOFFS
==========================================================================================================================

Purpose
-------
Calculate the cumulative (running) total of layoffs over time.

Unlike the previous query, which showed layoffs for each month individually,
this analysis shows the total layoffs accumulated up to each month.

Business Insight
----------------
A running total helps visualize how layoffs increased throughout the years.
It answers questions such as:

• How many employees had been laid off by a particular month?
• Did layoffs accelerate or slow down over time?
• At what point did layoffs cross major milestones?

SQL Concepts Used
-----------------
• Common Table Expression (CTE)
• Window Function
• SUM() OVER()
• Running Total
• ORDER BY

Explanation
-----------
This analysis is performed in two stages.

Stage 1:
---------
A Common Table Expression (CTE) named 'Rolling_Total' is created.

The CTE calculates the total layoffs for each month by:

• Extracting the Year-Month from the date
• Summing all layoffs that occurred during that month
• Grouping the results month-wise

The output of the CTE looks like this:

Month      Total_Layoffs
2020-03        9628
2020-04       26710
2020-05       25804
...

Stage 2:
---------
The second query reads the CTE and applies a Window Function.

SUM(Total_Layoffs) OVER(ORDER BY Month)

Unlike a normal SUM(), this does not collapse the rows.

Instead, SQL calculates a cumulative total while moving
from the earliest month to the latest month.

Example:

Month      Layoffs      Running Total

2020-03      9628            9628
2020-04     26710           36338
2020-05     25804           62142
2020-06      7627           69769

This type of calculation is known as a Running Total
or Cumulative Sum.

========================================================================================================================*/

WITH Rolling_Total AS
(
    SELECT
        SUBSTRING(`date`,1,7) AS Month,
        SUM(total_laid_off) AS Total_Layoffs
    FROM layoffs_cleaned
    WHERE `date` IS NOT NULL
    GROUP BY Month
    ORDER BY Month
)

SELECT
    Month,
    Total_Layoffs,
    SUM(Total_Layoffs) OVER(ORDER BY Month) AS Rolling_Total
FROM Rolling_Total;

/*========================================================================================================================
                    STEP 15 : TOP COMPANIES WITH THE HIGHEST LAYOFFS EACH YEAR
==========================================================================================================================

Purpose
-------
Identify the companies with the highest number of layoffs for each year.

Instead of finding the overall top companies, this analysis ranks companies
within each individual year based on the total number of employees laid off.

Business Insight
----------------
This analysis helps answer questions such as:

• Which companies had the largest layoffs in 2020?
• Which companies dominated layoffs in 2021?
• Did different companies appear as major contributors in different years?
• How did the leaders change over time?

SQL Concepts Used
-----------------
• Common Table Expressions (CTEs)
• Aggregate Functions
• GROUP BY
• Window Functions
• DENSE_RANK()
• PARTITION BY
• ORDER BY

Explanation
-----------
This analysis is performed in three stages.

Stage 1:
---------
Calculate the total layoffs for every company in each year.

Since a company may appear multiple times within the same year,
their layoffs are first summed together.

Example:

Year    Company      Total Layoffs

2020    Uber              3750
2020    Airbnb            1900
2020    Expedia           3000
2021    Byju's             900
...

Stage 2:
---------
For every year, companies are ranked based on the total layoffs
using the DENSE_RANK() window function.

Unlike a normal ranking, DENSE_RANK() assigns the same rank to
companies with equal values without skipping the next rank.

Example:

Company        Layoffs     Rank

Uber            3750        1
Expedia         3000        2
Airbnb          1900        3

Stage 3:
---------
Only the Top 5 ranked companies from each year are selected.

This provides a concise summary of the companies that had the
largest layoffs during every year in the dataset.

==========================================================================================================================*/

WITH Company_Year AS
(
    SELECT
        company,
        YEAR(date) AS Years,
        SUM(total_laid_off) AS Total_Laid_Off
    FROM layoffs_cleaned
    GROUP BY company, YEAR(date)
),

Company_Year_Rank AS
(
    SELECT
        *,
        DENSE_RANK() OVER
        (
            PARTITION BY Years
            ORDER BY Total_Laid_Off DESC
        ) AS Ranking
    FROM Company_Year
    WHERE Years IS NOT NULL
)

SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;



/*========================================================================================================================
                                    ADVANCED BUSINESS INSIGHTS
========================================================================================================================*/

/*========================================================================================================================
                        BUSINESS INSIGHT 1 : MONTH WITH THE HIGHEST LAYOFFS
==========================================================================================================================

Purpose
-------
Identify the month that recorded the highest number of layoffs.

Business Insight
----------------
This helps identify the peak period of workforce reductions and may indicate
major economic events or industry-wide downturns.

==========================================================================================================================*/

SELECT
    SUBSTRING(date,1,7) AS Month,
    SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
WHERE date IS NOT NULL
GROUP BY Month
ORDER BY Total_Layoffs DESC
LIMIT 1;

/*========================================================================================================================
                    BUSINESS INSIGHT 2 : TOP 10 COMPANIES BY AVERAGE LAYOFFS PER EVENT
==========================================================================================================================

Purpose
-------
Calculate the average number of employees laid off per layoff event.

Business Insight
----------------
Unlike total layoffs, this identifies companies that tend to conduct
larger layoffs whenever they announce workforce reductions.

==========================================================================================================================*/

SELECT
    company,
    ROUND(AVG(total_laid_off),2) AS Average_Layoffs
FROM layoffs_cleaned
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY Average_Layoffs DESC
LIMIT 10;

/*========================================================================================================================
                BUSINESS INSIGHT 3 : INDUSTRIES WITH THE HIGHEST AVERAGE LAYOFFS
==========================================================================================================================

Purpose
-------
Calculate the average layoffs across different industries.

Business Insight
----------------
Helps identify industries where each layoff event tends to be larger
than others.

==========================================================================================================================*/

SELECT
    industry,
    ROUND(AVG(total_laid_off),2) AS Average_Layoffs
FROM layoffs_cleaned
GROUP BY industry
ORDER BY Average_Layoffs DESC;


/*========================================================================================================================
                    BUSINESS INSIGHT 4 : COMPANIES WITH MULTIPLE LAYOFF ROUNDS
==========================================================================================================================

Purpose
-------
Identify companies that announced layoffs multiple times.

Business Insight
----------------
Repeated layoffs may indicate prolonged financial challenges or
multiple restructuring phases.

==========================================================================================================================*/

SELECT
    company,
    COUNT(*) AS Layoff_Rounds
FROM layoffs_cleaned
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY Layoff_Rounds DESC;


/*========================================================================================================================
                    BUSINESS INSIGHT 5 : HIGHEST FUNDED COMPANIES THAT SURVIVED
==========================================================================================================================

Purpose
-------
Identify highly funded companies that did not lay off 100% of their workforce.

Business Insight
----------------
Provides a comparison with companies that completely shut down.

==========================================================================================================================*/

SELECT
    company,
    funds_raised_millions,
    percentage_laid_off
FROM layoffs_cleaned
WHERE percentage_laid_off < 1
ORDER BY funds_raised_millions DESC
LIMIT 10;

/*========================================================================================================================
                BUSINESS INSIGHT 6 : AVERAGE LAYOFF PERCENTAGE BY INDUSTRY
==========================================================================================================================*/

SELECT
    industry,
    ROUND(AVG(percentage_laid_off),2) AS Average_Layoff_Percentage
FROM layoffs_cleaned
GROUP BY industry
ORDER BY Average_Layoff_Percentage DESC;

/*========================================================================================================================
                BUSINESS INSIGHT 7 : COUNTRIES WITH THE HIGHEST AVERAGE LAYOFFS
==========================================================================================================================*/

SELECT
    country,
    ROUND(AVG(total_laid_off),2) AS Average_Layoffs
FROM layoffs_cleaned
GROUP BY country
ORDER BY Average_Layoffs DESC;


/*========================================================================================================================
                    BUSINESS INSIGHT 8 : TOP 5 INDUSTRIES EVERY YEAR
==========================================================================================================================

Purpose
-------
Rank industries by layoffs within each year.

Business Insight
----------------
Shows which sectors were most affected annually.

==========================================================================================================================*/

WITH Industry_Year AS
(
SELECT
industry,
YEAR(date) AS Year,
SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY industry,YEAR(date)
),

Industry_Rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY Year ORDER BY Total_Layoffs DESC) AS Ranking
FROM Industry_Year
WHERE Year IS NOT NULL
)

SELECT *
FROM Industry_Rank
WHERE Ranking<=5;

/*========================================================================================================================
                BUSINESS INSIGHT 9 : PERCENTAGE CONTRIBUTION OF EACH INDUSTRY
==========================================================================================================================*/

SELECT
industry,
SUM(total_laid_off) AS Total_Layoffs,
ROUND(
SUM(total_laid_off)*100/
(SELECT SUM(total_laid_off) FROM layoffs_cleaned),2)
AS Percentage_Contribution
FROM layoffs_cleaned
GROUP BY industry
ORDER BY Percentage_Contribution DESC;


/*========================================================================================================================
                    BUSINESS INSIGHT 10 : YEAR-OVER-YEAR LAYOFF TREND
==========================================================================================================================

Purpose
-------
Compare yearly layoffs with the previous year.

SQL Concepts
------------
LAG() Window Function

==========================================================================================================================*/

WITH Yearly_Layoffs AS
(
SELECT
YEAR(date) AS Year,
SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY YEAR(date)
)

SELECT
Year,
Total_Layoffs,
LAG(Total_Layoffs) OVER(ORDER BY Year) AS Previous_Year,
Total_Layoffs-
LAG(Total_Layoffs) OVER(ORDER BY Year) AS Difference
FROM Yearly_Layoffs;



/*========================================================================================================================
                BUSINESS INSIGHT 11 : COMPANIES WITH MORE THAN 5000 TOTAL LAYOFFS
==========================================================================================================================*/

SELECT
company,
SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY company
HAVING SUM(total_laid_off)>5000
ORDER BY Total_Layoffs DESC;


/*========================================================================================================================
                BUSINESS INSIGHT 12 : COUNTRY CONTRIBUTION TO GLOBAL LAYOFFS
==========================================================================================================================*/

SELECT
country,
SUM(total_laid_off) AS Total_Layoffs,
ROUND(
SUM(total_laid_off)*100/
(SELECT SUM(total_laid_off)
FROM layoffs_cleaned),2)
AS Percentage
FROM layoffs_cleaned
GROUP BY country
ORDER BY Percentage DESC;


/*========================================================================================================================
                    BUSINESS INSIGHT 13 : QUARTERLY LAYOFF ANALYSIS
==========================================================================================================================*/

SELECT
CONCAT(YEAR(date),'-Q',QUARTER(date)) AS Quarter,
SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY Quarter
ORDER BY Quarter;

/*========================================================================================================================
                    BUSINESS INSIGHT 14 : AVERAGE FUNDING BY COMPANY STAGE
==========================================================================================================================*/

SELECT
stage,
ROUND(AVG(funds_raised_millions),2) AS Average_Funding
FROM layoffs_cleaned
GROUP BY stage
ORDER BY Average_Funding DESC;


/*========================================================================================================================
                BUSINESS INSIGHT 15 : TOP FUNDED COMPANIES WITH THE HIGHEST LAYOFFS
==========================================================================================================================

Purpose
-------
Identify companies that raised significant funding and also recorded
high numbers of layoffs.

Business Insight
----------------
This helps understand whether high funding necessarily translated into
long-term organizational stability.

==========================================================================================================================*/

SELECT
company,
funds_raised_millions,
SUM(total_laid_off) AS Total_Layoffs
FROM layoffs_cleaned
GROUP BY company,funds_raised_millions
ORDER BY funds_raised_millions DESC,Total_Layoffs DESC
LIMIT 15;

/*========================================================================================================================
                                                PROJECT SUMMARY
==========================================================================================================================

Project Name
------------
World Layoffs - Exploratory Data Analysis & Business Insights

Project Objective
-----------------
Analyze the cleaned world layoffs dataset to identify workforce reduction trends,
company performance, geographical impact, industry distribution, funding patterns,
and other key business insights using SQL.

Analyses Performed
------------------
The project was completed in two phases:

Phase 1 : Exploratory Data Analysis (EDA)
-----------------------------------------
✓ Largest single layoff event
✓ Layoff percentage analysis
✓ Companies with 100% workforce reduction
✓ Highest funded companies that shut down
✓ Total layoffs by company
✓ Total layoffs by location
✓ Total layoffs by country
✓ Total layoffs by year
✓ Total layoffs by industry
✓ Total layoffs by company stage
✓ Monthly layoff trends
✓ Running (Cumulative) layoffs over time
✓ Top companies by layoffs for each year

Phase 2 : Advanced Business Insights
------------------------------------
✓ Peak layoff month
✓ Companies with the highest average layoffs per event
✓ Industries with the highest average layoffs
✓ Companies with multiple layoff rounds
✓ Highest funded companies that survived
✓ Average layoff percentage by industry
✓ Countries with the highest average layoffs
✓ Top industries for each year
✓ Industry contribution to total layoffs
✓ Year-over-Year layoff comparison
✓ Companies with more than 5,000 total layoffs
✓ Country contribution to global layoffs
✓ Quarterly layoff analysis
✓ Average funding by company stage
✓ Funding versus layoffs analysis

SQL Skills Demonstrated
-----------------------
✓ Data Exploration
✓ Aggregate Functions
✓ GROUP BY
✓ ORDER BY
✓ HAVING
✓ Date Functions
✓ Window Functions
✓ Running Totals
✓ Common Table Expressions (CTEs)
✓ DENSE_RANK()
✓ LAG()
✓ Business-Oriented SQL Analysis

Key Business Findings
---------------------
• The largest individual layoff event affected 12,000 employees.
• Layoffs peaked during 2022, indicating the largest workforce correction.
• The United States recorded the highest number of layoffs globally.
• The SF Bay Area experienced the greatest concentration of workforce reductions.
• Consumer and Retail industries were among the most affected sectors.
• Post-IPO companies accounted for the largest share of layoffs.
• Several highly funded companies still laid off 100% of their workforce.
• Monthly and cumulative analyses showed layoffs occurred in waves rather than at a constant rate.
• Ranking analysis highlighted the companies leading layoffs in each year from 2020 to 2023.
• Additional business insights revealed trends in funding, repeated layoffs, quarterly performance, and industry contribution.

Conclusion
----------
This project demonstrates the complete exploratory analysis of a real-world dataset
using SQL. By combining descriptive analytics, window functions, ranking functions,
CTEs, and business-driven queries, the analysis provides meaningful insights into
global layoff trends and showcases practical SQL skills applicable to real-world
data analyst roles.

Next Steps
----------
• Build an interactive Power BI dashboard using the cleaned dataset.
• Develop visualizations to communicate key findings effectively.
• Publish the complete project on GitHub with proper documentation.
• Extend the analysis further using Python (Pandas, Matplotlib, Seaborn) for
  statistical exploration and visualization.

==========================================================================================================================
                                            END OF PROJECT
==========================================================================================================================*/