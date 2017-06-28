#This script needs to be executed from within an ArcGIS Pro Python Window
import arcpy
from arcpy import env

#Set Workspace
env.workspace = "\\Mac\Home\Documents\Planning\Plan Bay Area\TPP CEQA Streamlining\tpp_ceqa_pb_17.gdb"

#Set local parameters

#inFeature from ArcGIS Online
tpas = "TPA_Overlay_2017_Rev_6\TPA_Overlay_2017_Rev_6"

#idFeatures from workspace FGDB
tazs = "TAZ_26910"

#outFeatures exported to workspace FGDB 
taz_tpa_geom = "taz_tpa_geometry"

#Process: Use the Identity Function (TAZ boundaries will be clipped to TPA boundaries)
arcpy.Identity_analysis(inFeatures,idFeatures,outFeatures) 

#Selection query 
sql = "FID_TAZ_26910 = -1"

#Select tpas that fall outsize of taz boundaries
arcpy.SelectLayerByAttribute_management(taz_tpa_geom, "NEW_SELECTION", sql)

#Delete selected tpas
arcpy.DeleteFeatures_management(taz_tpa_geom)

#Delete unnecessary fields from taz_tpa_geom layer 
deleteFields = ["STFID","fipsstco","tract2","superd","arealand","AREAWATR","pop100","landacre","watracre","taz_area","acres"]
arcpy.DeleteField_management(taz_tpa_geom, deleteFields)

