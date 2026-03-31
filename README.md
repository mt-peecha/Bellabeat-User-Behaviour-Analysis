# Bellabeat User Behaviour Analysis

## Overview

This project analyzes smart device usage data to understand user behaviour patterns and identify opportunities to increase engagement and drive membership growth for Bellabeat.

The focus is on how users interact with activity and sleep tracking features, and how these behaviours can inform marketing strategy.

---

## Business Problem

Bellabeat aims to grow its subscription-based membership by increasing user engagement within its wellness ecosystem.

The objective is to identify gaps in user behaviour and recommend strategies to increase engagement depth, particularly in sleep and recovery tracking.

---

## Data Source

Dataset: Fitbit Fitness Tracker Data (Kaggle)

The dataset contains activity and sleep tracking data from 30+ users, including daily activity, steps, and sleep logs. :contentReference[oaicite:0]{index=0}

---

## Tools Used

- SQL — data cleaning, transformation, and analysis  
- Power BI — data modelling and dashboard creation  

---

## Data Description

- 33 users  
- ~940 daily activity records  
- 410 sleep records (~44% of tracked days) :contentReference[oaicite:1]{index=1}  

The dataset includes:
- Daily activity metrics  
- Sleep tracking data  
- User-level behaviour patterns  

---

## Analysis Approach

- Cleaned and explored raw data using SQL  
- Joined activity and sleep datasets at user-day level  
- Created behavioural segments:
  - Activity level (Sedentary, Moderate, Active)  
  - Engagement level (High, Medium, Low)  
- Calculated:
  - Sleep tracking rate  
  - Average sleep duration  
  - User engagement distribution  
- Built an interactive dashboard in Power BI  

---

## Key Insights

### 1. High Activity, Low Sleep Tracking
Users consistently track activity, but only ~44% of days include sleep tracking. :contentReference[oaicite:2]{index=2}  

Users are engaged, but not fully using the platform.

---

### 2. Engagement Drives Behaviour Depth
- High engagement users track both activity and sleep  
- Low engagement users rarely track sleep  

Engagement level directly affects feature usage.

---

### 3. Moderate Users Are the Biggest Opportunity
- Moderate users form the largest segment  
- They track activity regularly but lack consistent sleep tracking  

This group is already engaged but underutilising key features.

---

### 4. Activity vs Sleep Trade-Off
- Active users track sleep more often but sleep less  
- Sedentary users sleep longer but track inconsistently  

Behaviour reflects lifestyle differences, not just activity levels.

---

## Business Implications

- The issue is not user activity — it is depth of engagement  
- Increasing feature usage is more valuable than acquiring new users  
- Sleep tracking is the key gap in user behaviour  

---

## Recommendations

### 1. Position Membership as a Full Wellness Solution
Shift messaging from:
“Track your steps”  
→ to  
“Understand your full health: activity, sleep, and recovery”

---

### 2. Target Moderate Users
Focus on users who:
- Are already active  
- Show inconsistent behaviour  

Use:
- Personalised insights  
- Feature highlights  
- Behaviour-based nudges  

---

### 3. Introduce Behavioural Nudges
Encourage deeper engagement through:
- Sleep reminders  
- Streak tracking  
- Weekly summaries  
- Progress incentives  

---

## Business Impact

Improving sleep tracking consistency can:

- Increase engagement  
- Improve product value perception  
- Drive membership conversion  
- Improve retention  

---

## Limitations

- Small sample size (~33 users)  
- Short time period (~1 month)  
- No demographic or revenue data  
- Fitbit users may not fully represent Bellabeat users

---

## Project Structure

├── data/ # Raw dataset
├── analysis/ # SQL scripts
├── powerbi/ # Dashboard file
├── images/ # Dashboard screenshots
├── docs/ # Final report
└── README.md


---

## Dashboard Preview

<img width="1308" height="735" alt="BellaBeat Dashboard" src="https://github.com/user-attachments/assets/e948fc34-0852-4791-921f-7bc12f2edb71" />

---

## Conclusion

Users actively engage with activity tracking but fail to consistently track sleep, creating a gap in holistic wellness behaviour.

The growth opportunity lies in increasing engagement depth rather than increasing activity usage.
