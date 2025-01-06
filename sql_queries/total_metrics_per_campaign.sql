SELECT
    dc.campaign_name,
    SUM(fcp.spend) AS total_spend,
    SUM(fcp.conversions) AS total_conversions
FROM dim_campaigns dc
JOIN fct_campaign_performance fcp
  ON dc.campaign_id = fcp.campaign_id
WHERE fcp.date BETWEEN '2023-09-01' AND '2023-09-30'
GROUP BY dc.campaign_name
ORDER BY dc.campaign_name;
