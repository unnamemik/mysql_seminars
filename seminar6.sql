USE seminar6;
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id INT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	email VARCHAR(100)
);

DROP PROCEDURE IF EXISTS copy_user_data;
DELIMITER //
CREATE PROCEDURE copy_user_data(selected_user_id INT)
BEGIN
	INSERT INTO users_old SELECT * FROM users 
    WHERE id = selected_user_id;
    DELETE FROM users WHERE id = selected_user_id;
END//
DELIMITER ;

CALL copy_user_data(2);


-- "зеркальная" процедура

DROP PROCEDURE IF EXISTS copy_user_data_back;
DELIMITER //
CREATE PROCEDURE copy_user_data_back(selected_user_id INT)
BEGIN
	INSERT INTO users SELECT * FROM users_old 
    WHERE id = selected_user_id;
    DELETE FROM users_old WHERE id = selected_user_id;
END//
DELIMITER ;

CALL copy_user_data_back(2);

/*--------------------------------------------------------*/

DROP FUNCTION IF EXISTS hello
DELIMITER //
CREATE FUNCTION hello()
RETURNS TINYTEXT READS SQL DATA
BEGIN
	DECLARE hour INT;
	SET hour = HOUR(NOW());
	CASE
		WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
		WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
	END CASE;
END//
DELIMITER ;

SELECT hello();

-- тестовая процедура
DROP FUNCTION IF EXISTS hello_test;
DELIMITER //
CREATE FUNCTION hello_test(test_value DATETIME)
RETURNS TINYTEXT READS SQL DATA
BEGIN
	DECLARE hour INT;
	SET hour = HOUR(test_value);
	CASE
		WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
		WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
	END CASE;
END//
DELIMITER ;

SELECT hello_test('2023-04-28 15:29:52');

/*--------------------------------------------------------*/


DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	item_id BIGINT(20) NOT NULL,
	name_value TEXT NOT NULL
) ENGINE = ARCHIVE;



-- ----------------------- TRIGGER ON users -----------------------
DROP TRIGGER IF EXISTS logs_users;
delimiter //
CREATE TRIGGER logs_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, item_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.firstname);
END //
delimiter ;

-- ----------------------- TRIGGER ON communities -----------------------
DROP TRIGGER IF EXISTS logs_communities;
delimiter //
CREATE TRIGGER logs_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, item_id, name_value)
	VALUES (NOW(), 'communities', NEW.id, NEW.name);
END //
delimiter ;

-- ----------------------- TRIGGER ON messages -----------------------
DROP TRIGGER IF EXISTS logs_messages;
delimiter //
CREATE TRIGGER logs_messages AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, item_id, name_value)
	VALUES (NOW(), 'messages', NEW.id, NEW.body);
END //
delimiter ;



-- ----------------------- Tests for users -----------------------
INSERT INTO users (id, firstname, lastname, email) VALUES 
(11, 'Vasiliy', 'Pupkin', 'vasilevs@example.org'),
(12, 'Vasilisa', 'Stupkina', 'stuppy@example.org'),
(13, 'Kondratiy', 'Qwerty', 'qwerty@example.org');

SELECT * FROM users;
SELECT * FROM logs;

-- ----------------------- Tests for communities -----------------------
INSERT INTO `communities` (name) 
VALUES ('limpopo'), ('zambia'), ('gvinea');

SELECT * FROM communities;
SELECT * FROM logs;

-- ----------------------- Tests for messages -----------------------
INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(4, 12, 'Voluptatem ut quaerat quia. In necessitatibus reprehenderit et. Ipsa rerum totam modi sunt sed. Nam accusantium aut qui quae nesciunt non.',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(11, 10, 'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Pariatur esse amet ratione qui quia. Voluptas atque eum et odio ea molestias ipsam architecto.',  DATE_ADD(NOW(), INTERVAL 3 MINUTE)),
(5, 1, 'Et tempora repudiandae saepe quo.',  DATE_ADD(NOW(), INTERVAL 5 MINUTE));

SELECT * FROM messages;
SELECT * FROM logs;


