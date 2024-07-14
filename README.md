# IMDb Movies Analysis using SQL

## Purpose
The purpose and description of this project can be found in [objective.md](objective.md).

## ERD Diagram
Refer to [ERD Diagram](ERD.md) for schema details.

## Getting Started

### Setting Up the Database
1. **Create Schema and Populate Data**: Run `create_dataset.sql` to set up the database schema and populate data in the following tables:
   - director_mapping
   - genre
   - movie
   - names
   - ratings
   - role_mapping

### Executing Analysis
2. **Analyzing the Data**: Execute the SQL scripts in `analysis_scripts/` to analyze the IMDb movie dataset. Each script corresponds to a different segment of analysis.

### Steps to Run
- Ensure you have access to an SQL database system (e.g., MySQL).
- Use a database client or command-line interface to execute the SQL scripts.

### Recommended Order
- Start with `create_dataset.sql` to initialize the database.
- Execute the scripts in `analysis_scripts/` in numerical order (segment1.sql through segment7.sql) for comprehensive analysis.

## Note
- Modify database connection details (username, password, database name) as per your environment in the SQL scripts if necessary.
- Refer to each script's comments for specific details and insights generated from the analysis.


