# :purple_square: Quantium-Sales-Data  

Analysis on a retail chips transaction dataset and their customer data, to reveal customer purchasing trends and generate insights for the company.  

---

## :clipboard: Project Overview

This project is about understanding what type of customers are most interested in purchasing chips at a retail store, Quantium, and what kind of chips they prefer to buy. I analyzed both the transaction and customer data across different life stages to identify trends and inconsistencies in purchasing behavior of customers, identify what drives sales the most and observe the overall current sales performance. The goal is to help the Category manager for chips with data driven recommendations for the company’s next strategy to improve market performance.

---

## :interrobang: Problem Statement

The company lacks visibility into what the revenue trend looks like over the last year, making it difficult to know what factors to prioritize in order to improve sales. This project answers:
-	Whether customers are spending more or less. Is average sales trending upward or downward month by month? 
-	Are there seasonal influences to market performance?
-	Which customer segment drives the most growth?
-	Do customers prefer to buy chips in bulk or as single purchases?
-	Do they prefer larger sizes of chips?
-	Are customers buying more of budget friendly options?

---

## :hammer_and_wrench: Tools & Packages

This project was done in R studio, and the following packages were used.
-	tidyverse
-	here
-	janitor
-	skimr
-	readxl
-	stringr
-	ggplot2
-	RColorBrewer
-	ggtext
-	tinytex

---

## 🗂️ Project Structure

```
📁 Quantium-Sales-Data/
│
├── 📁 Data/
│   ├── QVI_purchase_behaviour.csv/        # Original customer data
│   ├── QVI_transaction_data.xlsx/         # Original transaction data
│   └── mergedData.csv                     # Merged and processed data
│
├── 📁 Scripts/
│   ├── Quantium_md.Rmd     # R markdown of the code used in this project
│   └── Quantium_md.pdf     # The markdown knitted to a pdf
│
└── README.md                              # You are here
```

---

## :microscope: Methodology

### Step 1: Data Collection  
The datasets were gotten from Quantium for this analysis. I read in the files by assigning them to a data frame in R studio.

### Step 2: Data Cleaning
-	Standardized column names of both files
-	Changed the character of the date from ‘integer’ to ‘date’
-	Removed non-chips products so that I am only analyzing chips data
-	Split the product name column to obtain brand names
-	Renamed misspelled brand names
-	Removed null rows

### Step 3: Exploratory Data Analysis (EDA)
-	Merged the separate data into one
-	Extracted brand sizes
-	Removed outliers (large commercial transactions made in single purchases.
-	Pulled December data alone to get a closer look at sales
-	Used the summarize function to get an overview of the data
-	Answered questions to the problem statement by manipulating data in many ways.


### Step 5: Visualization
Along with my analysis, I generated charts using ggplot2 to show and not just tell the different trends that I found. These charts are seen in the markdown file in the scripts folder.

---

## :bulb: Key Findings & Insights
-	:chart: **Revenue Growth**: The customer segments bringing in the most amount of revenue are the Older families on a budget, the young singles/couples, and the retiree mainstream shoppers.
-	:construction_worker_woman: **Customer behavior**: Mainstream, middle aged and young singles/couples are also more likely to pay more per packet of chips. This is indicative of impulse buying behavior.
-	:trophy: **Top Category**: The top 5 chips that customers prefer to buy are the Kettles, Smiths, Pringles, Doritos, and Thins brands. The category manager might want to increase performance by increasing stock availability for these products.
-	:warning: **Underperformer**: Our least priority customers are the new families, especially the premium buyers. They are not bringing in nearly enough money. We should rather focus more on the mainstream and budget buyers, especially those who are in the young singles/couples or older families’ category.
-	:hourglass_flowing_sand: **Seasonality**: Sales peak in December, and that is something the manager might want to leverage by increasing discount offers and promotional sales from late November to drive traffic.

---

## :warning: Limitations

### Current Limitations
- Dataset only covers a snapshot from July 2018 to June 2019, and so will not reflect current market trends.
- External factors (such as: inflation, supply chain issues, available stock, trendy products) were not included in the analysis
- This analysis is descriptive, not predictive

---

## :mailbox: Contact

**Uchechukwu Esther Okwudili**  
:email: ucokwudili27@gmail.com  
:briefcase: www.linkedin.com/in/uchechukwu-okwudili-a7437933a  
:globe_with_meridians: 

---

*⭐ If you found this project useful or interesting, feel free to star the repository!*

