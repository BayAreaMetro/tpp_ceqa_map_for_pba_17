setlocal EnableDelayedExpansion

set myquery=select far_q8_prcnt, ^
far_cnt, ^
ua_q8, ^
ua_cnt, ^
taz_id ^
from tpa_clipped_taz

ogr2ogr ^
-append ^
-f "FileGDB" ^
-nln tpa_clipped_taz_ua_filter ^
-sql "%myquery% WHERE ua_q8 > 20" ^
data/taz_ua_far_quantiles.gdb data/taz_ua_far_quantiles.gdb

set myquery2=select far_q8_prcnt, ^
far_cnt, ^
ua_q8, ^
ua_cnt, ^
taz_id ^
from tpa_clipped_taz

ogr2ogr ^
-append ^
-f "FileGDB" ^
-nln tpa_clipped_taz_ua_far_filter ^
-sql "%myquery2% WHERE ua_q8 > 20 AND far_q8_prcnt > 75" ^
data/taz_ua_far_quantiles.gdb data/taz_ua_far_quantiles.gdb