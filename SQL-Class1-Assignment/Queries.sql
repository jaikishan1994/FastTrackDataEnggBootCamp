/* Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
The CountryCode for America is USA. */
SELECT ID, NAME, COUNTRYCODE, DISTRICT, POPULATION
FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 100000;

/* Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
The CountryCode for America is USA. */
SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 120000;

/* Q3. Query all columns (attributes) for every row in the CITY table. */
SELECT *
FROM CITY;

/* Q4. Query all columns for a city in CITY with the ID 1661. */
SELECT *
FROM CITY
WHERE ID = 1661;

/* Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN. */
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';

/* Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN. */
SELECT NAME
FROM CITY;

/* Q7. Query a list of CITY and STATE from the STATION table */
SELECT CITY, STATE
FROM STATION;

/* Q8. Query a list of CITY names from STATION for cities that have an even ID number. 
Print the results in any order, but exclude duplicates from the answer. */
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0;

/* Q9. Find the difference between the total number of CITY entries in the table and the number of
distinct CITY entries in the table. */
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) CITY_Dup_Count
FROM STATION;

/* Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
largest city, choose the one that comes first when ordered alphabetically. */
SELECT lg.Longest_Length_City, lg.Length Longest_CityName_Length, st.Shortest_Length_City, st.Length Shortest_CityName_Length
FROM (SELECT CITY Longest_Length_City, LENGTH(CITY) Length
FROM STATION
ORDER BY LENGTH(CITY) DESC, CITY ASC LIMIT 1) lg, (SELECT CITY Shortest_Length_City, LENGTH(CITY) Length
FROM STATION
ORDER BY LENGTH(CITY), CITY LIMIT 1)st;

/* Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
cannot contain duplicates. */
SELECT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '^[a,e,i,o,u]';
/*WHERE LOWER(CITY) like 'a%'
	OR LOWER(CITY) like 'e%'
    OR LOWER(CITY) like 'i%'
    OR LOWER(CITY) like 'o%'
    OR LOWER(CITY) like 'u%'; */

/* Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. 
Your result cannot contain duplicates. */
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '[a,e,i,o,u]$';
/*WHERE LOWER(CITY) like '%a'
	OR LOWER(CITY) like '%e'
    OR LOWER(CITY) like '%i'
    OR LOWER(CITY) like '%o'
    OR LOWER(CITY) like '%u'; */

/* Q13. Query the list of CITY names from STATION that do not start with vowels. 
Your result cannot contain duplicates. */
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '^[^a,e,i,o,u]';
/* WHERE LOWER(CITY) not like 'a%'
	AND LOWER(CITY) not like 'e%'
    AND LOWER(CITY) not like 'i%'
    AND LOWER(CITY) not like 'o%'
    AND LOWER(CITY) not like 'u%'; 

/* Q14. Query the list of CITY names from STATION that do not end with vowels. 
Your result cannot contain duplicates. */
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '[^a,e,i,o,u]$';
/* WHERE LOWER(CITY) not like '%a'
	AND LOWER(CITY) not like '%e'
    AND LOWER(CITY) not like '%i'
    AND LOWER(CITY) not like '%o'
    AND LOWER(CITY) not like '%u'; 

/* Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. 
Your result cannot contain duplicates. */
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '^[^a,e,i,o,u]' OR LOWER(CITY) REGEXP '[^a,e,i,o,u]$';

/* Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. 
Your result cannot contain duplicates. */
SELECT DISTINCT CITY
FROM STATION
WHERE LOWER(CITY) REGEXP '^[^a,e,i,o,u]' AND LOWER(CITY) REGEXP '[^a,e,i,o,u]$';

/*Q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive.
Return the result table in any order.
The query result format is in the following example */
SELECT prd.product_id, prd.product_name
FROM PRODUCT prd
JOIN SALES s
ON prd.product_id = s.product_id
WHERE s.sale_date BETWEEN '2019-01-01' AND '2019-03-31';

/*Q18. Write an SQL query to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order. */

SELECT DISTINCT viewer.viewer_id id
FROM VIEWS author
JOIN VIEWS viewer
ON author.author_id = viewer.viewer_id;

