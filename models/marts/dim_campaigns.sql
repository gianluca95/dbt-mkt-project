{{ config(materialized='table') }}

SELECT
    sc.campaign_id,
    sc.campaign_name,
    sc.channel,
    CURRENT_TIMESTAMP AS created_at
FROM {{ ref('stg_campaigns') }} sc
