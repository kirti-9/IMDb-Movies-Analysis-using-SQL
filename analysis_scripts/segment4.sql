################################################
# Segment 4: Ratings Analysis and Crew Members #
################################################

use imdb;

-- -	Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
 select max(avg_rating),min(avg_rating),
      max(total_votes),min(total_votes),
      max(median_rating),min(median_rating)
      from ratings;
# max(avg_rating)	min(avg_rating)	max(total_votes)	min(total_votes)	max(median_rating)	min(median_rating)
# 	10.0				1.0				725138				100					10					1

-- -	Identify the top 10 movies based on average rating.
select * from(select m.title,r.avg_rating,row_number() over(order by r.avg_rating desc) as ranks from ratings r
      join movie m on r.movie_id=m.id)s
      where ranks<=10;
# title                              avg_rating	ranks
# Kirket                             10.0	        1
# Love in Kilnerry                   10.0	        2
# Gini Helida Kathe                  9.8	        3
# Runam                              9.7	        4
# Fan                                9.6	        5
# Android Kunjappan Version 5.25     9.6	        6
# Yeh Suhaagraat Impossible          9.5	        7
# Safe                               9.5	        8
# The Brighton Miracle               9.5	        9
# Shibu                              9.4	        10

-- -	Summarise the ratings table based on movie counts by median ratings.
select median_rating,count(movie_id)
      from ratings
      group by median_rating
      order by median_rating;
# median_rating	count(movie_id)
# 1               94
# 2              119
# 3              283
# 4              479
# 5              985
# 6             1975
# 7             2257
# 8             1030
# 9              429
# 10             346
      
-- -	Identify the production house that has produced the most number of hit movies (average rating > 8).
select * from (select production_company, count(id) as movie_count,
	row_number() over (order by count(id) desc) as ranks from movie
	left join ratings on movie_id=id
	where avg_rating>8 and production_company!=''
	group by production_company) a where ranks=1;
# production_company	movie_count	ranks
# Dream Warrior Pictures	3		   1

-- -	Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.
select genre,count(id) as total_movies from movie
     left join genre g on g.movie_id=id
     left join ratings r on r.movie_id=id
     where total_votes>1000 and substr(date_published,6,2)='03' and year=2017
     and country='USA'
     group by genre
     order by genre;
# genre   total_movies
# Action        4
# Comedy        8
# Crime         5
# Drama        16
# Family        1
# Fantasy       2
# Horror        5
# Mystery       2
# Romance       3
# Sci-Fi        4
# Thriller      4

-- -	Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.
select genre,title,avg_rating
      from movie m left join genre g on m.id=g.movie_id
      left join ratings r on m.id=r.movie_id
      where title like 'The%'
      and avg_rating>8
      order by genre;
# genre     title                                    avg_rating
# Action    Theeran Adhigaaram Ondru                 8.3
# Crime     The Irishman                             8.7
# Crime     Theeran Adhigaaram Ondru                 8.3
# Crime     The Gambinos                             8.4
# Drama     The Blue Elephant 2                      8.8
# Drama     The Brighton Miracle                     9.5
# Drama     The Irishman                             8.7
# Drama     The Colour of Darkness                   9.1
# Drama     The Mystery of Godliness: The Sequel     8.5
# Drama     The Gambinos                             8.4
# Drama     The King and I                           8.2
# Horror    The Blue Elephant 2                      8.8
# Mystery   The Blue Elephant 2                      8.8
# Romance   The King and I                           8.2
# Thriller  Theeran Adhigaaram Ondru                 8.3

