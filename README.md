###Problem Statement

The Model Map (MM) is on page 61 in the PBA '13 document. Excepting the paper map itself, the data and the methods that were used for that map are not available to us. The goal is to re-create a version of that map using current data.  

That map represents areas where CEQA project approval is possible/likely based roughly on guidelines for 0.75 FAR or 20 Units Per Acre. It seems as if CEQA actually applies to individual parcels, so its a bit hard to aggregate this assessment up to a TAZ, but thats whats required.  

###Data Sources  

When necessary, these data are loaded onto the DEIR Database on MTC's Analysis--II server.   

For convenience, we've developed a FileGDB of the data being used for and output by this project, available [here](https://mtcdrive.box.com/s/j9p7gzfoq7uj4qena9c8zn3t8o8rw76i).   

####Land Use Data   

The majority of the land use data for this map are from County Assessors, ESRI, RedFin, CoStar, and MTC, as documented [here](https://github.com/MetropolitanTransportationCommission/bayarea_urbansim/blob/master/data_regeneration/metadata.csv).   

A subset of these data, those that reflect change between years 2010 and 2040, are output by MTC's implementation of [UrbanSim](https://github.com/MetropolitanTransportationCommission/bayarea_urbansim). The UrbanSim output we use are all sourced from [Box](https://mtcdrive.box.com/s/zk8xw9i531sa5czfrn2qpg6fes6agsa4). 

UrbanSim Preferred scenario/FMMP urban footprint file (available [here](http://mtc.maps.arcgis.com/home/item.html?id=43cd558b015143089d62226396d1d11e&jobid=47cfc388-f7fb-41a1-ae34-1fb1029566b6).     

####Transportation Data  

[TAZ](http://analytics.mtc.ca.gov/foswiki/Main/TazData)   

[Transit Priority Areas](http://mtc.maps.arcgis.com/home/item.html?id=58d037685b9342aca3158af62df79821)   

###Analysis Parameters  

CEQA Streamlining on is based on the Floor Area Ratio and the Units per Acre of an individualsite and the location of the site within a Transit Priority Area. In the Model Map, a boolean value for whether CEQA streamlining was likely was estimated at the TAZ level for the given TAZ. It is unclear in that map what year the map was estimated for but we assume 2040 for this process.   

Therefore, at a basic level, what is needed is:   
1  The Floor Area Ratio for each TAZ   
2  The Units per Acre for each TAZ   
3  The location of Transit Priority areas   

###Methodology    

####Aggregation Technique and Boolean Assignment of Areas:    

#####Average Density Method   

(1) and (2) were summarized from UrbanSim outputs on the DEIR database using the `sql/get_far_and_density.sql` script.  

In this case, we defined the Floor Area Ratio and the Units per Acre for each TAZ as the average over each parcel within each TAZ.   
  
An AGOL Map based on this method is [here](http://arcg.is/2m8H2aK)  

#####Use of Percentile rather than Average   

In reviewing the above we found that there were a number of places in which we expected CEQA might be likely to be applied which were not included in the map including: Berkeley, some parts of Western SF, and areas along North 1st Street in San Jose. In addition, there were a few places such as North Vallejo and South Novato in which development CEQA application seems like it would have been unlikely.  

So we tried applying a method in which any TAZ in which the 80th percentile (top 20% of the distribution) of parcels might qualify for CEQA would be tagged as a potential CEQA streamlining TAZ. 

An AGOL Map of data based on this method is [here](http://mtc.maps.arcgis.com/home/item.html?id=c75f9011843842eb96b64ff28abbb698&jobid=a30452e8-ebd7-4da2-a46e-6a747288637c).   

The SQL query used to summarize the data is [here](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17/blob/master/sql/get_far_and_density.sql#L67-L86).   

#####Can't Assume Land Use Distributions within a TAZ are Normal    

Another methodological issue is that using an assumed normal distribution for density is unreasonable. So we applied a threshold of the 80th percentile within each TAZ based on the actual distribution of the given variable (Units per Acre or FAR) within each taz.    

All of the feature classes at the various quartiles  are output to an AGOL map [here](http://mtc.maps.arcgis.com/home/item.html?id=46a5f6b4c0c44bf6b529daa157ce8be8).   

######Steps to do get the output:   

It was more expedient to use Pandas to apply the quantile analysis, so we followed the following steps to get quantile thresholds for each TAZ for each density value:

1) dump the parcel density table (`UrbanSim.Parcels_FAR_Units_Per_Acre_SP`) to disk

2) create CSV's of the values at a set of reasonable quantiles within each TAZ (`python/calculate_taz_percentile_values.py`)

3) load those CSV's back to a FileGDB with TAZ geometries. AGOL link to data [here](http://mtc.maps.arcgis.com/home/item.html?id=0d4c83530b9f4039a09a497b28e2a386). (`load_taz_quantile_data.bat`, `join_taz_quantiles_to_shapes.bat`)    

####Cartographic Methods   

Once we had hammered out some of the methodological issues above, it became clear that there were also cartographic decisions at play in the Model Map. Below we discuss those.   

#####Clipping to Urban Footprint   

The unit to which we are aggregating (the TAZ) makes sense for modeling, but presents problems cartographically. For example, there is a large TPA in the Presidio by GG Bridge, and a large TAZ there as well. So if we only clip the TAZ summaries to the TPA's, we end up with areas that are unlikely to see CEQA projects.   


The clipped feature class is named `far_sp_q4_clip_to_uf_and_tpa`.    

The best next step might be to choose quartile that works and then clip it. Or clip all of the feature classes and then review. 

###Outcome

Data [here](https://mtcdrive.box.com/s/j9p7gzfoq7uj4qena9c8zn3t8o8rw76i)   

Map [here](http://arcg.is/XGm5v)  

In creating the feature classes for this map we went through several iterations:

###Background and Previous Versions

Below is a hastily documented version of how we got to the final output   

#####Output Data Details    

######Average Density Version:   

FileGDB [here](https://mtcdrive.box.com/s/tn7lmjryk7hgg8gsi0uogwq8vdof2yl0)

######Normal Distribution Version:

The feature classes in here include:

1) potential CEQA TAZ's based on Units per acre   
2) potential CEQA TAZ's based on Units per acre AND FAR   
3) potential CEQA TAZ's (*_ALL_VARS) clipped to the TPA's (which are a necessary area qualification for SQL) with all source data, regardless of what density threshold they meet. we included this last feature class in order to allow us to review all density values and potentially simply toggle on those.   

######Alternative Distributions Version:   

The output of the 3rd round is a set of feature classes, each of which is subset to a given quartile threshold. 

The naming convention for these feature classes, [here](http://mtc.maps.arcgis.com/home/item.html?id=46a5f6b4c0c44bf6b529daa157ce8be8), is:

`far_sp_q8` - a subset of all TAZ's in which the FAR is over the .75 CEQA threshold for the 80th percentile (quartile). 

`far_sp_q7` - a subset of all TAZ's in which the FAR is over the .75 CEQA threshold for the 70th percentile (quartile). 

`ua_sp_q8` - a subset of all TAZ's in which the Units per Acre is over the 20 units/acre CEQA threshold for the 80th percentile (quartile). 

`far_sp_q4_clip_to_uf_and_tpa` is an example of what these TAZ's look like when clipped to TPAs and the Urban Footprint. Below we talk a bit more about why that clipping is necessary. 
