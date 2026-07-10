# Loading packages-----

library(tidyverse)
library(here)
library(janitor)
library(skimr)
library(readxl)
library(stringr)


# Reading in data-----

customerData <- read_csv(here("data", "QVI_purchase_behaviour.csv"))

transactionData <- read_excel(here("data", "QVI_transaction_data.xlsx"))


# Exploring the data-----
glimpse(customerData)
head(customerData)

glimpse(transactionData)
head(transactionData)
skim(transactionData)

n_distinct(transactionData$PROD_NAME)


# Data cleaning: Transaction Data-----

cleanTransaction <- transactionData %>%
  filter(!grepl("dip",PROD_NAME, ignore.case = TRUE)) %>%
  filter(!grepl("cheese",PROD_NAME, ignore.case = TRUE)) %>%
  filter(!(PROD_NAME %in% c("Woolworths Mild Salsa 300g", "Woolworths Medium Salsa 300g"))) %>%
  mutate(DATE = as.Date(DATE, origin = "1899-12-30")) %>%
  clean_names() %>%
  separate(prod_name, into = c("Brand", "Description"), sep = " ", extra = "merge") %>%
  mutate(pack_size = str_extract(Description, "[0-9]+g"))
###lower case headings, removing non-chips products, extracting brand name from product name, extracting pack sizes
  
n_distinct(cleanTransaction$Brand)

cleanTransaction %>%
  count(Brand, sort = TRUE) %>%
  print(n = 27)
###seeing if the brand names are unique and the number of transactions they are involved in

cleanTransaction %>%
  filter(grepl("^Dorito", Brand, ignore.case = TRUE)) %>%
  group_by(Description, tot_sales, prod_qty) %>%
  distinct(Brand)
###Dorito and Doritos mean the same thing

cleanTransaction <- cleanTransaction %>%
  mutate(Brand = str_replace(Brand, "^Dorito$", "Doritos"))
###replacing Dorito with Doritos

cleanTransaction %>%
  filter(grepl("^Dorito", Brand, ignore.case = TRUE)) %>%
  distinct(Brand)


# Data cleaning: Customer Data-----

cleanCustomer <- customerData %>%
  clean_names()


# Merging the two Data-----

mergedData <- cleanTransaction %>%
  left_join(cleanCustomer, by = "lylty_card_nbr")

cleanTransaction %>%
  filter(!(lylty_card_nbr %in% cleanCustomer$lylty_card_nbr))

sum(is.na(mergedData$premium_customer))

dim(mergedData)

head(mergedData)


# Data Analysis and findings-----

library(ggbeeswarm)
library(RColorBrewer)
library(ggtext)
library(magick)
library(beepr)
###loading packages for plotting charts

theme_set(theme_classic())
###Set our favorite plot theme

mergedData %>%
  filter(Brand == "Doritos" & tot_sales > 100)

mergedData %>%
  filter(lylty_card_nbr == 226000)

mergedData <- mergedData %>%
  filter(lylty_card_nbr != 226000)
###removing outliers that will skew the data

summary(mergedData)

cleanTransaction %>%
  count(Brand, sort = TRUE) %>%
  print(n = 26)

mergedData %>%
  group_by(Brand) %>%
  summarise(minsales = min(tot_sales, na.rm = TRUE),
            maxsales = max(tot_sales, na.rm = TRUE),
            meansales = mean(tot_sales, na.rm = TRUE)) %>%
  arrange(-meansales) 
###showing the average, minimum and maximum revenue gotten from sales of each of the brands

BrandByYear <- mergedData %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(month) %>%
  summarise(total_sales = sum(tot_sales, na.rm = TRUE),
            avg_sales = mean(tot_sales, na.rm = TRUE),
            transaction_count = n())
###extracting data to plot a chart

display.brewer.all()


ggplot(BrandByYear, aes(x = month, y = avg_sales)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "blue") +
  labs(title = "Average Customer Spend Over Time",
       x = "Month",
       y = "Average Sales ($)") +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
###Average Customer Spend Over Time


CustomerSpending <- mergedData %>%
  mutate(month = floor_date(date, "month")) %>%
  group_by(month, premium_customer) %>%
  summarise(avg_sales = mean(tot_sales, na.rm = TRUE))
###extracting data to plot similar chart


ggplot(CustomerSpending, aes(x = month, y = avg_sales, color = premium_customer)) +
  geom_line(size = 1) +
  geom_point() +
  labs(title = "Average Spend by Customer Segment",
       x = "Month",
       y = "Average Sales ($)",
       color = "Customer Type") +
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
###the average spend by each customer segment over time, compared side by side




mergedData %>%
  count(date)

allDates <- data.frame(DATE = seq(as.Date("2018-07-01"), as.Date("2019-06-30"), by = "day")) %>%
  clean_names()

transactionsByDate <- mergedData %>%
  count(date)

transactionsByDate <- allDates %>%
  left_join(transactionsByDate, by = "date")

transactionsByDate <- transactionsByDate %>%
  mutate(n = ifelse(is.na(n), 0, n))

transactionsByDate %>%
  filter(n == 0)

mergedData %>%
  count(date)

mergedData <- transactionsByDate %>%
  left_join(mergedData, by = "date")

mergedData %>%
  filter(date == 2018-12-25)


#### Plot transactions over time
ggplot(transactionsByDate, aes(x = date, y = n)) +
  geom_line() +
  labs(x = "Day", y = "Number of transactions", title = "Transactions over time") +
  scale_x_date(breaks = "1 month") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))

ggsave(here("visuals", "Transactions over time.png"))

# Filter to December 2018
decemberData <- transactionsByDate %>%
  filter(date >= as.Date("2018-12-01") & date <= as.Date("2018-12-31"))

# Plot zoomed in
ggplot(decemberData, aes(x = date, y = n)) +
  geom_line(color = "steelblue") +
  geom_point(color = "steelblue") +
  labs(title = "Number of Transactions in /n December 2018",
       x = "Date",
       y = "Number of Transactions") +
  scale_x_date(date_breaks = "1 day", date_labels = "%d %b") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

mergedData %>%
  group_by(Brand) %>%
  summarise(
    total_transactions = n(),
    total_revenue = sum(tot_sales, na.rm = TRUE)
  ) %>%
  arrange(desc(total_transactions)) %>%
  head(10) 


  

mergedData <- mergedData %>%
  mutate(pack_type = ifelse(prod_qty == 1, "Single Pack", "Multi Pack"))
  
mergedData %>%
  group_by(PACK_TYPE) %>%
  summarise(
    total_transactions = n(),
    unique_customers = n_distinct(LYLTY_CARD_NBR),
    avg_spend = mean(TOT_SALES, na.rm = TRUE)
  )

mergedData %>%
  count(PACK_TYPE) %>%
  ggplot(aes(x = PACK_TYPE, y = n, fill = PACK_TYPE)) +
  geom_bar(stat = "identity") +
  labs(title = "Single Pack vs Multi Pack Purchases",
       x = "Pack Type",
       y = "Number of Transactions") +
  theme_bw()


mergedData %>%
  group_by(PREMIUM_CUSTOMER, PACK_TYPE) %>%
  summarise(total_transactions = n()) %>%
  ggplot(aes(x = PREMIUM_CUSTOMER, y = total_transactions, fill = PACK_TYPE)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Pack Type Preference by Customer Segment",
       x = "Customer Segment",
       y = "Number of Transactions",
       fill = "Pack Type") +
  theme_bw()
  
  
  
# Data Visualizations-----


## Setting plot theme

theme_set(theme_classic())

## write_csv()
## ggsave("sales_by_category.png", width = 8, height = 5)