/*Q19. If the customer's preferred delivery date is the same as the order date, then the order is called immediately; otherwise, it is called scheduled.
Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places. */
SELECT ROUND((od.COUNT/d.Total_Count)* 100,2) Delivery_Percentage
FROM (
	SELECT DISTINCT CASE WHEN order_date = customer_pref_delivery_date THEN 'IMMEDIATE' ELSE 'DELAY' END ORDER_DELIVERY, COUNT(1) OVER(PARTITION BY CASE WHEN order_date = customer_pref_delivery_date THEN 'IMMEDIATE' ELSE 'DELAY' END) COUNT
	FROM Delivery
)od, (SELECT COUNT(1) Total_Count FROM Delivery)d
WHERE od.ORDER_DELIVERY = 'IMMEDIATE';

/*Q20. A company is running Ads and wants to calculate the performance of each Ad.
Performance of the Ad is measured using Click-Through Rate (CTR) where:
Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points. 
CTR = {0 	if 		Ad total clicks + Ad total views is 0, 
			else 	(Ad total clicks)/(Ad total clicks + Ad total views) * 100 } 
Table Schema Ads(ad_id, user_id, action) */

WITH CTE_AdClicksViews AS (SELECT ad_id, action, COUNT(action) cnt
		FROM Ads 
		GROUP BY ad_id, action 
		)
SELECT DISTINCT all_actions.ad_id, COALESCE(ROUND(tmp.ctr,2), 0) ctr
FROM CTE_AdClicksViews all_actions
LEFT JOIN
(
	SELECT clicks.ad_id, ((clicks.clicks)/(clicks.clicks + views.views)) * 100 ctr
	FROM (	SELECT ad_id, SUM(cnt) clicks
			FROM CTE_AdClicksViews 
			GROUP BY ad_id, action
			HAVING action = 'Clicked'
	) clicks
    JOIN
		(	SELECT ad_id, SUM(cnt) views
			FROM CTE_AdClicksViews 
			GROUP BY ad_id, action
			HAVING action = 'Viewed'
	) views
	ON clicks.ad_id = views.ad_id
) tmp
ON all_actions.ad_id = tmp.ad_id;

/*Q21. Write an SQL query to find the team size of each of the employees.
Return result table in any order. */
SELECT employee_id, COUNT(1) OVER(PARTITION BY team_id) count
FROM Employee;

/*Q22. Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
Return result table in any order. */
WITH CTE_WeatherState_Nov AS (
		SELECT c.country_name, w.country_id, AVG(w.weather_state) AVG_Weather_State
		FROM Countries c
		JOIN Weather w
		ON c.country_id = w.country_id
        AND w.day BETWEEN '2019-11-01' AND '2019-11-30'
        GROUP BY c.country_name, w.country_id
)
SELECT country_name, CASE WHEN AVG_Weather_State <= 15 THEN 'Cold' WHEN AVG_Weather_State >= 25 THEN 'Hot' ELSE 'Warm' END TypeOfWeather
FROM CTE_WeatherState_Nov;

/*Q23. Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.  Return the result table in any order. */
WITH CTE_TotalSaleProductWise AS(
	SELECT p.product_id, SUM(p.price * u.units) totalSale
	FROM Prices p
	JOIN UnitsSold u
	ON p.product_id = u.product_id
	WHERE u.purchase_date BETWEEN p.start_date AND p.end_date
    GROUP BY product_id
)
SELECT cte.product_id, ROUND(cte.totalSale/tus.totalUnitsSold,2) average_price
FROM CTE_TotalSaleProductWise cte
JOIN (	SELECT product_id, SUM(units) totalUnitsSold
		FROM UnitsSold
        GROUP BY product_id
	) tus
ON tus.product_id = cte.product_id;

/*Q24.Write an SQL query to report the first login date for each player.
Q25. Write an SQL query to report the device that is first logged in for each player.
Return the result table in any order. */
SELECT player_id, device_id, event_date
FROM (
	SELECT player_id, device_id, event_date, ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) r_no
	FROM Activity
    )act
WHERE act.r_no = 1;
