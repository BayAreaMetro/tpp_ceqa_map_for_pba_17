setlocal EnableDelayedExpansion

set myquery=select far_q8_prcnt, ^
far_cnt, ^
ua_q8, ^
ua_cnt, ^
taz_tpa_geometry ^
from tpa_clipped_taz ^
WHERE ua_q8>20

ogr2ogr ^
-append ^
-f "FileGDB" ^
-nln tpa_clipped_taz_ua_filter ^
-sql "%myquery%" ^
data/taz_ua_far_quantiles.gdb data/tpp_ceqa_pb_17.gdb

set myquery2=select far_q8_prcnt, ^
far_cnt, ^
ua_q8, ^
ua_cnt, ^
taz_tpa_geometry ^
from tpa_clipped_taz ^
WHERE ua_q8>20 ^
AND far_q8_prcnt>0.75

ogr2ogr ^
-append ^
-f "FileGDB" ^
-nln tpa_clipped_taz_ua_far_filter ^
-sql "%myquery%" ^
data/taz_ua_far_quantiles.gdb data/tpp_ceqa_pb_17.gdb