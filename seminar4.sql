SELECT 
  user_id AS 'User id',
  (SELECT CONCAT (firstname, ' ', lastname) FROM users WHERE id = likes.user_id) AS 'Username',
  COUNT(*) AS 'Likes'
FROM 
  likes
WHERE (SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles 
	WHERE user_id = likes.user_id AND (TIMESTAMPDIFF(YEAR, birthday, NOW()) < 12)) IS NOT NULL
GROUP BY 
  user_id
ORDER BY user_id;


SELECT DISTINCT (SELECT SUM(user_id) FROM likes 
	WHERE id IN (SELECT user_id FROM profiles WHERE gender='f')) AS 'Females likes',
		(SELECT SUM(user_id) FROM likes 
			WHERE id IN (SELECT user_id FROM profiles WHERE gender='m')) AS 'Males likes';
			

SELECT CONCAT(firstname, ' ', lastname) AS 'Users not send msg' FROM users 
	WHERE id NOT IN (SELECT from_user_id FROM messages WHERE from_user_id>0);
	
	

SELECT CONCAT(firstname, ' ', lastname) AS 'Most sender, from-msg-to' FROM users 
	WHERE id = (SELECT MAX(from_user_id) FROM messages 
		WHERE to_user_id = (SELECT id FROM users WHERE 
			firstname='Austyn')) -- Пользователь-получатель.
UNION
SELECT SUM(to_user_id) FROM messages WHERE id = (SELECT id FROM users WHERE firstname='Austyn')
UNION
SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE firstname='Austyn';
