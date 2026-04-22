# Premier League Football Underdogs

An analysis of premier league football teams taking a perpective of the teams with the highest betting odds in matches - aka the Underdogs - to find out how well they have performed. 

The work combines passion with practice. The general idea was to build an end to end ETL pipeline that collects football csv files


as football stats data with no particular end. Beginning with the premier league, the scope of the ananlysis widens to include other leagues as queries and 


# What's covered
Premier league 
# football data source


# extract
pipeline_fetch.py - download csv datasets
db.py - create database 
mappings.py


# transform
pipeline_clean.py
# load
main.py


# Premier League Football Underdogs

An analysis of Premier League football teams from the perspective of the side with the higher betting odds in each match — the underdog — to explore how often they outperform expectations.

This project combines personal interest with technical practice. The goal was to build a simple end-to-end ETL pipeline that:

- collects football CSV data
- cleans and standardises the raw inputs
- loads the data into SQLite
- uses SQL to generate KPIs and rankings
- exposes selected outputs through a lightweight API

The project began with Premier League data, with scope to expand into other leagues.

It also serves as a practical exercise in:

- data modeling
- wide-to-long data transformations
- SQL analytics
- KPI design
- pipeline reliability
- backend development

# Data pipeline
