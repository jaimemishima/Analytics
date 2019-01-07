CREATE OR REPLACE MODEL bqml_tutorial.modelo_1
OPTIONS (model_type='logistic_reg', input_label_cols=['target'], l1_reg=0.1) AS
#standardSQL
SELECT
    date,
    trafficSource.source AS source,
    trafficSource.source AS medium,
    fullVisitorId,
    channelGrouping,
    SUM(totals.pageviews) AS pageviews,
    #SUM(totals.transactions) AS transactions,
    SUM(totals.timeOnSite) AS SUM_totals_timeOnSite,
    #totals.totalTransactionRevenue AS receita,
    device.deviceCategory AS device,
    geoNetwork.country AS pais,
    CASE WHEN SUM(totals.transactions) > 0 THEN "1"
    ELSE "0"
    END AS target
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*` #, UNNEST(hits) AS hits
WHERE 
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170601'
GROUP BY
    date,
    source,
    medium,
    fullVisitorId,
    channelGrouping,
    #receita,
    device,
    pais
#HAVING target = "1"
