-- SQL Crime Scene Investigation
-- Case: Murder in SQL City on January 15, 2018
-- Goal: Use SQL queries to identify the criminal and the mastermind behind the crime.

-- STEP 1: Retrieve the crime report for the murder case on Jan 15, 2018 in SQL City
		
		SELECT *
		FROM Crime_scene_report
		WHERE crime_type = 'murder'
		  AND date = 20180115
		  AND city = 'SQL City';

-- Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on "Northwestern Dr".
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".

-- STEP 2: Identify the two witnesses mentioned in the report
-- 2.1: First witness lives at the last house on Northwestern Dr

		SELECT *
		FROM person
		WHERE address_street_name = 'Northwestern Dr'
		ORDER BY address_number DESC
		LIMIT 1;

-- 2.2: Second witness named Annabel, lives on Franklin Ave

		SELECT *
		FROM person
		WHERE name LIKE 'Annabel%'
		AND address_street_name = 'Franklin Ave';


-- STEP 3: Get the interview transcripts of the two identified witnesses
-- Morty Schapiro (ID: 14887), Annabel Miller (ID: 16371)

		SELECT *
		FROM interview
		WHERE person_id IN (14887, 16371);

-- From Morty's statement:
-- Suspect fled carrying a "Get Fit Now Gym" bag
-- Membership number started with "48Z"
-- Bag was for GOLD members only
-- Car license plate contained "H42W"

-- From Annabel's statement:
-- She recognized the killer from her gym
-- She saw him on Jan 9, 2018


-- STEP 4: Search the gym members with gold status and IDs starting with "48Z"

		SELECT *
		FROM get_fit_now_member
		WHERE membership_status = 'gold'
		AND id LIKE '48Z%';

-- We have two persons with id that starts with '48Z' 
-- And have gold membership status
-- The first SUSPECT is Joe Germuska with 
						-- ID "48Z7A"
						-- Rerson ID 28819 
						-- Membership start date 20160305
						
-- the second SUSPECT is "Jeremy Bowers" with 
						-- ID "48Z55" 
						-- Person id 67318 
						-- Membership start date 20160101

-- STEP 5: Identify which of the two suspects owns a car with plate containing "H42W"
-- Suspects' person IDs: 28819 (Joe Germuska), 67318 (Jeremy Bowers)

		SELECT *
		FROM drivers_license
		WHERE id IN (
		    SELECT license_id
		    FROM person
		    WHERE id IN (28819, 67318)
		)
		AND plate_number LIKE '%H42W%';

--The person who owns the car with "H42W" Information:
						-- ID: 423327, Age: 30, Height-70
						-- Eyes_color: brown, hair_color:brown, 
						--Gender: male, Plate_number-0H42W2, 
						--Car_make: Chevrolet, Car_model: Spark LS.

-- STEP 6: Confirm the person associated with the matching license ID
-- Matching license ID: 423327 (plate: 0H42W2)

		SELECT *
		FROM person
		WHERE license_id = 423327;

-- RESULT: Jeremy Bowers (ID: 67318) is the killer
-- Let’s check his interview statement to identify who hired him

		SELECT *
		FROM interview
		WHERE person_id = 67318;

-- From Jeremy's confession:
-- Hired by a wealthy woman
-- Height: 5'5" to 5'7" (i.e. 65–67 inches)
-- Red hair
-- Drives a Tesla Model S
-- Attended SQL Symphony Concert 3 times in December 2017


-- STEP 7: Identify the person who matches all these criteria

-- 7.1: Get people who attended the SQL Symphony Concert 3 times in Dec 2017
-- 7.2: Cross-match with physical description and vehicle details

		SELECT *
		FROM person
		WHERE id IN (
		    SELECT person_id
		    FROM facebook_event_checkin
		    WHERE event_name = 'SQL Symphony Concert'
		      AND date BETWEEN 20171201 AND 20171231
		    GROUP BY person_id
		    HAVING COUNT(*) = 3
		)
		AND license_id IN (
		    SELECT id
		    FROM drivers_license
		    WHERE height BETWEEN 65 AND 67
		      AND hair_color = 'red'
		      AND car_make = 'Tesla'
		      AND car_model = 'Model S'
		);

-- RESULT: Miranda Priestly (ID: 99716) is the woman who hired Jeremy
-- Let’s verify her wealth status (as Jeremy said she was rich)

		SELECT *
		FROM income
		WHERE ssn = 987756388;

--Miranda Priestly is rich with networth of (310,000) as stated by JEREMY Bowers
