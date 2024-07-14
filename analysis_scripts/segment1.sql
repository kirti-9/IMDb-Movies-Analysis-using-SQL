########################################################
# Segment 1: Database - Tables, Columns, Relationships #
########################################################

use imdb;

-- -	What are the different tables in the database and how are they connected to each other in the database?
		/*
    The database contains 6 tables as follows:
		1. movie: Contains information about movies, including id, title, year, date_published, duration, country, worldwide_gross_income, languages, and production_company.
		2. genre: Stores genres for movies, with columns movie_id and genre.
		3. ratings: Holds rating information for movies, with columns movie_id, avg_rating, total_votes, and median_rating.
		4. names: Contains information about people involved in movies, including id, name, height, date_of_birth, and known_for_movies.
		5. role_mapping: Maps roles to movies, with columns movie_id, name_id, and category.
		6. director_mapping: Maps directors to movies, with columns movie_id and name_id.
         
    The connections of the tables are described as follows:
		The movie table is the central table connected to all other tables.
		genre is connected to movie via movie_id, indicating the genre of each movie.
		ratings is connected to movie via movie_id, providing rating details for each movie.
		names is connected to role_mapping and director_mapping tables via name_id.
		role_mapping connects movie and names via movie_id and name_id, specifying the roles (e.g., actor, actress) associated with each movie.
		director_mapping connects movie and names via movie_id and name_id, indicating the directors of each movie.
		*/
        
-- -	Find the total number of rows in each table of the schema.
select count(*) from director_mapping;
# '3867'
select count(*) from genre;
# '14662'
select count(*) from movie;
# '7997'
select count(*) from names;
# '25735'
select count(*) from ratings;
# '7997'
select count(*) from role_mapping;
# '15615'

-- -	Identify which columns in the movie table have null values.
select sum(case when id is null then 1 else 0 end) as id_null,
    sum(case when title is null then 1 else 0 end) as title_null,
    sum(case when year is null then 1 else 0 end) as year_null,
    sum(case when date_published is null then 1 else 0 end) as date_null,
    sum(case when duration is null then 1 else 0 end) as duration_null,
    sum(case when country is null then 1 else 0 end) as country_null,
    sum(case when worlwide_gross_income is null then 1 else 0 end) as income_null,
    sum(case when languages is null then 1 else 0 end) as languages_null,
    sum(case when production_company is null then 1 else 0 end) as production_null from movie;
    
    # id_null	title_null	year_null	date_null	duration_null	country_null	income_null	languages_null	production_null
	  #	  0  			0	        		0	  		0	      		0		      		20		    		3724	        	194					528

