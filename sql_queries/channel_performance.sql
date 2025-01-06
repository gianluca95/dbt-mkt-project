-- We can use a subquery or a join to bring in the channel from dim_campaigns. 
-- Compute ROAS by summing (conversions * 100) over sum of spend.
SELECT
    dc.channel,
    CASE WHEN SUM(fcp.spend) = 0 THEN 0
         ELSE (SUM(fcp.conversions) * 100)::DECIMAL / SUM(fcp.spend)
    END AS channel_roas
FROM dim_campaigns dc
JOIN fct_campaign_performance fcp
  ON dc.campaign_id = fcp.campaign_id
GROUP BY dc.channel
ORDER BY channel_roas DESC
LIMIT 1;
