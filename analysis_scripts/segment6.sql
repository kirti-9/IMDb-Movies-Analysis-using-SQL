############################################
# Segment 6: Broader Understanding of Data #
############################################

use imdb;

-- -	Classify thriller movies based on average ratings into different categories.
select title,avg_rating,case when avg_rating>8 then 'Hit Movie'
      when avg_rating<=4 then 'Flop Movie' else 'Avg Movie' end as category
      from movie m left join ratings r on m.id=r.movie_id
      left join genre g on m.id=g.movie_id
      where genre='Thriller';
# top 5 rows from the output:
# title             avg_rating   category
# Der müde Tod      7.7          Avg Movie
# Fahrenheit 451    4.9          Avg Movie
# Pet Sematary      5.8          Avg Movie
# Dukun             6.9          Avg Movie
# Back Roads        7.0          Avg Movie

-- -	analyse the genre-wise running total and moving average of the average movie duration.
SELECT genre, year, average_duration,
    SUM(average_duration) OVER (PARTITION BY genre ORDER BY year) AS running_total_duration,
    AVG(average_duration) OVER (PARTITION BY genre ORDER BY year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average_duration
FROM (
    SELECT g.genre, m.year, AVG(m.duration) AS average_duration FROM movie m
    JOIN genre g ON m.id = g.movie_id
    GROUP BY g.genre, m.year
) AS genre_avg
ORDER BY genre, year;
# top 5 rows from output:
# genre      year   average_duration   running_total_duration   moving_average_duration
# Action     2017   111.7827           111.7827                111.78270000
# Action     2018   112.2321           224.0148                112.00740000
# Action     2019   115.7143           339.7291                113.24303333
# Adventure  2017   102.1174           102.1174                102.11740000
# Adventure  2018   100.5885           202.7059                101.35295000

-- -	Identify the five highest-grossing movies of each year that belong to the top three genres.
SELECT year, genre, title, worlwide_gross_income
FROM (
    SELECT m.year, g.genre, m.title, m.worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS ranking
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN ('Thriller', 'Comedy', 'Drama')
) AS ranked_movies
WHERE ranking <= 5
ORDER BY year, genre, ranking;

-- -	Determine the top two production houses that have produced the highest number of hits among multilingual movies.
select * from (select production_company,count(id) total_hits,row_number() over(order by count(id) desc) as ranks
      from movie
      where languages like '%,%' and production_company !=''
      group by production_company)a
      where ranks<=2;
# production_company	total_hits	ranks
# Star Cinema				12			1
# Warner Bros.				10			2

-- -	Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
select* from (select name,count(m.id) as total_movie,avg(avg_rating) as rating ,row_number() over(order by (count(m.id)) desc) as ranks
      from  movie m left join ratings r on m.id=r.movie_id
      left join role_mapping rm on m.id=rm.movie_id
      left join names n on n.id=rm.name_id
      where category='actress' and avg_rating>8
      group by n.id,name) a
      where ranks<=3;
# name					total_movie	rating	ranks
# Shraddha Srinath			2		8.55000		1
# Parvathy Thiruvothu		2		8.20000		2
# Susan Brown				2		8.95000		3

-- -	Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
 select * from (select name,n.id,count(m.id) as total_movies,avg(avg_rating),avg(duration),row_number() over(order by count(m.id) desc,avg(avg_rating) desc,avg(duration)desc) as ranks
      from movie m left join director_mapping dm on m.id=dm.movie_id
      left join names n on dm.name_id=n.id
      left join ratings r on m.id=r.movie_id
      where name is not null
      group by name,n.id) a
      where ranks <=9
# name                  id         total_movies   avg(avg_rating)   avg(duration)   ranks
# A.L. Vijay            nm1777967  5              5.42000           122.6000        1
# Andrew Jones          nm2096009  5              3.02000           86.4000         2
# Steven Soderbergh     nm0001752  4              6.47500           100.2500        3
# Sam Liu               nm0515005  4              6.22500           78.0000         4
# Sion Sono             nm0814469  4              6.02500           125.5000        5
# Jesse V. Johnson      nm0425364  4              5.45000           95.7500         6
# Justin Price          nm2691863  4              4.50000           86.5000         7
# Chris Stokes          nm0831321  4              4.32500           88.0000         8
# Özgür Bakar           nm6356309  4              3.75000           93.5000         9

