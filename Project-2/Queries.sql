/*select id, username, created_at from users 
order by created_at asc
limit 5;*/

/*select id, username from users 
where not exists (
select * from photos 
where users.id = photos.user_id );*/

select photo_id, photos.image_url, users.username, count(likes.user_id) as total_likes from photos 
join likes on photos.id = likes.photo_id
join users on photos.user_id = users.id
group by photos.id, users.username
order by total_likes desc
limit 10;


/*select tag_name, count(photo_tags.photo_id) as usage_count from tags 
join photo_tags on tags.id = photo_tags.tag_id
group by tags.id, tags.tag_name
order by usage_count desc
limit 5;*/

/*select dayname(created_at) as day_of_week, count(*) as registrations from users
group by dayname(created_at)
order by registrations desc
limit 5;*/


/*select count(*) as total_photos,
(select count(*) from users) as total_users, 
round(count(*) / (select count(*) from users)) as avg_posts from photos;*/

/*select users.id, users.username, count(likes.photo_id) as total_likes from users 
join likes on users.id = likes.user_id
group by users.id, users.username
having count(likes.photo_id) = (select count(*) from photos);*/






