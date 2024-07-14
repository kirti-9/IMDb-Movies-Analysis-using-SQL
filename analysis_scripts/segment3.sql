#######################################################
# Segment 3: Production Statistics and Genre Analysis #
#######################################################

use imdb;

-- -	Retrieve the unique list of genres present in the dataset.
select distinct(genre) from genre;
# genre
# Drama
# Fantasy
# Thriller
# Comedy
# Horror
# Family
# Romance
# Adventure
# Action
# Sci-Fi
# Crime
# Mystery
# Others

-- -	Identify the genre with the highest number of movies produced overall.
select * from(select genre,count(movie_id) as total_movies,row_number() over(order by count(movie_id) desc) as ranks from genre
    group by genre) d
    where ranks=1 ;
# genre	  total_movies	ranks
#  Drama	  4285		  1

-- -	Determine the count of movies that belong to only one genre.
select count(*) from (select count(*) from genre
    group by movie_id
    having count(genre)=1) as r;
# '3289'

-- -	Calculate the average duration of movies in each genre.
select g.genre,avg(m.duration) from genre as g join movie as m
    on g.movie_id=m.id
    group by g.genre;
# genre		avg(m.duration)
# Drama		106.7746
# Fantasy	105.1404
# Thriller	101.5761
# Comedy	102.6227
# Horror	92.7243
# Family	100.9669
# Romance	109.5342
# Adventure	101.8714
# Action	112.8829
# Sci-Fi	97.9413
# Crime		107.0517
# Mystery	101.8000
# Others	100.1600

-- -	Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.
select s.genre,s.ranks from (select genre,rank() over(order by count(genre) desc) as ranks from genre 
    group by genre) as s
    where genre='Thriller';
# genre		ranks
# Thriller	  3
