create database user_db;
use user_db;
show tables;
drop table user_sub_sql_mentor06nov;
show tables;
select * from userdata;

#list all distinct users and their stats (return username, total_submissions, points earned)

select username, count(id) as total_submissions,
sum(points) as points_earned from userdata
group by username order by total_submissions desc;

#cal. the daily avg. points for each user. #each day, each user and their daily avg points, group by day and user

select 
#extract day and month extract( day from submitted_at)
date_format(submitted_at, '%d-%m') AS day_month,
username, avg(points) as daily_avg_points from userdata
group by username, day_month
order by username; 

#find the top 3 users with the most correct positive submissions for each day. 
#each day
#most correct submission

with daily_submissions as 
(
 select 
    date_format(submitted_at, '%d-%m') AS daily, username,
     sum(case
     when points > 0 then 1 else 0 
  END) as correct_submissions from userdata
group by username, daily ),
users_rank as (
select daily, username, correct_submissions, 
dense_rank() over(partition by daily order by correct_submissions desc) as ranking
from daily_submissions)
select daily, username, correct_submissions from users_rank where ranking <= 3;





#find the top 5 users with the highest  no: of incorrect submissions. 

select user_id, username, sum( case when points <=0 then 1 else 0 end) as incorrect_submissions
from userdata group by username, user_id order by incorrect_submissions desc limit 5;

#find the top 5 with correct submissions and the points earned for correct submission and the total points they earned

select user_id, username, sum(points) as total_points, sum(case when points >=0 then 1 else 0 end) as correct_submissions,
sum(case when points >=0 then points else 0 end) as right_points from userdata
group by user_id,username
order by correct_submissions desc limit 5;


#find the top ten performers for each week.
SELECT *
FROM (
    SELECT 
        user_id, 
        username, 
        SUM(points) AS total_points, 
        WEEK(submitted_at) AS week_num,
        DENSE_RANK() OVER (
            PARTITION BY WEEK(submitted_at)
            ORDER BY SUM(points) DESC
        ) AS ranking
    FROM userdata
    GROUP BY user_id, username, week_num
) AS ranked
WHERE ranking <= 10
ORDER BY week_num, ranking;








