
-- Creating a Stored FUNCTION
CREATE OR REPLACE FUNCTION count_last_name_starts_with_actors(letter VARCHAR(1))
RETURNS INTEGER
AS $actor_count$
    DECLARE actor_count int;
BEGIN
    SELECT COUNT(*) INTO actor_count
    FROM actor
    WHERE last_name LIKE CONCAT(letter, '%');

    RETURN actor_count;
END;
$actor_count$
LANGUAGE plpgsql;


SELECT count_last_name_starts_with_actors('C');

SELECT *
FROM actor
WHERE last_name LIKE 'C%'



-- Create a Stored PROCEDURE
CREATE OR REPLACE PROCEDURE latefee(rental INTEGER, late_fee_amount DECIMAL)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Add late fee to payment amount for rental
    UPDATE payment
    SET amount = amount + late_fee_amount
    WHERE rental_id = rental;

    -- Commit the above statement inside of a TRANSACTION
    COMMIT;

END;
$$

-- Check the current amount for rental
SELECT *
FROM payment
WHERE rental_id = 2190; 
-- Current amount = 5.99

-- Execute/call our procedure
CALL latefee(2190, 1.00);


-- Recheck rental amount after procedure call
SELECT *
FROM payment
WHERE rental_id = 2190; 
-- Current amount = 6.99


SELECT COUNT(*)
FROM actor;

-- Create a Procedure to add actors to the actor TABLE
CREATE OR REPLACE PROCEDURE add_actor(
    _first_name VARCHAR, 
    _last_name VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO actor(first_name, last_name, last_update)
    VALUES (_first_name, _last_name, NOW()::timestamp);
END;
$$

CALL add_actor('Penelope', 'Cruz');

SELECT *
FROM actor
WHERE last_name = 'Cruz';


DROP PROCEDURE IF EXISTS add_actor(_first_name character varying, _last_name character varying, _last_update timestamp without time zone);

DROP FUNCTION count_last_name_starts_with_actors;