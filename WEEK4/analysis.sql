-- 1. Data quality checks
SELECT COUNT(*) AS row_count FROM business_data;

SELECT
    COUNT(*) FILTER (WHERE "Discount Band" IS NULL) AS missing_discount_band,
    COUNT(*) FILTER (WHERE "Date" IS NULL) AS missing_dates
FROM business_data;

-- 2. Overall KPIs
SELECT
    SUM("Units Sold") AS units_sold,
    SUM("Gross Sales") AS gross_sales,
    SUM("Discounts") AS discounts,
    SUM("Sales") AS sales,
    SUM("COGS") AS cogs,
    SUM("Profit") AS profit,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0), 2) AS profit_margin_pct
FROM business_data;

-- 3. Segment performance
SELECT
    "Segment",
    SUM("Sales") AS sales,
    SUM("Profit") AS profit,
    SUM("Units Sold") AS units_sold,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0),2) AS margin_pct
FROM business_data
GROUP BY "Segment"
ORDER BY sales DESC;

-- 4. Country performance
SELECT
    "Country",
    SUM("Sales") AS sales,
    SUM("Profit") AS profit,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0),2) AS margin_pct
FROM business_data
GROUP BY "Country"
ORDER BY sales DESC;

-- 5. Product performance
SELECT
    "Product",
    SUM("Sales") AS sales,
    SUM("Profit") AS profit,
    SUM("Units Sold") AS units_sold,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0),2) AS margin_pct
FROM business_data
GROUP BY "Product"
ORDER BY sales DESC;

-- 6. Discount band impact
SELECT
    COALESCE("Discount Band",'Unknown') AS discount_band,
    SUM("Sales") AS sales,
    SUM("Discounts") AS discounts,
    SUM("Profit") AS profit,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0),2) AS margin_pct
FROM business_data
GROUP BY COALESCE("Discount Band",'Unknown')
ORDER BY sales DESC;

-- 7. Monthly trend
SELECT
    "Year",
    "Month Number",
    "Month Name",
    SUM("Sales") AS sales,
    SUM("Profit") AS profit,
    ROUND(100.0 * SUM("Profit") / NULLIF(SUM("Sales"),0),2) AS margin_pct
FROM business_data
GROUP BY "Year","Month Number","Month Name"
ORDER BY "Year","Month Number";

-- 8. Loss-making records
SELECT *
FROM business_data
WHERE "Profit" < 0
ORDER BY "Profit" ASC;
