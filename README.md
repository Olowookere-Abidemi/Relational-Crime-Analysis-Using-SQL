# Relational-Crime-Analysis-Using-SQL

## Table of Contents

* [Project Description](#project-description)
* [Objective](#objective)
* [Why This Project?](#why-this-project)
* [How It Was Done](#how-it-was-done)
* [Step-by-Step Analysis](#step-by-step-analysis)

  * [Step 1: Retrieve the crime report](#step-1-retrieve-the-crime-report)
  * [Step 2: Identify the witnesses](#step-2-identify-the-witnesses)
  * [Step 3: Retrieve interview statements](#step-3-retrieve-interview-statements)
  * [Step 4: Filter gym members based on clues](#step-4-filter-gym-members-based-on-clues)
  * [Step 5: Match suspect with license plate](#step-5-match-suspect-with-license-plate)
  * [Step 6: Confirm identity of the person with matching license](#step-6-confirm-identity-of-the-person-with-matching-license)
  * [Step 7: Get interview from the suspect](#step-7-get-interview-from-the-suspect)
  * [Step 8: Identify the mastermind](#step-8-identify-the-mastermind)
  * [Step 9: Confirm financial motive](#step-9-confirm-financial-motive)
* [Final Outcome](#final-outcome)
* [Key Skills Demonstrated](#key-skills-demonstrated)
* [Tools Used](#tools-used)
* [Attachments](#attachments)


---

## Project Description

An interactive SQL-based investigation into a fictional murder case set in SQL City. This project demonstrates how data storytelling and structured query logic can be used to solve a crime using real-world data analysis techniques. From witness interviews to identifying key suspects through license plates, gym memberships, and event check-ins, each insight was uncovered using SQL alone.

---

## Objective

To identify both the murderer and the mastermind behind a crime committed on January 15, 2018, by analyzing a police department database using SQL.

---

## Why This Project?

This project blends structured query language with logical reasoning to solve a complex problem. It simulates an investigative process where insights are not directly visible but must be inferred by:

* Extracting specific rows from large datasets
* Cross-referencing multiple tables
* Applying conditions to filter relevant information
* Connecting seemingly unrelated data points

This mirrors the tasks of data analysts, investigators, and intelligence analysts in the real world.

---

## How It Was Done

This investigation was conducted using SQL on a multi-table police database. The core approach involved:

* Filtering based on specific criteria
* Using `JOIN`, `LIKE`, `IN`, `BETWEEN`, `GROUP BY`, and subqueries
* Matching partial details like street names, dates, and vehicle plates
* Identifying patterns across data domains (e.g. people, vehicles, events, income)

---

## Step-by-Step Analysis

### Step 1: Retrieve the crime report

```sql
SELECT *
FROM Crime_scene_report
WHERE crime_type = 'murder'
  AND date = 20180115
  AND city = 'SQL City';
```

This revealed two key witnesses:

* One lives at the last house on Northwestern Dr
* Another named Annabel lives on Franklin Ave

---

### Step 2: Identify the witnesses

**First witness – last house on Northwestern Dr:**

```sql
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;
```

**Second witness – named Annabel on Franklin Ave:**

```sql
SELECT *
FROM person
WHERE name LIKE 'Annabel%'
  AND address_street_name = 'Franklin Ave';
```

---

### Step 3: Retrieve interview statements

```sql
SELECT *
FROM interview
WHERE person_id IN (14887, 16371);
```

* Morty Schapiro saw the suspect fleeing with a **Get Fit Now gym bag**, gold member, ID starts with `48Z`, and license plate containing `H42W`.
* Annabel Miller recognized the killer from the gym on **Jan 9, 2018**.

---

### Step 4: Filter gym members based on clues

```sql
SELECT *
FROM get_fit_now_member
WHERE membership_status = 'gold'
  AND id LIKE '48Z%';
```

Results:

* Joe Germuska – ID: 48Z7A, person\_id: 28819
* Jeremy Bowers – ID: 48Z55, person\_id: 67318

---

### Step 5: Match suspect with license plate

```sql
SELECT *
FROM drivers_license
WHERE id IN (
  SELECT license_id
  FROM person
  WHERE id IN (28819, 67318)
)
AND plate_number LIKE '%H42W%';
```

Match found:

* License ID: 423327 (plate number: 0H42W2)

---

### Step 6: Confirm identity of the person with matching license

```sql
SELECT *
FROM person
WHERE license_id = 423327;
```

Result:

* Jeremy Bowers (ID: 67318) is confirmed as the killer

---

### Step 7: Get interview from the suspect

```sql
SELECT *
FROM interview
WHERE person_id = 67318;
```

Jeremy confessed:

* He was hired by a wealthy woman with red hair
* Height: 5'5" to 5'7"
* Drives a Tesla Model S
* Attended the SQL Symphony Concert 3 times in December 2017

---

### Step 8: Identify the mastermind

```sql
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
```

Result:

* Miranda Priestly (ID: 99716)

---

### Step 9: Confirm financial motive

```sql
SELECT *
FROM income
WHERE ssn = 987756388;
```

Result:

* Net worth: 310,000

---

## Final Outcome

* **Killer:** Jeremy Bowers (ID: 67318)
* **Mastermind:** Miranda Priestly (ID: 99716)

The murder was committed by Jeremy under the direction of Miranda, a wealthy individual who attended concerts, matched the vehicle and physical description, and had the means to pay for a hit.

---

## Key Skills Demonstrated

* Structured query logic
* Data filtering and multi-table joins
* Pattern matching using SQL
* Logical deduction through partial data
* Cross-referencing identifiers across domains

---

## Tools Used

* PostgreSQL (SQL)
* Multi-table relational schema
* GitHub for documentation

---

## Attachments

* **Database File:** [`Police_Database.backup`](./Police_Database.backup)
* **SQL Script File:** [`murder_investigation.sql`](https://github.com/Olowookere-Abidemi/Relational-Crime-Analysis-Using-SQL/blob/main/INVESTIATIVE%20ANALYSIS.sql)

---
