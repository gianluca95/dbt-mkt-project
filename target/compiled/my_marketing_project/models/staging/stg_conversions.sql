

SELECT
    campaign_id,
    date::DATE AS date,
    conversions::INT AS conversions,
    CONCAT(campaign_id, '_', date) AS campaign_id_date
FROM "testdb"."public"."raw_conversions"


  WHERE date > (SELECT MAX(date) FROM "testdb"."public"."stg_conversions")
