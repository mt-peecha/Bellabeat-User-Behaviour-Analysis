/*=======================================================
Bellabeat_Project — Daily Activity (Fitbit) — Analysis Script
 Dataset: dailyActivity_merged.csv imported into dbo.daily_activity
 Author: MT Peecha
 =========================================================*/

/*=======================================================
1. Merge Daily_Activity Table with Sleepday table, to create
a new table
=========================================================*/

DROP TABLE IF EXISTS dbo.daily_fact;

SELECT
    a.Id,
    CAST(a.ActivityDate AS date) AS ActivityDate,
    a.TotalSteps,
    a.Calories,
    a.VeryActiveMinutes,
    a.FairlyActiveMinutes,
    a.LightlyActiveMinutes,
    a.SedentaryMinutes,
    s.TotalMinutesAsleep,
    s.TotalTimeInBed,
    CASE WHEN s.TotalMinutesAsleep IS NULL THEN 0 ELSE 1 END AS sleep_logged_flag
INTO dbo.daily_fact
FROM dbo.daily_activity a
LEFT JOIN dbo.sleep_clean s
    ON a.Id = s.Id
   AND CAST(a.ActivityDate AS date) = s.SleepDate;


/*=======================================================
3.1 Engagement distribution (High/Medium/Low)
=========================================================*/
WITH user_days AS (
  SELECT
    Id,
    COUNT(*) AS tracked_days
  FROM dbo.daily_fact
  GROUP BY Id
),
engagement AS (
  SELECT
    Id,
    tracked_days,
    CASE
      WHEN tracked_days >= 28 THEN 'High (>=28 days)'
      WHEN tracked_days BETWEEN 15 AND 27 THEN 'Medium (15–27)'
      ELSE 'Low (<15)'
    END AS engagement_segment
  FROM user_days
)
SELECT
  engagement_segment,
  COUNT(*) AS users,
  CAST(100.0 * COUNT(*) / (SELECT COUNT(*) FROM engagement) AS decimal(5,2)) AS pct_users
FROM engagement
GROUP BY engagement_segment
ORDER BY users DESC;


/*=======================================================
3.2 Activity trends (Sedentary/Moderate/Active) + avg steps
=========================================================*/
SELECT
  CASE
    WHEN TotalSteps < 5000 THEN 'Sedentary'
    WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate'
    ELSE 'Active'
  END AS activity_segment,
  COUNT(*) AS days,
  AVG(CAST(TotalSteps AS float)) AS avg_steps
FROM dbo.daily_fact
GROUP BY
  CASE
    WHEN TotalSteps < 5000 THEN 'Sedentary'
    WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate'
    ELSE 'Active'
  END
ORDER BY avg_steps DESC;


/*=======================================================
3.3 Sleep logged rate (overall)
=========================================================*/
SELECT
  COUNT(*) AS total_days,
  SUM(sleep_logged_flag) AS sleep_logged_days,
  CAST(100.0 * SUM(sleep_logged_flag) / COUNT(*) AS decimal(5,2)) AS sleep_logged_pct
FROM dbo.daily_fact;


/*=======================================================
3.4 Sleep tracking rate by activity level
=========================================================*/
WITH seg AS (
  SELECT
    *,
    CASE
      WHEN TotalSteps < 5000 THEN 'Sedentary'
      WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate'
      ELSE 'Active'
    END AS activity_segment
  FROM dbo.daily_fact
)
SELECT
  activity_segment,
  COUNT(*) AS days,
  SUM(sleep_logged_flag) AS sleep_logged_days,
  CAST(100.0 * SUM(sleep_logged_flag) / COUNT(*) AS decimal(5,2)) AS sleep_logged_pct
FROM seg
GROUP BY activity_segment
ORDER BY sleep_logged_pct DESC;


/*=======================================================
3.5 Sleep duration patterns by activity segment
=========================================================*/
WITH seg AS (
  SELECT
    *,
    CASE
      WHEN TotalSteps < 5000 THEN 'Sedentary'
      WHEN TotalSteps BETWEEN 5000 AND 9999 THEN 'Moderate'
      ELSE 'Active'
    END AS activity_segment
  FROM dbo.daily_fact
)
SELECT
  activity_segment,
  AVG(CAST(TotalMinutesAsleep AS float)) / 60.0 AS avg_sleep_hours
FROM seg
WHERE TotalMinutesAsleep IS NOT NULL
GROUP BY activity_segment
ORDER BY avg_sleep_hours DESC;


/*=======================================================
3.6 Average steps by day of week (from the cleaned daily_fact)
=========================================================*/
SELECT
  DATENAME(WEEKDAY, ActivityDate) AS day_of_week,
  AVG(CAST(TotalSteps AS float)) AS avg_steps,
  COUNT(*) AS days
FROM dbo.daily_fact
GROUP BY DATENAME(WEEKDAY, ActivityDate)
ORDER BY avg_steps DESC;


/*=======================================================
3.7 Active minutes vs sedentary minutes
=========================================================*/
SELECT
  AVG(CAST(VeryActiveMinutes AS float))      AS avg_very_active_min,
  AVG(CAST(FairlyActiveMinutes AS float))    AS avg_fairly_active_min,
  AVG(CAST(LightlyActiveMinutes AS float))   AS avg_lightly_active_min,
  AVG(CAST(SedentaryMinutes AS float))       AS avg_sedentary_min
FROM dbo.daily_fact;


/*=======================================================
3.8 Sleep: average minutes asleep, in bed, and sleep efficiency

Sleep efficiency = minutes asleep / minutes in bed.
=========================================================*/
SELECT
  COUNT(*) AS rows_total,
  SUM(CASE WHEN sleep_logged_flag = 1 THEN 1 ELSE 0 END) AS rows_with_sleep,
  AVG(CASE WHEN sleep_logged_flag = 1 THEN CAST(TotalMinutesAsleep AS float) END) AS avg_minutes_asleep,
  AVG(CASE WHEN sleep_logged_flag = 1 THEN CAST(TotalTimeInBed AS float) END) AS avg_time_in_bed,
  AVG(
    CASE
      WHEN sleep_logged_flag = 1 AND TotalTimeInBed > 0
      THEN CAST(TotalMinutesAsleep AS float) / CAST(TotalTimeInBed AS float)
    END
  ) AS avg_sleep_efficiency
FROM dbo.daily_fact;


/*=======================================================
3.9 Relationship: step ranges vs avg calories 
=========================================================*/
SELECT
  CASE
    WHEN TotalSteps < 2500 THEN '0–2.5k'
    WHEN TotalSteps BETWEEN 2500 AND 4999 THEN '2.5k–5k'
    WHEN TotalSteps BETWEEN 5000 AND 7499 THEN '5k–7.5k'
    WHEN TotalSteps BETWEEN 7500 AND 9999 THEN '7.5k–10k'
    ELSE '10k+'
  END AS step_range,
  COUNT(*) AS days,
  AVG(CAST(Calories AS float)) AS avg_calories,
  AVG(CAST(TotalSteps AS float)) AS avg_steps
FROM dbo.daily_fact
GROUP BY
  CASE
    WHEN TotalSteps < 2500 THEN '0–2.5k'
    WHEN TotalSteps BETWEEN 2500 AND 4999 THEN '2.5k–5k'
    WHEN TotalSteps BETWEEN 5000 AND 7499 THEN '5k–7.5k'
    WHEN TotalSteps BETWEEN 7500 AND 9999 THEN '7.5k–10k'
    ELSE '10k+'
  END
ORDER BY avg_steps;