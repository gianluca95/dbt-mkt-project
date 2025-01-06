

WITH ad_spend AS (
    SELECT
        campaign_id,
        date,
        spend
    FROM "testdb"."public"."stg_ad_spend"
),
conv AS (
    SELECT
        campaign_id,
        date,
        conversions
    FROM "testdb"."public"."stg_conversions"
)

SELECT
    ad_spend.campaign_id,
    ad_spend.date,
    ad_spend.spend,
    conv.conversions,
    CASE WHEN ad_spend.spend = 0 THEN 0 
         ELSE (conv.conversions::DECIMAL / ad_spend.spend) 
    END AS conversion_rate,
    CASE WHEN ad_spend.spend = 0 THEN 0
         ELSE ((conv.conversions * 100)::DECIMAL / ad_spend.spend)
    END AS roas
FROM ad_spend
JOIN conv
  ON ad_spend.campaign_id = conv.campaign_id
 AND ad_spend.date = conv.date