{{ config(materialized='view') }}

SELECT
    campaign_id,
    LOWER(campaign_name) AS campaign_name,
    LOWER(channel) AS channel
FROM {{ source('raw', 'raw_campaigns') }}
