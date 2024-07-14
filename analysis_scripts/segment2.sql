###################################
# Segment 2: Movie Release Trends #
###################################

use imdb;

-- -	Determine the total number of movies released each year and analyse the month-wise trend.
select year,count(id) as total_movies from movie
	group by year;
select year,substr(date_published,6,2) as month,count(id) as total_movie
	from movie
	group by year,month
	order by year,month;
    # year	 month	total_movie
	# 2017	 01			291
	# 2017	 02			228
	# 2017	 03			298
	# 2017	 04			249
	# 2017	 05			205
	# 2017	 06			226
	# 2017	 07			188
	# 2017	 08			246
	# 2017	 09			327
	# 2017	 10			303
	# 2017	 11			276
	# 2017	 12			215
	# 2018	 01			302
	# 2018	 02			215
	# 2018	 03			285
	# 2018	 04			247
	# 2018	 05			229
	# 2018	 06			193
	# 2018	 07			167
	# 2018	 08			247
	# 2018	 09			276
	# 2018	 10			324
	# 2018	 11			252
	# 2018	 12			207
	# 2019	 01			211
	# 2019	 02			197
	# 2019	 03			241
	# 2019	 04			184
	# 2019	 05			191
	# 2019	 06			161
	# 2019	 07			138
	# 2019	 08			185
	# 2019	 09			206
	# 2019	 10			174
	# 2019	 11			 97
	# 2019	 12			 16


-- 2.Calculate the number of movies produced in the USA or India in the year 2019.
select count(*) from movie
	where (country='USA' or country='INDIA') and year=2019;
# 887
