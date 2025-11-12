# 🎬 Netflix Movies & TV Shows Data Analysis (SQL Server)

## 📌 Overview
This project focuses on analyzing **Netflix’s Movies and TV Shows dataset** using **SQL Server** to uncover valuable business insights.  
It answers 15 real-world business questions related to content types, genres, ratings, release years, and country-wise trends.  

The goal is to demonstrate advanced **SQL querying, data cleaning, and analytical thinking** — essential skills for a **Data Analyst** role.

---

## 🎯 Objectives
- Analyze the distribution between **Movies and TV Shows**.
- Identify **most frequent ratings** and **popular genres**.
- Explore **country-wise** and **year-wise** release patterns.
- Find **top actors, directors**, and **regional trends**.
- Derive **data-driven insights** using SQL.

---

## 🧩 Dataset
- **Source:** [Netflix Movies and TV Shows - Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- **Total Records:** 8,800+
- **Attributes:** show_id, type, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description

---

## 🗄️ Database Schema
```sql
CREATE TABLE netflix (
    show_id        VARCHAR(10),
    type           VARCHAR(20),
    title          NVARCHAR(255),
    director       NVARCHAR(500),
    cast           NVARCHAR(MAX),
    country        NVARCHAR(500),
    date_added     NVARCHAR(100),
    release_year   INT,
    rating         NVARCHAR(50),
    duration       NVARCHAR(50),
    listed_in      NVARCHAR(255),
    description    NVARCHAR(MAX)
);
