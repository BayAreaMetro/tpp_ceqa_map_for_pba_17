--Floor area ratio = (total amount of usable floor area that a building has, zoning floor area) / (area of the plot)

--need to get square footages from the buildings table to get far
--assumed residential unit size is 1000 sq ft. see:
--https://github.com/MetropolitanTransportationCommission/bayarea_urbansim/blob/master/baus/variables.py#L786
--unclear if this includes common area. will assume that it does. 

create view UrbanSim.Parcels_Building_Square_Footage as
SELECT  b.parcel_id,
		sum(b.residential_units)*1000 as estimated_residential_square_feet
  FROM  DEIR2017.UrbanSim.RUN7224_BUILDING_DATA_2040 as b
		group by b.parcel_id;

--need to add units/acre
--then group by taz_id and average

CREATE VIEW UrbanSim.Parcels_FAR_Units_Per_Acre AS
SELECT  (CASE WHEN p.acres = 0 THEN NULL 
			ELSE pb.estimated_residential_square_feet /  
			(p.acres*43560) END) as far_estimate,
		(CASE WHEN p.acres = 0 THEN NULL 
			ELSE Y2040.total_residential_units/p.acres 
			END) as units_per_acre,
		pb.estimated_residential_square_feet as est_res_sq_ft,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.superd_id
  FROM  DEIR2017.UrbanSim.Parcels_Building_Square_Footage as pb JOIN
		DEIR2017.UrbanSim.Parcels as p ON pb.parcel_id = p.parcel_id JOIN
		UrbanSim.RUN7224_PARCEL_DATA_2040 AS y2040 ON p.PARCEL_ID = y2040.parcel_id;
GO

create view UrbanSim.Parcels_FAR_Units_Per_Acre_SP as
SELECT  pb.estimated_residential_square_feet as est_res_sq_ft,
		pb.units_per_acre,
		pb.far_estimate,
		p.OBJECTID,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.superd_id,
		pc.Centroid
  FROM  DEIR2017.UrbanSim.Parcels_FAR_Units_Per_Acre as pb
		JOIN DEIR2017.UrbanSim.Parcels as p 
			ON pb.parcel_id = p.parcel_id
		JOIN DEIR2017.UrbanSim.Parcels_Centroid_Only pc
			ON p.parcel_id = pb.parcel_id;

GO

---create non-zero view of above

CREATE VIEW UrbanSim.Parcels_FAR_Units_Per_Acre_Non_Zero AS
SELECT  far_estimate,
		units_per_acre,
		estimated_residential_square_feet,
		PARCEL_ID,
		tpa_objectid,
		taz_id,
		superd_id
  FROM  DEIR2017.UrbanSim.Parcels_FAR_Units_Per_Acre
  		WHERE units_per_acre > 0;

GO

create view UrbanSim.Parcels_FAR_Units_Per_Acre_SP as
SELECT  pb.estimated_residential_square_feet as est_res_sq_ft,
		pb.units_per_acre,
		pb.far_estimate,
		p.OBJECTID,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.superd_id,
		pc.Centroid
  FROM  DEIR2017.UrbanSim.Parcels_FAR_Units_Per_Acre as pb
		JOIN DEIR2017.UrbanSim.Parcels as p 
			ON pb.parcel_id = p.parcel_id
		JOIN DEIR2017.UrbanSim.Parcels_Centroid_Only pc
			ON p.parcel_id = pb.parcel_id;

GOs

-----------------
--check on individual parcels in the following taz:  

create view UrbanSim.Parcels_FAR_Units_Per_Acre_False_Positive_SP as
SELECT  pb.est_res_sq_ft,
		pb.units_per_acre,
		pb.far_estimate,
		p.OBJECTID,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.Acres,
		Y2040.total_residential_units,
		p.Shape
  FROM  DEIR2017.UrbanSim.Parcels_FAR_Units_Per_Acre as pb
		JOIN DEIR2017.UrbanSim.Parcels as p
			ON pb.parcel_id = p.parcel_id
		JOIN UrbanSim.RUN7224_PARCEL_DATA_2040 AS y2040 ON p.PARCEL_ID = y2040.parcel_id
		WHERE p.taz_id IN (1448, 1447, 1438, 1437, 1407)



create view UrbanSim.County_Small_Parcel_Stats as
SELECT  p.COUNTY_ID,
		c.[NAME],
		sum(p.Acres) as totacres,
		sum(Y2040.total_residential_units) as totunits
  FROM  DEIR2017.UrbanSim.Parcels as p
		JOIN UrbanSim.RUN7224_PARCEL_DATA_2040 AS y2040 ON p.PARCEL_ID = y2040.parcel_id
		JOIN [DEIR2017].[Analysis].[COUNTIES] c ON p.COUNTY_ID = c.COUNTY_FIP 
		WHERE p.Acres < 0.05
		GROUP BY p.COUNTY_ID, c.NAME

---
SELECT [COUNTY_ID]
      ,[NAME]
      ,cast([totacres] as integer) as totacres
      ,cast([totunits] as integer) as totunits
  FROM [DEIR2017].[UrbanSim].[County_Small_Parcel_Stats]

/*
output of above here: 
https://gist.github.com/tombuckley/81f0d17ae10d14c7915d6600b81029c5
*/

CREATE VIEW UrbanSim.Parcels_FAR_Units_Per_Acre_Non_Zero_Drop_Small AS
SELECT  pb.est_res_sq_ft,
		pb.units_per_acre,
		pb.far_estimate,
		p.OBJECTID,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.Acres,
		Y2040.total_residential_units
  FROM  DEIR2017.UrbanSim.Parcels_FAR_Units_Per_Acre as pb
		JOIN DEIR2017.UrbanSim.Parcels as p
			ON pb.parcel_id = p.parcel_id
		JOIN UrbanSim.RUN7224_PARCEL_DATA_2040 AS y2040 ON p.PARCEL_ID = y2040.parcel_id
		WHERE p.Acres > 0.05 and
		pb.units_per_acre > 0