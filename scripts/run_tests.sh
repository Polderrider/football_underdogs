#!/bin/bash

sqlite3 football_pipeline.db < sql/test_underdog_setup.sql
echo "----- row check -----"
sqlite3 -header -column football_pipeline.db < sql/test_underdog_row_check.sql
echo "----- aggregate check -----"
sqlite3 -header -column football_pipeline.db < sql/test_underdog_aggregate.sql