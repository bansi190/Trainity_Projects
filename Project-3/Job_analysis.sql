use project3;
/*
create table jobs (
    job_id int,
    actor_id int not null,
    event enum('decision', 'skip', 'transfer') not null,
    language varchar(50),
    time_spent int check (time_spent >= 0), 
    org varchar(100),
    ds varchar(10)
);

insert into jobs (ds, job_id, actor_id, event, language, time_spent, org)
values
('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
('2020-11-28', 23, 1005, 'transfer', 'Persian', 22, 'D'),
('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');
select*from jobs;

select ds, count(job_id) as total_jobs_reviewed, count(job_id)/24 as avg_jobs_reviewed_per_hour from jobs
where ds between '2020-11-01' and '2020-11-30'  
group by ds  
order by ds;


with daily_throughput as(
select ds, count(*) as total_events, sum(time_spent) as total_time_spent from jobs group by ds),
throughput as (select ds, total_events, total_time_spent, total_events / total_time_spent as throughput from daily_throughput)
select ds, throughput, avg(throughput) 
over (order by ds rows between 6 preceding and current row) as rolling_avg_throughput 
from throughput
order by ds;

select la.language, round((la.job_count * 100.0 / tc.total_jobs), 2) as percentage_share
from (select language, count(job_id) as job_count from jobs where ds >= '2020-11-01' and ds <= '2020-11-30'
     group by language) la,
    (select count(job_id) as total_jobs
     from jobs where ds >= '2020-11-01' and ds <= '2020-11-30') tc
order by percentage_share desc;

select ds, job_id, actor_id, event, language, time_spent, org, count(*) as duplicate_count from jobs
group by ds, job_id, actor_id, event, language, time_spent, org
having count(*) > 1;*/



