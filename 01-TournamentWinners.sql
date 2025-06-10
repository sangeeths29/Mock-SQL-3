-- Problem 1 - Tournament Winners (https://leetcode.com/problems/tournament-winners/description/)
-- Step 1 - Grouping Players From first_player and second_player columns in Matches
WITH groupedplayers AS(
    SELECT first_player AS 'player_id', first_score AS 'score'
    FROM Matches
    UNION ALL
    SELECT second_player AS 'player_id', second_score AS 'score'
    FROM Matches
),
-- Step 2 - Computing total scores of each player
sumscores AS(
SELECT player_id, SUM(score) AS 'total_score'
FROM groupedplayers
GROUP BY player_id
),
-- Step 3 - Ranking Players Based on Score Using DENSE_RANK()
rankedplayers AS(
    SELECT p.group_id AS 'group_id', s.player_id AS 'player_id', DENSE_RANK() OVER(PARTITION BY  p.group_id ORDER BY s.total_score DESC, s.player_id) AS 'rnk'
FROM Players p
INNER JOIN sumscores s
ON p.player_id = s.player_id
GROUP BY p.player_id, p.group_id
)
-- Step 4 - Selecting the top player in each group based on score
SELECT r.group_id, r.player_id
FROM rankedplayers r
WHERE rnk = 1;
