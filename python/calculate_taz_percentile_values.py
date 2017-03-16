import pandas as pd
df = pd.read_csv("data\\parcels_far_ua_no_small.csv")

def get_quantile_for_col(quantile, series):	
	return 

(df.far_estimate == 0).value_counts()
#~142k parcels have 0 as far_estimate or units_per_acre

df1 = df.loc[df['far_estimate'] != 0]
df2 = df.loc[df['units_per_acre'] != 0]

import numpy as np
# a1 = np.arange(.4,.9,0.1)

df1.set_index("taz_id", inplace=True)
s1 = df1['far_estimate'].groupby(by=df1.index).quantile(0.8)
s2 = df1['far_estimate'].groupby(by=df1.index).size()

df2.set_index("taz_id", inplace=True)
s3 = df2['units_per_acre'].groupby(by=df2.index).quantile(0.8)
s4 = df2['units_per_acre'].groupby(by=df2.index).size()
df4 = pd.DataFrame(index=s3.index)

df3 = pd.DataFrame(index=s1.index)
df3["far_prcnt_estimate_q8"] = s1*100
df3["far_estimate_count"] = s2
df3["units_per_acre_q8"] = s3
df3["units_per_acre_estimate_count"] = s4

df3.to_csv("data\\taz_ua_far_quantiles.csv", index=True)

print(df3.head())
print(df4.head())

print("total counts:")
print(s2.value_counts().head())
print(s4.value_counts().head())

print("q8 counts:")
print(s1.value_counts().head())
print(s3.value_counts().head())
