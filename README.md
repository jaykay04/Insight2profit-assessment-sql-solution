# Insight2Profit – SQL Case Study (PostgreSQL Implementation)

## Overview

This project implements the Insight2Profit assessment case study using PostgreSQL.

The solution follows a structured 3-layer data architecture:

- **raw schema** → Landing layer (no transformations)
- **store schema** → Typed relational layer (Enforce Data Types PKs & FKs constrainta)
- **publish schema** → Business-transformed analytics layer

---

## Architecture Design

### 1️⃣ Raw Layer
- Direct ingestion of CSV files
- No transformation
- All columns stored as TEXT
- Preserves source system integrity

### 2️⃣ Store Layer
- Explicit data typing (INT, DATE, NUMERIC)
- Primary keys enforced
- Foreign key relationships enforced
- Ensures relational integrity

### 3️⃣ Publish Layer
- Business logic transformations applied
- Derived metrics calculated
- Analytics-ready tables

---

## Key Transformations

### Product Transformations
- Replaced NULL values in `Color` with `'N/A'`
- Derived `ProductCategoryName` using conditional logic:
  - Clothing
  - Accessories
  - Components
  - Defaulted to 'Others' if no rule matched

---

### Sales Order Transformations

#### Revenue Calculation
```sql
TotalLineExtendedPrice = OrderQty * (UnitPrice - UnitPriceDiscount)
```

#### Business Days Calculation
Used PostgreSQL `generate_series()` to calculate business days:

- Excluded Saturdays (6) and Sundays (0)
- Subtracted 1 to avoid counting the start date

---

## Analysis and Result

### 1️⃣ Highest Revenue Color Per Year
The analysis showed that Red had the highest revenue in 2021, then Black in 2022 and 2023, while Yellow had the highest revenue in 2024
- Used `RANK()` window function
- Partitioned by year
- Ordered by total revenue descending

![Yearly Color Revenue](docs/Highest Color Revenue each year.png)

### 2️⃣ Average Lead Time by Product Category
- Aggregated `LeadTimeInBusinessDays`
- Grouped by `ProductCategoryName`

---

## Assumptions

1. Revenue is defined as:
   ```sql
   OrderQty * (UnitPrice - UnitPriceDiscount)
   ```
2. Business days exclude Saturdays and Sundays only.

3. If `ProductCategoryName` remains NULL after applying rules, it defaults to `'Others'`.

4. Raw layer remains immutable and unchanged after ingestion.

---

## Data Quality Checks and Validation
Before applying transformations, I performed structured data quality checks to ensure reliability and integrity of the dataset.

### 1️⃣ Row Count Validation
- Verified record counts after ingestion into the `raw` schema.
- Compared row counts between `raw` and `store` layers to ensure no unintended data loss during type casting.

### 2️⃣ Null Value Analysis
Checked for unexpected NULL values across key fields.
- Ensured primary key fields were non-null before applying constraints.
- Identified nullable business fields (e.g., Color, ProductCategoryName) and handled them appropriately in the publish layer.

### 3️⃣ Duplicate Handling – Product Table
Identified duplicate ProductId records in the raw dataset.
To ensure data consistency:
- Retained the record containing the most complete (non-null) information.
- Removed less complete duplicate records before loading into the store layer.

Approach:
- Used a window function to rank records by completeness.
- Kept the top-ranked record per ProductId.

This ensures:
1. Highest data completeness is preserved.
2. Downstream referential integrity is maintained.
3. No arbitrary deletion of data.

### 4️⃣ Referential Integrity Validation
- Verified that all `SalesOrderDetail.ProductId` values exist in Product.
- Verified that all `SalesOrderDetail.SalesOrderId` values exist in SalesOrderHeader.
- Foreign key constraints were then enforced in the store schema.
