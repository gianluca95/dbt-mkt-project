{{ config(materialized='incremental', unique_key='campaign_id_date') }}

SELECT
    campaign_id,
    date::DATE AS date,
    conversions::INT AS conversions,
    CONCAT(campaign_id, '_', date) AS campaign_id_date
FROM {{ source('raw', 'raw_conversions') }}

{% if is_incremental() %}
  WHERE date > (SELECT MAX(date) FROM {{ this }})
{% endif %}
