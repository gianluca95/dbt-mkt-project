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


