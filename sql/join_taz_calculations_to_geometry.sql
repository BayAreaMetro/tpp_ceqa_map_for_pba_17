--===========================================================================
-- Script purpose: Join TAZ / TPA geometry to UA / FAR calculations meeting
-- CEQA thresholds
-- Created by: Joshua Croff 6/28/17
--===========================================================================

--===========================================================================
-- Join TAZ and TPA geometries to DUA and FAR Quantile Calculations table
--===========================================================================

SELECT 
	TAZ_TPA_SHAPE.OBJECTID,
	TAZ1454,
	FAR_PRCNT_ESTIMATE_Q8,
	FAR_ESTIMATE_COUNT,
	UNITS_PER_ACRE_Q8,
	UNITS_PER_ACRE_ESTIMATE_COUNT,
	SHAPE
INTO CEQA_STREAMLINING_QUALIFYING_GEOGRAPHIES
FROM [dbo].[TAZ_TPA_GEOMETRY] AS TAZ_TPA_SHAPE 
JOIN [dbo].[TAZ_UA_FAR_QUANTILES] AS CALCS
ON TAZ_TPA_SHAPE.taz1454 = CALCS.taz_id

--===========================================================================
-- Update CEQA Streamlining qualifying geographies to include field 
-- for determining CEQA eligibility 
--===========================================================================

ALTER TABLE [dbo].[CEQA_STREAMLINING_QUALIFYING_GEOGRAPHIES]
ADD 
	ELIGIBLE varchar(50)

--===========================================================================
-- Update CEQA eligibility field with the following:
-- Residential
-- Residential and Mixed Use 
-- Not Eligible 
--===========================================================================

UPDATE [dbo].[CEQA_STREAMLINING_QUALIFYING_GEOGRAPHIES]
SET [ELIGIBLE] =
	CASE
		WHEN [units_per_acre_q8] > 20 AND [far_prcnt_estimate_q8] > 75 THEN 'Residential and Mixed Use' 
		WHEN [units_per_acre_q8] > 20 AND [far_prcnt_estimate_q8] <= 75 THEN 'Residential'
		ELSE 'Not Eligible' 
	END 


