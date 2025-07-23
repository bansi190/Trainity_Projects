/*create database project3;
show databases;
use project3;

create table user(
user_id	int,
created_at varchar(100),
company_id int,
language varchar(50),
activated_at varchar(100),
state varchar(50)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;
alter table user add column temp_created_at datetime;
update user set temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
alter table user drop column created_at;
alter table user change column temp_created_at created_at datetime;
select * from user;

create table events (
user_id	int,
occurred_at	varchar(100),
event_type varchar(50),
event_name varchar(100),
location varchar(50),
device varchar(50),
user_type int 
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;
alter table events add column temp_occurred_at datetime;
update events set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table events drop column occurred_at;
alter table events change column temp_occurred_at occurred_at datetime;
select * from events;

create table emailevents(
user_id	int,
occurred_at varchar(100),
action varchar(100),
user_type int
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE emailevents
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;
alter table emailevents add column temp_occurred_at datetime;
update emailevents set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table emailevents drop column occurred_at;
alter table emailevents change column temp_occurred_at occurred_at datetime;
select * from emailevents;
    
select year(occurred_at) as year, month(occurred_at) as month, 
floor((day(occurred_at) - 1) / 7) + 1 as week_of_month, 
count(distinct user_id) as weekly_active_users 
from events where event_type = 'engagement'
group by year, month, week_of_month
order by year, month, week_of_month;

select year(created_at) as year, month(created_at) as month, count(user_id) as new_users,
sum(count(user_id)) over (order by year(created_at), month(created_at)) as cumulative_users from user 
group by year, month
order by year, month;

with cohort as ( select user_id, year(created_at) as signup_year, month(created_at) as signup_month,
monthname(created_at) as signup_month_name from user),

activity as ( select user_id, year(occurred_at) as activity_year, month(occurred_at) as activity_month,
monthname(occurred_at) as activity_month_name from events),

retention as (select c.signup_year, c.signup_month, c.signup_month_name, 
(a.activity_year - c.signup_year) * 12 + (a.activity_month - c.signup_month) as months_since_signup,

count(distinct a.user_id) as retained_users from cohort c
left join activity a on c.user_id = a.user_id  
where (a.activity_year - c.signup_year) * 12 + (a.activity_month - c.signup_month) >= 0 
group by c.signup_year, c.signup_month, c.signup_month_name, months_since_signup
)

select r.signup_year, r.signup_month, r.signup_month_name, r.months_since_signup, r.retained_users, 
count(distinct c.user_id) as cohort_size,

round((r.retained_users / count(distinct c.user_id)) * 100, 2) as retention_rate from retention r

join cohort c on r.signup_year = c.signup_year and r.signup_month = c.signup_month

group by r.signup_year, r.signup_month, r.signup_month_name, r.months_since_signup
order by r.signup_year, r.signup_month, r.months_since_signup;

with user_cohorts as (select user_id, date_format(created_at, '%Y-%u') as signup_week from user),
user_activity as (select user_id, date_format(occurred_at, '%Y-%u') as activity_week 
from events where vent_type = 'engagement'),

retention_data as (
select c.signup_week AS cohort_week, a.activity_week,
count(distinct c.user_id) as cohort_size, count(distinct a.user_id) as active_users,
round(count(distinct a.user_id) * 100.0 / count(distinct c.user_id), 2) as retention_rate
from user_cohorts c

left join user_activity a on c.user_id = a.user_id and a.activity_week >= c.signup_week 
group by c.signup_week, a.activity_week)

select round(avg(retention_rate), 2) as overall_retention_rate from retention_data;

with cohort as (select user_id, year(created_at) as signup_year, month(created_at) as signup_month
from user),

activity as (select user_id, year(occurred_at) as activity_year, month(occurred_at) as activity_month
from events),

retention as (
select (a.activity_year - c.signup_year) * 12 + (a.activity_month - c.signup_month) as months_since_signup,
count(DISTINCT a.user_id) as retained_users from cohort c

left join activity a on c.user_id = a.user_id
where (a.activity_year - c.signup_year) * 12 + (a.activity_month - c.signup_month) >= 0
group by months_since_signup),
total_users as (select count(distinct user_id) as total_users from user)

select r.months_since_signup, r.retained_users, t.total_users,
round ((r.retained_users / t.total_users) * 100, 2) as overall_retention_rate from retention r

cross join total_users t
order by r.months_since_signup;

select device, count(*) as engagement_count from events
group by device
order by engagement_count desc;

select device, year(occurred_at) as year, week(occurred_at, 1) as week, count(*) as engagement_count
from events
group by device, year(occurred_at), week(occurred_at, 1)
order by device, year, week;

with weekly_engagements as (
select device, year(occurred_at) as year, week(occurred_at, 1) as week, count(*) as engagement_count
from events

group by device, year(occurred_at), week(occurred_at, 1))

select device, avg(engagement_count) as avg_weekly_engagement
from weekly_engagements

group by device
order by avg_weekly_engagement desc;

select action, count(*) as action_count, count(distinct user_id) as unique_users
from emailevents
group by action
order by action_count desc;*/

select date_format(occurred_at, '%Y-%M') as month_year, action, 
count(distinct user_id) as engaged_users, count(*) as total_actions,  
round(count(distinct user_id) / (select count(distinct user_id) from emailevents) * 100, 2) as engagement_rate
from emailevents

group by month_year, action
order by month_year, action;



	