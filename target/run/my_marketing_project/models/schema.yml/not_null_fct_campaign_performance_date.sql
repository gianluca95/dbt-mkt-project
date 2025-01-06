select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select date
from "testdb"."public"."fct_campaign_performance"
where date is null



      
    ) dbt_internal_test