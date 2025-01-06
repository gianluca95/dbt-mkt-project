{{ config(materialized='incremental', unique_key='campaign_id_date') }}

SELECT
    campaign_id,
    date::DATE AS date,
    spend::DECIMAL(10, 2) AS spend,
    CONCAT(campaign_id, '_', date) AS campaign_id_date
FROM {{ source('raw', 'raw_ad_spend') }}

-- This could be used to handle incremental loads:
{% if is_incremental() %}
  WHERE date > (SELECT MAX(date) FROM {{ this }})
{% endif %}
