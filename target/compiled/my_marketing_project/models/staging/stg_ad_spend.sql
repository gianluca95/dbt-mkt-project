

SELECT
    campaign_id,
    date::DATE AS date,
    spend::DECIMAL(10, 2) AS spend,
    CONCAT(campaign_id, '_', date) AS campaign_id_date
FROM "testdb"."public"."raw_ad_spend"

-- This could be used to handle incremental loads:

  WHERE date > (SELECT MAX(date) FROM "testdb"."public"."stg_ad_spend")
