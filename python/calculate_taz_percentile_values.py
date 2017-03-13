import pandas as pd
df = pd.read_csv("data/parcels_far_ua.csv")

def get_quantile_for_col(quantile, series):	
	return 
	
df1 = df.loc[df['far_estimate'] != 0]
df2 = df.loc[df['units_per_acre'] != 0]

import numpy as np
# a1 = np.arange(.4,.9,0.1)

df1.set_index("taz_id", inplace=True)
s1 = df1['far_estimate'].groupby(by=df1.index).quantile(0.8)
s2 = df1['far_estimate'].groupby(by=df1.index).size()
df3 = pd.DataFrame(index=s1.index)
df3["count"] = s2
df3["far_estimate_q8"] = s2

df2.set_index("taz_id", inplace=True)
s3 = df2['units_per_acre'].groupby(by=df2.index).quantile(0.8)
s4 = df2['units_per_acre'].groupby(by=df2.index).size()
df4 = pd.DataFrame(index=s3.index)
df4["count"] = s4
df4["units_per_acre_q8"] = s3

df3.to_csv("data/taz_far_quantiles.csv", index=True)
df4.to_csv("data/taz_units_per_acre_quantiles.csv", index=True)

print(df3.head())
print(df4.head())

print(s2.value_counts().head())
print(s4.value_counts().head())