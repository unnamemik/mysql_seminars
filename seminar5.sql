 
-- возраст указал не менее 35, чтобы добавить хотя бы еще одного пользователя.
-- И дату рождения вывел, для наглядности.
CREATE VIEW view1 AS
SELECT firstname, lastname, hometown, gender, birthday FROM users, profiles
	WHERE user_id = id AND (TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 35);

SELECT * FROM seminar5.view1;


SELECT u.firstname, u.lastname, COUNT(from_user_id) AS 'msg_send',
       DENSE_RANK() OVER (order BY COUNT(from_user_id) DESC) AS 'msg_rank'
FROM messages, users u
WHERE from_user_id=u.id
GROUP BY u.id;


-- а тут можно поменять минуты на секунды
SELECT created_at, LAG(created_at, 1,0) OVER (ORDER BY created_at) AS 'msg_lag',
TIMESTAMPDIFF(MINUTE, LAG(created_at, 1,0) OVER (ORDER BY created_at), created_at) AS 'minutes'
FROM messages;
