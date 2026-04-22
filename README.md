# Premier League Football Underdogs

An analysis of Premier League football teams from the perspective of the side with the higher betting odds in each match — the underdog — to explore how often they outperform expectations.

This project combines personal interest with technical practice. The goal was to build a simple end-to-end ETL pipeline that:

- collects football match csv files
- cleans and standardises the raw data
- loads into SQLite
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

## Pipeline

`pipeline_fetch.py` → (`pipeline_clean.py`) → `pipeline_load.py` → `main.py`

## Setup

Install dependencies:

```bash
pip install -r requirements.txt
```

## Usage

```
# Fetch raw football csv files. Input desired year and league in file before running.
python3 pipeline_fetch.py

# Clean and load data into SQLite
python3 pipeline_load.py

# Run the API locally:
uvicorn main:app --reload

# Open the API docs:
http://127.0.0.1:8000/docs

# Explore the database with SQLite:
sqlite3 football_pipeline.db

# Run SQL query files from the sql/ folder:
sqlite3 -header -column football_pipeline.db < sql/highest_total_goals.sql

```




