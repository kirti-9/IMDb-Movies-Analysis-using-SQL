############################
# Segment 5: Crew Analysis #
############################

use imdb;

-- -	Identify the columns in the names table that have null values.
select sum(case when id is null then 1 else 0 end) as id_nulls,
sum(case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;
# id_nulls	name_nulls	height_nulls	date_of_birth_nulls	known_for_movies_nulls
# 	0			0			17335				13431				15226

-- -	Determine the top three directors in the top three genres with movies having an average rating > 8.
with cte as (select genre from (select genre,rank() over(order by count(g.movie_id) desc) as ranks
      from genre g left join ratings r on g.movie_id=r.movie_id
      where avg_rating>8
      group by genre) a
      where ranks<=3),
      cte2 as (select name,genre,count(m.id) as total_movie,row_number() over(partition by genre order by count(m.id) desc) as director_rank
      from movie m
	  left join genre g on m.id=g.movie_id
	  left join director_mapping d on d.movie_id=m.id
	  left join names n on n.id=d.name_id
      where name is not null
      group by genre,name,n.id
      )
     select * from cte2 where genre in (select genre from cte) 
     and director_rank<=3;
# name                    genre   total_movie   director_rank
# Sam Liu                 Action  4             1
# Jesse V. Johnson        Action  3             2
# Anthony Russo           Action  2             3
# Ksshitij Chaudhary      Comedy  3             1
# Luis Eduardo Reyes      Comedy  3             2
# Yûichi Fukuda           Comedy  3             3
# Steven Soderbergh       Drama   4             1
# Jean-Claude La Marre    Drama   3             2
# Hatef Alimardani        Drama   3             3

-- -	Find the top two actors whose movies have a median rating >= 8.
select * from (select name, count(m.id) as movie_count,row_number() over(order by count(m.id) desc)as ranks from names n left join role_mapping r on
      (n.id=r.name_id)
      left join ratings ri on r.movie_id=ri.movie_id
      left join movie m on m.id=r.movie_id
      where category = 'actor' and median_rating>=8
      group by n.id,n.name) s
      where ranks<=2;
# name		movie_count	ranks
# Mammootty		8		1
# Mohanlal		5		2

-- -	Identify the top three production houses based on the number of votes received by their movies.
 with cte as (select production_company,sum(total_votes) as total_vote from movie m 
      left join ratings r on m.id=r.movie_id
      group by production_company
      order by total_vote desc),
	cte2 as (select *,row_number() over(order by total_vote desc)as ranks from cte)
      (select * from cte2 where ranks<=3);     
# production_company	total_vote	ranks
# Marvel Studios		2656967		1
# Twentieth Century Fox	2411163		2
# Warner Bros.			2396057		3

-- -	Rank actors based on their average ratings in Indian movies released in India.
select name,avg(avg_rating) as avg_ratings,row_number() over(order by avg(avg_rating) desc) as ranks 
      from movie m left join ratings r on m.id=r.movie_id
      left join role_mapping rm on r.movie_id=rm.movie_id
      left join names n on rm.name_id=n.id
      where category='actor' and country='India'
      group by n.id,n.name;
# top 5 rows of output:
# name				avg_ratings	ranks
# Gopi Krishna		9.70000			1
# Shilpa Mahendar	9.70000			2
# Priyanka Augustin	9.70000			3
# Aryan Gowda		9.60000			4
# Naveen D. Padil	9.60000			5

-- -	Identify the top five actresses in Hindi movies released in India based on their average ratings.
select * from (select name,avg(avg_rating) as avg_ratings,row_number() over(order by avg(avg_rating) desc) as ranks from 
	  movie m left join ratings r on m.id=r.movie_id
	 left join role_mapping rm on m.id=rm.movie_id
	 left join names n on rm.name_id=n.id
	 where category='actress' and country='India' and languages='hindi'
     group by n.id,n.name) k
	 where ranks<=5;
# name                      avg_ratings   ranks
# Pranati Rai Prakash       9.40000       1
# Leera Kaljai              9.20000       2
# Vibhawari Deshpande       8.30000       3
# Divya Unny                8.30000       4
# Chitrangada Chakraborty   8.30000       5
