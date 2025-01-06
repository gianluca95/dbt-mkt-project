
    
    

with child as (
    select campaign_id as from_field
    from "testdb"."public"."fct_campaign_performance"
    where campaign_id is not null
),

parent as (
    select campaign_id as to_field
    from "testdb"."public"."dim_campaigns"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


