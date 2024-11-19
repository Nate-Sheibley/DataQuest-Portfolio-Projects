# ToC

## 1. Did Fandango adjust inflated ratings since 2015 callout article? Yes
### [R_Stats-Fandango_Skewed_Ratings_pre_post](/R_Stats-Fandango_Skewed_Ratings_pre_post)

Using statistical methods and visualizations, I show that Fandango did adjust the ratings inflations found in the popular 2015 article found [here](https://fivethirtyeight.com/features/fandango-movies-ratings/). Please view the HTML document.

## 2. Model Car sales analysis using SQL
### [SQL_query_writing-Model_Cars_Store](/SQL_query_writing-Model_Cars_Store)

Write a series of queries that take a purchase list with date, amount and cusomter ID, and result in a table of new customers and their spending. The amount of spending a new customer does in a month can then be used to estimate a per new customer marketing budget.
The dataset was loading into SQlite for query writing with the given schema diagram. Use only SQL.

## 3. Analysis of 11 Forest Fire factors for relation to frequency and intensity
### [R-visualizations_forest_fire_metrics](/R-visualizations_forest_fire_metrics)

Make faceted and tiled visualizations to aid in discovering which forest fire factors correlate strongly with increase frequency of fire, or increased intensity (using area burned as a proxy). Use R-tidyverse packages to transform and load data from a CSV. 

---

# Minor projects

## Parallelized wikipedia text search in python using map-redice written from scratch (1000 articles test)
### [python-mapReduce_Mutlithreaded_text_search_Wikipedia](/python-mapReduce_Mutlithreaded_text_search_Wikipedia)

Write a map-reduce parallelization algorythem to search for strings in 1000 randomly scraped wikipedia pages. Return a dataframe of the file, line, character index, and context surrounding the match for each.

## Venture Funding Analysis
### [python-pandas_sqlite_Chrunchbase_Fundraisers](/python-pandas_sqlite_Chrunchbase_Fundraisers)

Classic crunchbase raising dataset, visualizing which classes of funraising, either funding type or product category obtains the most fundraising, and who contributes most to this type of funding.

---

# About DataQuest Guided projects

DataQuest guided projects provide a dataset, and a target for analysis.

DataQuest provides vidualization snippets and/or implementation metrics to allow for checking milestone progreess.

Largely, the student is responsible for sanity checking the analysis.

Example1: In the python-mapReduce project they provided the implementation metric: execution time for each method.

Example2: In the R-visualizations-forest-fire-metrics project, DataQuest provided two months with highest fire frequency, and .png examples of one of the plots.
They do not provide any starting code.

DataQuest started Sept 2023

Initial commit Mar 2024
