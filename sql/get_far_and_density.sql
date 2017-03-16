--Floor area ratio = (total amount of usable floor area that a building has, zoning floor area) / (area of the plot)

--need to get square footages from the buildings table to get far
--assumed residential unit size is 1000 sq ft. see:
--https://github.com/MetropolitanTransportationCommission/bayarea_urbansim/blob/master/baus/variables.py#L786
--unclear if this includes common area. will assume that it does. 

create view UrbanSim.Parcels_CEQA_Square_Footage as
SELECT  b.parcel_id,
		sum(b.non_residential_sqft) as total_non_residential_sqft,
		sum(b.residential_units)*1000 as total_residential_sqft,
		((sum(b.residential_units)*1000) + sum(b.non_residential_sqft)*sum(b.residential_units)/(abs(sum(b.residential_units)-1)+1)) as estimated_ceqa_square_feet -- from http://puzzling.stackexchange.com/questions/33625/function-that-is-1-for-all-positive-integers-but-0-at-0
  FROM  DEIR2017.UrbanSim.RUN7224_BUILDING_DATA_2040 as b
		group by b.parcel_id;

--need to add units/acre
--then group by taz_id and average

CREATE VIEW UrbanSim.Parcels_FAR_Units_Per_Acre AS
SELECT  (CASE WHEN p.acres = 0 THEN NULL 
			ELSE pb.estimated_ceqa_square_feet /  
			(p.acres*43560) END) as far_estimate,
		(CASE WHEN p.acres = 0 THEN NULL 
			ELSE Y2040.total_residential_units/p.acres 
			END) as units_per_acre,
		pb.estimated_ceqa_square_feet as est_ceqa_sq_ft,
		p.PARCEL_ID,
		p.tpa_objectid,
		p.taz_id,
		p.superd_id
  FROM  DEIR2017.UrbanSim.Parcels_CEQA_Square_Footage as pb JOIN
		DEIR2017.UrbanSim.Parcels as p ON pb.parcel_id = p.parcel_id JOIN
		UrbanSim.RUN7224_PARCEL_DATA_2040 AS y2040 ON p.PARCEL_ID = y2040.parcel_id;
GO

CREATE VIEW UrbanSim.Parcels_FAR_Units_Per_Acre_Non_Zero_Drop_Small AS
SELECT  pb.est_ceqa_sq_ft,
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
		WHERE p.Acres > 0.02 and
		pb.units_per_acre > 0