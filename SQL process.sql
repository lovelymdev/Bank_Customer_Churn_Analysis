CREATE TABLE CHURN_MODELLING (
	CREDITSCORE INT,
	CREDIT_SCORE_RATING VARCHAR(30),
	GEOGRAPHY VARCHAR(50),
	GENDER VARCHAR(10), AGE_GROUP VARCHAR(30),
	TENURE INT,
	BALANCE NUMERIC(12, 2),
	BALANCE_GROUP VARCHAR(30),
	NUMOFPRODUCTS INT,
	HASCRCARD INT,
	ISACTIVEMEMBER INT,
	ESTIMATEDSALARY NUMERIC(12, 2),
	SALARY_GROUP VARCHAR(30),
	EXITED INT
);

SELECT * FROM churn_modelling;

COPY
churn_modelling(CreditScore, Credit_Score_Rating, Geography, Gender, Age_Group, Tenure, 
Balance, Balance_Group, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Salary_Group, Exited)
FROM 'E:\PROJECTS\Bank_Customer_Churn_Analysis\Churn_Modelling_Cleaned.csv'
DELIMITER','
CSV HEADER;

--1) Retrieve Total Customers
SELECT COUNT(*) AS Total_Customers
FROM churn_modelling;

--2) Retrieve the Total Customers Who Left Bank
SELECT COUNT(*) AS Churned_Customers
FROM churn_modelling
WHERE Exited = 1;

--3) Total Active Members
SELECT COUNT(*) AS Active_Members
FROM churn_modelling
WHERE IsActiveMember = 1;

--4) Retrieve the Average Credit Score
SELECT ROUND(AVG(CreditScore),2) AS Avg_CreditScore
FROM churn_modelling;

--5) Find the customers who are having excellent Credit Score Rating from "France"
SELECT DISTINCT Geography, Credit_score_rating AS Premium_CrScoreRating 
FROM churn_modelling
WHERE Geography='France';

--6) Find the Total Number of Customers from each Country
SELECT Geography,
COUNT(*) AS Total_Customers
FROM churn_modelling
GROUP BY Geography
ORDER BY Total_Customers DESC;

--7) Find the Overall churn Rate of all the Countries
SELECT
ROUND(AVG(Exited)*100,2) AS ChurnRate
FROM churn_modelling;

--8) Find out the Highest Churn Country from all 
SELECT Geography,
SUM (Exited) AS Churned_Customers
FROM churn_modelling
GROUP BY Geography
ORDER BY Churned_Customers;

--9) Find the Average Balance of Churn Customers
SELECT ROUND(AVG(Balance),2) AS Avg_balance
FROM churn_modelling
WHERE Exited=1
ORDER BY Avg_balance DESC;

--10) Find the Churn Rate of each Country
SELECT Geography, COUNT(*) AS Customers,
SUM(Exited) AS Churned,
ROUND(100.0*SUM(Exited)/COUNT(*),2) AS Churn_Rate
FROM churn_modelling
GROUP BY Geography
ORDER BY Churn_Rate DESC;

--11) Calculate the Churn by Age Group
SELECT Age_Group, COUNT(*) AS Customers,
SUM(Exited) AS Churned_by_Age
FROM Churn_modelling
GROUP BY Age_Group
ORDER BY Churned_by_Age DESC;

--12) Calculate the Churned by Credit Score Rating
SELECT Credit_score_Rating,
COUNT(*) AS Customers,
SUM(Exited) AS Churned_by_CrRating
FROM churn_modelling
GROUP BY Credit_score_Rating
ORDER BY Churned_by_CrRating DESC;

--13) Calculate the Average salary by Country
SELECT Geography,
ROUND(AVG(EstimatedSalary),2) AS Avg_Salary
FROM churn_modelling
GROUP BY Geography;

--14) Find Average Credit Score by Gender
SELECT Gender,
ROUND(AVG(Creditscore),2) AS Avg_CreditScore
FROM churn_modelling
GROUP BY Gender;

--15) Find Customer Risk Category
SELECT Geography, Age_group, CreditScore,
CASE
   WHEN CreditScore <500 THEN 'High Risk'
   WHEN CreditScore BETWEEN 500 AND 700 THEN 'Medium Risk'
   ELSE 'Low Risk'
END AS Risk_Level
FROM churn_modelling;

--16) Countries with more than 2000 customers
SELECT Geography,
COUNT(*) AS Customers
FROM churn_modelling
GROUP BY Geography
HAVING COUNT(*)>2000;

--17) Rank Countries by Churn
SELECT geography,
SUM(Exited) AS Churned,
RANK()OVER (ORDER BY SUM(Exited)DESC) AS Ranking
FROM churn_modelling
GROUP BY geography;

--18) Rank Customers by salary
SELECT estimatedsalary,
RANK() OVER (ORDER BY estimatedsalary DESC) AS Salary_Rank
FROM churn_modelling;

--19) Calculate Running Total of churned Customers
SELECT geography,
SUM(Exited) AS Churned,
SUM(SUM(Exited)) OVER (ORDER BY SUM(Exited)) AS Running_Total
FROM churn_modelling
GROUP BY geography;

--20) Loyalty Category
SELECT Tenure,
CASE
   WHEN Tenure<=2 THEN 'New Customer'
   WHEN Tenure<=5 THEN 'Regular Customer'
   ELSE 'Loyal Customer'
END AS Customer_Type
FROM churn_modelling;


