import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

INPUT_FILE = "Sample data (1).xlsx"
OUTPUT_FILE = "cleaned_business_data.csv"

df = pd.read_excel(INPUT_FILE)
df.columns = [c.strip() for c in df.columns]

# Data cleaning
df["Discount Band"] = df["Discount Band"].fillna("Unknown")
df["Date"] = pd.to_datetime(df["Date"], errors="coerce")
df = df.drop_duplicates().copy()
df["Sales Margin %"] = np.where(df["Sales"] != 0, df["Profit"]/df["Sales"]*100, np.nan)

# KPI analysis
total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
margin = total_profit / total_sales * 100

print("Rows:", len(df))
print("Columns:", len(df.columns))
print(f"Sales: ${total_sales:,.2f}")
print(f"Profit: ${total_profit:,.2f}")
print(f"Profit Margin: {margin:.2f}%")
print(f"Units Sold: {df['Units Sold'].sum():,.0f}")

# Segment / country / product analysis
for dim in ["Segment", "Country", "Product", "Discount Band"]:
    summary = df.groupby(dim).agg(
        Sales=("Sales","sum"),
        Profit=("Profit","sum"),
        Units=("Units Sold","sum"),
        Discounts=("Discounts","sum")
    )
    summary["Margin %"] = summary["Profit"]/summary["Sales"]*100
    print("\n", dim)
    print(summary.sort_values("Sales", ascending=False).round(2))

# Monthly trend
monthly = df.groupby(["Year","Month Number","Month Name"]).agg(
    Sales=("Sales","sum"), Profit=("Profit","sum"), Units=("Units Sold","sum")
).reset_index().sort_values(["Year","Month Number"])
monthly["Margin %"] = monthly["Profit"]/monthly["Sales"]*100
print("\nMonthly trend:")
print(monthly.round(2))

df.to_csv(OUTPUT_FILE, index=False)
monthly.to_csv("monthly_summary.csv", index=False)

# Basic visuals
monthly.plot(x="Month Name", y="Sales", kind="line", marker="o", title="Monthly Sales Trend")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("monthly_sales_trend.png", dpi=180)
plt.close()

segment = df.groupby("Segment")[["Sales","Profit"]].sum().sort_values("Sales", ascending=False)
segment.plot(kind="bar", title="Sales and Profit by Segment")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("segment_performance.png", dpi=180)
plt.close()
