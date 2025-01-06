## Overview
This project demonstrates a digital marketing analytics workflow using:

1. PostgreSQL as the database for raw and transformed tables
2. dbt (Data Build Tool) for data modeling, transformations, and testing
3. PowerBI for data visualization

### 1. PostgreSQL Setup
#### 1.1 Installing PostgreSQL on Ubuntu
```
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

#### 1.2 Starting PostgreSQL and Creating a Database
Start the PostgreSQL service (if not already running):
```sudo service postgresql start```

Switch to the postgres user:
```sudo -i -u postgres```

Create a new database (e.g., testdb):
```createdb testdb```

### 2. Creating and Populating the Raw Tables
Below are the SQL statements that create and populate three raw tables:

- raw_campaigns
- raw_ad_spend
- raw_conversions

Note: Run these statements while connected to your testdb database. For instance:
```
psql -h localhost -U my_user -d testdb
-- Then run the statements below
```

#### 2.1 Table Creation
```
-- raw_campaigns
CREATE TABLE raw_campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50)
);

-- raw_ad_spend
CREATE TABLE raw_ad_spend (
    campaign_id INT,
    date DATE,
    spend DECIMAL(10, 2),
    CONSTRAINT fk_campaign
      FOREIGN KEY (campaign_id)
      REFERENCES raw_campaigns (campaign_id)
);

-- raw_conversions
CREATE TABLE raw_conversions (
    campaign_id INT,
    date DATE,
    conversions INT,
    CONSTRAINT fk_campaign_conv
      FOREIGN KEY (campaign_id)
      REFERENCES raw_campaigns (campaign_id)
);
```

#### 2.2 Data Insertion
```
-- Populate raw_campaigns
INSERT INTO raw_campaigns (campaign_id, campaign_name, channel)
VALUES
  (1, 'Brand Awareness - Google Ads', 'Google Ads'),
  (2, 'Product Launch - Facebook', 'Facebook Ads'),
  (3, 'Summer Sale - Instagram', 'Instagram'),
  (4, 'Retargeting - Facebook', 'Facebook Ads'),
  (5, 'Holiday Promo - Google Ads', 'Google Ads');

-- Populate daily data for raw_ad_spend
DO $$
DECLARE
    d DATE := '2023-09-01';
BEGIN
    WHILE d <= '2023-09-30' LOOP
        INSERT INTO raw_ad_spend (campaign_id, date, spend)
        VALUES
            (1, d, (random() * 50) + 50),
            (2, d, (random() * 30) + 20),
            (3, d, (random() * 20) + 10),
            (4, d, (random() * 30) + 20),
            (5, d, (random() * 50) + 50);
        d := d + 1;
    END LOOP;
END$$;

-- Populate daily data for raw_conversions
DO $$
DECLARE
    d DATE := '2023-09-01';
BEGIN
    WHILE d <= '2023-09-30' LOOP
        INSERT INTO raw_conversions (campaign_id, date, conversions)
        VALUES
            (1, d, floor(random() * 10) + 5),
            (2, d, floor(random() * 8)  + 2),
            (3, d, floor(random() * 5)  + 1),
            (4, d, floor(random() * 8)  + 2),
            (5, d, floor(random() * 10) + 5);
        d := d + 1;
    END LOOP;
END$$;
```

### 3. Running dbt
#### 3.1 Configure profiles.yml
Make sure you have a profiles.yml in ~/.dbt/profiles.yml that points to your PostgreSQL database. Example:
```
my_postgres_profile:
  target: dev
  outputs:
    dev:
      type: postgres
      host: '127.0.0.1'
      user: 'my_user'
      password: 'my_password'
      port: '5432'
      dbname: 'testdb'
      schema: 'public'
```

#### 3.2 dbt Commands
1. Navigate to your dbt project folder (e.g., cd ~/path/to/my_marketing_project).
2. Activate your virtual environment (optional, if you use one):
```source venv/bin/activate```
3. Run dbt:
```dbt run```
This will build or update your staging tables, dimension tables, and fact tables defined in your .sql models.
4. Run dbt tests:
```dbt test```
This will run the tests you defined in your schema.yml files (e.g., not_null, unique, relationships, etc.).

#### 3.3 Screenshots of dbt Tests
Here are some example screenshots of the successful tests:

![dbt-test-success](https://github.com/gianluca95/dbt-mkt-project/blob/main/images/dbt-test.png)

### 4. Analytical Queries
We included multiple analytical queries in the sql_queries folder (for example):

- total_metrics_per_campaign.sql
- channel_performance.sql
- trend_analysis.sql

You can run them via psql, any SQL client, or a BI tool connected to the same database.

### 5. Power BI Visualizations
We connected Power BI to our local Postgres database to create the following dashboards:

- Bar Chart: Total Spend vs. Total Conversions per Campaign
- Line Graph: Daily Spend & Conversions over time for top-performing campaign
- Overall Dashboard: Interactive filters for channel and date range

Screenshots of the Power BI dashboard:

PLACEHOLDER FOR UPLOADING SCREENSHOTS IF NECESSARY

### 6. Recommendations and Summary
#### Summary
- Google Ads (Brand Awareness, Holiday Promo) tend to have higher daily spend and conversions, leading to a strong ROAS.
- Facebook Ads campaigns have moderate spend but decent conversion rates, suggesting they’re efficient for budget usage.
- Instagram had smaller budgets and conversions but shows potential for targeted campaigns.

#### Recommendations
- Reallocate Budget: Shift some budget from lower-performing campaigns to top performers while monitoring diminishing returns.
- Optimize Underperforming Campaigns: For any campaigns with declining conversions, refresh creatives or adjust audience targeting.
- Test New Audiences: High-frequency or retargeting campaigns can suffer fatigue. Experiment with new audience segments or creative formats to sustain engagement.
- Monitor ROAS and Conversion Quality: Ensure that the increased conversions from higher spend translate into actual business value (e.g., sales, leads).

### 7. Next Steps
1. Extending the Analysis
- Implement advanced modeling in dbt (such as additional fact tables or calculated metrics).
- Set up continuous integration or scheduling for daily/weekly updates.
2. Enhancing Visualizations
- Drill-downs in Power BI by channel, date range, or creative type.
- Add custom KPI cards for quick overview of spend, conversions, ROAS.
3. Further Testing
- Create custom dbt tests to validate metric calculations (e.g., ensuring no negative spend, ensuring - date ranges are correct).
