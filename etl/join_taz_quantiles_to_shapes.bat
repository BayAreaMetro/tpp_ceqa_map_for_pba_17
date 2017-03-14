setlocal EnableDelayedExpansion
set myquery=select CAST(f.far_prcnt_estimate_q8 as integer(40)) as far_q8_prcnt, ^
CAST(f.far_estimate_count as integer(40)) as far_cnt, ^
CAST(f.units_per_acre_q8 as integer(40)) as ua_q8, ^
CAST(f.units_per_acre_estimate_count as integer(40)) as ua_cnt, ^
CAST(f.taz_id as integer(40)) as taz_id, ^
t.Shape from TAZ_26910 t ^
join 'data/taz_ua_far_quantiles.csv'.taz_ua_far_quantiles f ^
on t.TAZ1454 = f.taz_id

ogr2ogr ^
-f "GPKG" ^
-nln all_taz ^
-sql "%myquery%" ^
data/taz_ua_far_quantiles.gpkg data/tpp_ceqa_pb_17.gdb

set myquery=select CAST(f.far_prcnt_estimate_q8 as integer(40)) as far_q8_prcnt, ^
CAST(f.far_estimate_count as integer(40)) as far_cnt, ^
CAST(f.units_per_acre_q8 as integer(40)) as ua_q8, ^
CAST(f.units_per_acre_estimate_count as integer(40)) as ua_cnt, ^
CAST(f.taz_id as integer(40)) as taz_id, ^
t.Shape from taz_tpa_uf_geometry t ^
join 'data/taz_ua_far_quantiles.csv'.taz_ua_far_quantiles f ^
on t.TAZ1454 = f.taz_id

ogr2ogr ^
-append ^
-f "GPKG" ^
-nln clipped_taz ^
-sql "%myquery%" ^
data/taz_ua_far_quantiles.gpkg data/tpp_ceqa_pb_17.gdb