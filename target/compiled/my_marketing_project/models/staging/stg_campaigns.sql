

SELECT
    campaign_id,
    LOWER(campaign_name) AS campaign_name,
    LOWER(channel) AS channel
FROM "testdb"."public"."raw_campaigns"