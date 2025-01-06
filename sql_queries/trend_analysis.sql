-- We want to compare the last two weeks 
-- (2023-09-16 to 2023-09-30) vs. the first two weeks (2023-09-01 to 2023-09-15).
WITH first_half AS (
  SELECT
    campaign_id,
    SUM(conversions) AS total_conversions_h1,
    SUM(spend) AS total_spend_h1
  FROM fct_campaign_performance
  WHERE date BETWEEN '2023-09-01' AND '2023-09-15'
  GROUP BY campaign_id
),
second_half AS (
  SELECT
    campaign_id,
    SUM(conversions) AS total_conversions_h2,
    SUM(spend) AS total_spend_h2
  FROM fct_campaign_performance
  WHERE date BETWEEN '2023-09-16' AND '2023-09-30'
  GROUP BY campaign_id
)

SELECT
    dc.campaign_name,
    first_half.total_conversions_h1,
    second_half.total_conversions_h2,
    (second_half.total_conversions_h2 - first_half.total_conversions_h1) AS delta_conversions,
    first_half.total_spend_h1,
    second_half.total_spend_h2,
    CASE WHEN first_half.total_spend_h1 = 0 THEN NULL
         ELSE (first_half.total_conversions_h1*100)::DECIMAL / first_half.total_spend_h1
    END AS roas_h1,
    CASE WHEN second_half.total_spend_h2 = 0 THEN NULL
         ELSE (second_half.total_conversions_h2*100)::DECIMAL / second_half.total_spend_h2
    END AS roas_h2
FROM dim_campaigns dc
JOIN first_half
  ON dc.campaign_id = first_half.campaign_id
JOIN second_half
  ON dc.campaign_id = second_half.campaign_id
WHERE (second_half.total_conversions_h2 < first_half.total_conversions_h1)
ORDER BY dc.campaign_name;
