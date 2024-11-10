USE Assignment
SELECT * FROM USER_GAMEPLAY_DATA
SELECT * FROM DEPOSITE
SELECT * FROM WITHDRAWAL


	--"Part A - Calculating loyalty points
	--On each day, there are 2 slots for each of which the loyalty points are to be calculated:
	--S1 from 12am to 12pm 
	--S2 from 12pm to 12am"
	--"Based on the above information and the data provided answer the following questions:
	--1. Find Playerwise Loyalty points earned by Players in the following slots:-
--a. 2nd October Slot S1
--b. 16th October Slot S2
--C. 18th October Slot S1
--D. 26th October Slot S2
---2. Calculate overall loyalty points earned and rank players on the basis of loyalty points in the month of October. 
-- case of tie, number of games played should be taken as the next criteria for ranking.

--3. What is the average deposit amount?
--4. What is the average deposit amount per user in a month?
--5. What is the average number of games played per user?"

------------
--Q1.Find Playerwise Loyalty points earned by Players in the following slots:-



--Q1.(A)2nd October Slot S1

SELECT
    d.User_Id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) 
	AS deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id  
and W.Datetime BETWEEN '2022-10-02 00:00:00' AND 
'2022-10-02 11:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id 
AND G.Datetime BETWEEN '2022-10-02 00:00:00' AND 
'2022-10-02 11:59:59'
WHERE D.Datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 11:59:59'
GROUP BY d.User_Id
order by d.user_id

----------------------------
--Q1.(B) 16th October Slot S2

SELECT 
    d.User_Id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) AS 
	deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id 
AND W.Datetime BETWEEN '2022-10-16 12:00:00' AND 
'2022-10-16 23:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id 
AND G.Datetime BETWEEN '2022-10-16 12:00:00' AND 
'2022-10-16 23:59:59'
WHERE D.Datetime BETWEEN '2022-10-16 12:00:00' AND
'2022-10-16 23:59:59'
GROUP BY d.User_Id
order by d.user_id

--------------------------------------

--Q1.(C) 18th October Slot S1

SELECT
    d.User_Id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) AS
	deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id   and 
W.Datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 11:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id AND 
G.Datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 11:59:59'
WHERE D.Datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 11:59:59'
GROUP BY d.User_Id
order by d.user_id

---------------------------------

--Q1.(D) 26th October Slot S2

SELECT 
    d.User_Id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) AS 
	deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id   and 
W.Datetime BETWEEN '2022-10-26 00:00:00' AND '2022-10-26 11:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id AND 
G.Datetime BETWEEN '2022-10-26 00:00:00' AND '2022-10-26 11:59:59'
WHERE D.Datetime BETWEEN '2022-10-26 00:00:00' AND '2022-10-26 11:59:59'
GROUP BY d.User_Id
order by d.user_id


------------------

--Q2.Calculate overall loyalty points earned and rank players on the basis of loyalty points in the month of 
--October. case of tie, number of games played should be taken as the next criteria for ranking.

With Player_Points AS (
SELECT 
    d.User_Id AS User_id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) AS
	deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points,
	COALESCE(SUM(G.Games_Played),0) as total_games_played
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id   and
W.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id AND
G.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
WHERE D.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
GROUP BY d.User_Id
)
SELECT User_id, total_loyalty_points,total_games_played,
Rank() Over (Order By  total_loyalty_points,total_games_played) as Ranking
From Player_Points


--Q3.What is the average deposit amount?

Select Avg(Amount) as Avg_Deposite_Amount from DEPOSITE


--Q4. What is the average deposit amount per user in a month?

With Avg_deposite As (
Select USER_ID, sum(Amount) as total_Deposite_Amount from DEPOSITE
Where Datetime Between '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
Group By User_Id
)
Select avg( total_Deposite_Amount) As Avg_Deposite_Amount From Avg_deposite


--5. What is the average number of games played per user?"

With Avg_Games_Played as (
Select User_id ,Sum(Games_Played) As Total_games_played From USER_GAMEPLAY_DATA
Group By User_ID
)
Select avg(Total_games_played) As No_Avg_games From Avg_Games_Played



--"Part B - How much bonus should be allocated to leaderboard players?

--After calculating the loyalty points for the whole month find out which 50 players are at 
--the top of the leaderboard. 
--The company has allocated a pool of Rs 50000 to be given away as bonus money to the loyal players.
--Now the company needs to determine how much bonus money should be given to the players.
--Should they base it on the amount of loyalty points? Should it be based on number of games? 
--Or something else?
--That’s for you to figure out.

--Suggest a suitable way to divide the allocated money keeping in mind the following points:
--1. Only top 50 ranked players are awarded bonus

WITH Ranking As (
SELECT Top 50
    d.User_Id AS User_id,
    SUM(0.01 * d.amount) AS deposit_points,
    SUM(0.005 * w.amount) AS withdrawal_points,
    0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) AS 
	deposit_withdrawal_diff_points,
    0.2 * COALESCE(SUM(g.Games_Played), 0) AS games_played_points,
    (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) AS total_loyalty_points,
	 Rank() Over (Order By (SUM(0.01 * d.amount) + 
     SUM(0.005 * w.amount) + 
     0.001 * GREATEST(COUNT(d.amount) - COUNT(w.amount), 0) + 
     0.2 * COALESCE(SUM(g.Games_Played), 0)) Desc) As Rnk
FROM DEPOSITE d
LEFT JOIN WITHDRAWAL w ON d.User_Id = w.User_Id 
and W.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
LEFT JOIN USER_GAMEPLAY_DATA g ON d.User_Id = g.User_Id 
AND G.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
WHERE D.Datetime BETWEEN '2022-10-01 00:00:00' AND '2022-10-31 23:59:59'
GROUP BY d.User_Id
)
Select User_id, COALESCE(Total_loyalty_points,0) As Total_loyalty_points,
COALESCE((Total_loyalty_points/sum(Total_loyalty_points) Over ()) *50000,0) 
As Bonus From Ranking
Order By Bonus Desc




--Part C
--Would you say the loyalty point formula is fair or unfair?
--Can you suggest any way to make the loyalty point formula more robust?


--The formula is fair for encouraging deposits, withdrawals and game participation.
--The formula is unfair for the user who deposite or withrawal more amount 
--and spending more time on the platform

--Suggestions to Make the Loyalty Point Formula More Robust:
--Bronze: Users who deposit or withdraw a small amount and play a few games.
--Silver: Users who deposit/withdraw in moderate amounts and play a moderate number of games.
--Gold: Users who deposit/withdraw large amounts and are highly active in the games.