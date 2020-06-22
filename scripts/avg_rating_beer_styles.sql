/* Tableau visualization: https://public.tableau.com/views/Averageratingofmostpopularbeerstyles/Dashboard1?:language=en&:display_count=y&:origin=viz_share_link */

WITH times2 AS                                    
      (SELECT time_id, YEAR, MONTH 
      FROM times)
SELECT DISTINCT beer_style as "Beer Style", time_id AS "Full Date",
         avg(review_overall) OVER (PARTITION BY beer_style, "month", "year") as "Average Rate"
FROM (SELECT t2.time_id, t2.YEAR, t2.MONTH, b2.beer_style, r2.review_overall, 
        count(beer_style) OVER (PARTITION BY beer_style, "month", "year") AS count_rev
      FROM times2 t2
      RIGHT JOIN (SELECT beer_id, review_date, review_overall
                  FROM reviews) AS r2
      ON t2.time_id = r2.review_date
      INNER JOIN (SELECT beer_id, beer_style
                  FROM beers) AS b2
      ON r2.beer_id = b2.beer_id
      WHERE YEAR BETWEEN 2003 AND 2011) AS slc
WHERE count_rev >= 10
ORDER BY "Full Date", "Average Rate" DESC;