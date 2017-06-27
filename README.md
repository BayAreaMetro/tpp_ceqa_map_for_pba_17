[Problem Statement](#problem-statement)   
[Data Sources](#data-sources)   
[Methodology](#methodology)   
[Outcome](#outcome)   

### Problem Statement

The Model Map (MM) is on page 61 in the PBA '13 document. Excepting the paper map itself, the data and the methods that were used for that map are not available to us. The goal is to re-create a version of that map using current data.  

That map represents areas where CEQA project approval is possible/likely based roughly on guidelines for 0.75 FAR or 20 Units Per Acre. It seems as if CEQA actually applies to individual parcels, so its a bit hard to aggregate this assessment up to a TAZ, but thats whats required.  

### Data Sources  

When necessary, these data are loaded onto the DEIR Database on MTC's Analysis--II server.   

For convenience, we've developed a FileGDB of the working data being used for this project, available [here](https://mtcdrive.box.com/s/j9p7gzfoq7uj4qena9c8zn3t8o8rw76i). The final [Outcome](#outcome) data is in its own FileGDB.

#### Land Use Data   

The majority of the land use data for this map are from County Assessors, ESRI, RedFin, CoStar, and MTC, as documented [here](https://github.com/MetropolitanTransportationCommission/bayarea_urbansim/blob/e2705babbc29a24897fd8d22a83c1545fa5203b7/data_regeneration/metadata.csv).   

A subset of these data, those that reflect change between years 2010 and 2040, are output by MTC's implementation of [UrbanSim](https://github.com/MetropolitanTransportationCommission/bayarea_urbansim). The UrbanSim output we use are all sourced from [Box](https://mtcdrive.box.com/s/zk8xw9i531sa5czfrn2qpg6fes6agsa4). 

UrbanSim Preferred scenario/FMMP urban footprint file available [here](http://mtc.maps.arcgis.com/home/item.html?id=43cd558b015143089d62226396d1d11e&jobid=47cfc388-f7fb-41a1-ae34-1fb1029566b6).     

#### Transportation Data  

[TAZ](http://analytics.mtc.ca.gov/foswiki/Main/TazData)   

[Transit Priority Areas](http://mtc.maps.arcgis.com/home/item.html?id=58d037685b9342aca3158af62df79821)   

### Analysis Parameters  

We need to assign each TAZ a 'yes' or 'no' value based on the CEQA thresholds of 20 units per acre and .75 FAR (for mixed use projects).  

CEQA Streamlining on is based on the Floor Area Ratio and the Units per Acre of an individual site and the location of the site within a Transit Priority Area. In the Model Map, a boolean value for whether CEQA streamlining was likely was estimated at the TAZ level for the given TAZ. It is unclear in that map what year the map was estimated for but we assume 2040 for this process.   

### Methodology    

The first problem that we faced was that the data that we had are measured at the parcel level. So we had to aggregate that data up to TAZ's in order to assign a TAZ 'yes' OR 'no'. 

We applied a threshold of the value of DUA or FAR at the 80th percentile within each TAZ based on the distribution within each TAZ.       

We clip the TAZ summaries to TPA's, following CEQA guidelines.   

We also drop parcels with less than or equal to .02 acres of land. See [this issue](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17/issues/15) for an explanation of why.   

### Outcome

#### Design:

Current Data [here](https://mtcdrive.box.com/s/hsgqp9z5gb8emxett9fulttrkse876pt)

Naming Convention:  

feature class name|PBA '13 legend name 
-----------------|--------------------
`meeting_residential_and_mixed_use_densities` | Approximate areas projected to meet residential and mixed-use densities
`meeting_residential_densities` | Approximate areas projected to meet residential densities
`not_meeting_densities_tpas` | Approximate areas not projected to meet residential or mixed-use densities

#### Analysis:

Current Map [here](http://arcg.is/XGm5v)   

Current Data [here](https://mtcdrive.box.com/s/p2cygzun71worxqslqlkukpdawju3orb)

Naming Convention:     

feature class name|description name
-----------------|--------------------
`tpa_clipped_ua_filter` | Approximate areas projected to meet [residential and mixed-use densities](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17/blob/77f3301eaeb684b01efe6292ebfec4a91ad8f028/etl/filter_geometries_to_ceqa_threshold.bat#L28)   
`tpa_clipped_ua_far_filter` | Approximate areas projected to meet [residential densities](https://github.com/MetropolitanTransportationCommission/tpp_ceqa_map_for_pba_17/blob/77f3301eaeb684b01efe6292ebfec4a91ad8f028/etl/filter_geometries_to_ceqa_threshold.bat#L14)   
`tpa_clipped_taz` | TAZ clipped to TPA's--geometries only  
`Parcels_FAR_Units_Per_Acre_Non_Zero_Drop_Small` | Source parcel data (acres, units, taz_id, etc)    
