--Table creation, using sqlite I had to split up the files for Apple Store Description and merge them due to restraints

CREATE TABLE appleStore_description_merged AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4


//Exploring the data//

--Checking the number of distinct app ids in both tables(AppleStore and appleStore_description_merged)

SELECT Count(DISTINCT(id))
From AppleStore

SELECT Count(DISTINCT(id))
From appleStore_description_merged

--Both tables return 7197 so there is no missing data between these two tablesAppleStore

--Checking if any of the key fields have missing values

SELECT Count(*) AS MissingValues
From AppleStore
Where track_name is NULL or user_rating is NULL OR prime_genre IS NULL

SELECT Count(*) AS MissingValues
From appleStore_description_merged
Where app_desc IS NULL

-- None of the key fields that I will use for analysis come back as null so there are no missing valuesAppleStore

-- Checking the number of apps per genre

Select prime_genre, COUNT(*) AS Number_of_Apps
From AppleStore
Group by prime_genre
Order BY Number_of_Apps DESC

-- Games are the highest with a count of 3882 apps while second place is Entertainment with a count of 535 apps

-- Rating Overview

Select 
		max(user_rating) As MaxRating,
        min(user_rating) AS MinRating,
        avg(user_rating) AS AverageRating
From AppleStore

-- Displays the rating ranges from 0-5 with an average rating of roughly 3.5

-- App Desc Length Overview

SELECT 
		max(length(app_desc)) AS Max_Desc_Length,
        min(length(app_desc)) AS Min_Desc_Length,
		avg(length(app_desc)) AS Average_Desc_Length
FROM appleStore_description_merged

-- App description length ranges from 6-4000 characters with an average description length of around 1553 characters


//Data Analysis//

-- Which apps have higher rating, free or paid?

Select CASE
			When price > 0 Then 'Paid'
            Else 'Free'
            End As App_Price_Type,
            avg(user_rating)
From AppleStore
group by App_Price_Type

--This shows that paid apps have a slightly higher rating of 3.7 to the average rating of free apps which is 3.3

-- Does the amount of supported langauges affect rating?

Select CASE
			When lang_num < 5 Then 'Less than 5'
            When lang_num BETWEEN 5 and 10 Then 'Between 5-10'
            When lang_num BETWEEN 10 and 15 Then 'Between 10-15'
            When lang_num > 15 Then 'Greater than 15'
            End As App_Lang_Amount,
            avg(user_rating)
From AppleStore
group by App_Lang_Amount

--It appears like between 10-15 languages is the sweet spot for app rating
-- Larger amounts of languages than that range cause ratings to dip off
-- If this metric were to be graphed in the future it may show a bell curve

--Checking for the 5 lowest rating genres

Select prime_genre, avg(user_rating) As AverageRating
From AppleStore
Group by prime_genre
Order BY AverageRating ASC
Limit 5

-- This shows that Catalogs, Finance, Books, Navigation, and Lifestyle have the lowest avg rating
-- This reveals gaps in the market that our hypothetical stakeholder could fill
-- Also illustrates the need for more research into the gaps in these specific sectors if that path was to be taken
-- Example: What are users asking for in these genres that is being overlooked?

--Does description length have any correlation to app rating?
Select CASE
			When length(b.app_desc) < 300 Then 'Less than 300 characters'
            When length(b.app_desc) BETWEEN 300 and 900 Then 'Between 300 and 900 characters'
            When length(b.app_desc) BETWEEN 900 and 1500 Then 'Between 900 and 1500 characters'
            When length(b.app_desc) > 1500 Then 'Greater than 1500 characters'
            End As App_Desc_Length_Group,
            avg(A.user_rating) as AverageRating
From AppleStore As A 
	join appleStore_description_merged As B 
	on A.id = B.id
Group by App_Desc_Length_Group
Order By AverageRating DESC

-- The results show that the highest rating based on description length is for descriptions higher than 1500 characters
-- It also interestingly shows that the longer the description, as the categories also descend by character amount
-- Our potential stakeholder should consider a longer description for better clarity and rating


//Summarizing Insights//

-- Paid apps have higher average ratings, so further insights on a good price point should be researched
-- Potentially focusing on a couple of languages is better than a vast number of supported languages for the app
-- App genres in sectors like finance or books should be considered as there might be less saturation
-- Having a longer and, potentially, more detailed description would be better for app rating

//Furthering this project//

-- Graphing the metrics can reveal more insights on each of these factors as well as outliers
-- More in-depth research needs to be done of each of the factors that were identified from this surface level analysis
-- The groups and ranges used can be narrowed down to produced further insight on the correlations between the factors and app rating


   
