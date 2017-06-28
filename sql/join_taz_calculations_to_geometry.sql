--===========================================================================
-- Join TAZ / TPA geometry to UA / FAR calculations
--===========================================================================

SELECT * 
FROM [dbo].[TAZ_TPA_GEOMETRY] AS SHAPE 
JOIN [dbo].[TAZ_UA_FAR_QUANTILES] AS CALCS
ON SHAPE.taz1454 = CALCS.taz_id