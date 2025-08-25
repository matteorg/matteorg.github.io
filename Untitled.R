# Load the tidyverse library for data manipulation. If you don't have it, install it with install.packages("tidyverse").
# library(tidyverse)

# --- Create a fake dataset for checkout analysis ---

# Set a seed for reproducibility so you get the same random data each time.
set.seed(42)

# --- Scenario 1: Customers who made a second checkout within 30 days ---
# These are the customers the SQL query is designed to find.
customers_fast_return <- data.frame(
  customer_id = rep(c(101, 102), each = 2),
  date_of_checkout = as.Date(c(
    "2023-01-01", "2023-01-15",  # 15 days apart
    "2023-02-05", "2023-02-28"   # 23 days apart
  ))
)

# --- Scenario 2: Customers who made a second checkout after 30 days ---
# These customers should be filtered out by the SQL query.
customers_slow_return <- data.frame(
  customer_id = rep(c(103, 104), each = 2),
  date_of_checkout = as.Date(c(
    "2023-03-10", "2023-04-15",  # 36 days apart
    "2023-05-01", "2023-06-05"   # 35 days apart
  ))
)

# --- Scenario 3: Customers with only a single checkout ---
# These customers will also be filtered out by the SQL query.
customers_single_checkout <- data.frame(
  customer_id = c(105, 106, 107),
  date_of_checkout = as.Date(c("2023-07-01", "2023-08-10", "2023-09-20"))
)

# --- Scenario 4: Customer with multiple checkouts, including one within 30 days ---
# This customer should be found by the SQL query based on their first two checkouts.
customer_multiple_checkouts <- data.frame(
  customer_id = rep(108, 3),
  date_of_checkout = as.Date(c(
    "2023-10-01",  # First checkout
    "2023-10-20",  # Second checkout (within 30 days)
    "2023-12-01"   # Third checkout
  ))
)

# --- Combine all dataframes into a single 'fact_checkout' table ---
fact_checkout <- rbind(
  customers_fast_return,
  customers_slow_return,
  customers_single_checkout,
  customer_multiple_checkouts
)

# Sort the final dataframe by customer_id and then date_of_checkout
# This isn't strictly necessary for the SQL query, but it makes the data easier to read.
fact_checkout <- fact_checkout[order(fact_checkout$customer_id, fact_checkout$date_of_checkout), ]

library(DBI)
library(RSQLite)

# Step 1: Create a connection to a temporary, in-memory SQLite database.
con <- dbConnect(RSQLite::SQLite(), ":memory:")

# Step 2: Write the 'fact_checkout' data frame to a table in the database.
# The table will be named "fact_checkout" to match the SQL query.
dbWriteTable(con, "fact_checkout", fact_checkout)

sql_query <- "
  WITH RankedCheckouts AS (
      SELECT
          customer_id,
          date_of_checkout,
          ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY date_of_checkout) AS checkout_rank
      FROM
          fact_checkout
  ),
  FirstAndSecondCheckouts AS (
      SELECT
          customer_id,
          MAX(CASE WHEN checkout_rank = 1 THEN date_of_checkout ELSE NULL END) AS first_checkout_date,
          MAX(CASE WHEN checkout_rank = 2 THEN date_of_checkout ELSE NULL END) AS second_checkout_date
      FROM
          RankedCheckouts
      GROUP BY
          customer_id
  )
  SELECT
      customer_id,
      first_checkout_date
  FROM
      FirstAndSecondCheckouts
  WHERE
      second_checkout_date IS NOT NULL AND
      JULIANDAY(second_checkout_date) - JULIANDAY(first_checkout_date) <= 30;
"

# Step 4: Run the SQL query and store the results in an R data frame.
customer_list <- dbGetQuery(con, sql_query)

# Step 5: Print the resulting data frame to see the customers who meet the criteria.
print(customer_list)
