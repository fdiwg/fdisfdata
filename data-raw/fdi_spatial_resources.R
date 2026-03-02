require(ows4R)
require(usethis)

#get_baselayer
get_baselayer <- function(wfs, layer, cql_filter = NULL, crs = NULL){
  
  out <- if(is.null(cql_filter)){
    wfs$getFeatures(layer)
  }else{
    wfs$getFeatures(layer, cql_filter = cql_filter)
  }
  sf::st_crs(out) <- 4326
  out$rowid <- 1:nrow(out)
  if(!is.null(crs)) if(crs != 4326){
    out <- sf::st_transform(out, crs = crs)
    
  }
  return(out)
}

#FAO-NFI spatial layers
#ows4R connector for FAO/NFI
WFS_UNFAO_NFI <- ows4R::WFSClient$new(
  url = "https://www.fao.org/fishery/geoserver/wfs",
  serviceVersion = "1.0.0", user = Sys.getenv("GS_USER"), pwd = Sys.getenv("GS_PWD"),
  logger = "INFO"
)

#UN layers of interest
#un_continent_nopole_lowres
un_continent_nopole_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:UN_CONTINENT2_NOPOLE") |> sf::st_make_valid()
usethis::use_data(un_continent_nopole_lowres, overwrite = TRUE)
#un_continent_lowres
un_continent_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:UN_CONTINENT2") |> sf::st_make_valid()
usethis::use_data(un_continent_lowres, overwrite = TRUE)
#un_countries
un_countries = get_baselayer(WFS_UNFAO_NFI, "fifao:country_bounds") |> sf::st_make_valid()
usethis::use_data(un_countries, overwrite = TRUE)
#un_countries_lowres
un_countries_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:country_bounds_legacy") |> sf::st_make_valid()
un_countries_lowres <- rbind(
  un_countries_lowres[is.na(un_countries_lowres$ISO_3),],
  un_countries_lowres[!is.na(un_countries_lowres$ISO_3) & un_countries_lowres$ISO_3 != "EUR",]
)
usethis::use_data(un_countries_lowres, overwrite = TRUE)
#un_boundaries
un_boundaries = get_baselayer(WFS_UNFAO_NFI, "fifao:UN_intbnd") |> sf::st_make_valid()
usethis::use_data(un_boundaries, overwrite = TRUE)
#un_boundaries_lowres
un_boundaries_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:UN_intbnd_legacy") |> sf::st_make_valid()
usethis::use_data(un_boundaries_lowres, overwrite = TRUE)
#un_water_bodies
un_water_bodies = get_baselayer(WFS_UNFAO_NFI, "fifao:WBYA25") |> sf::st_make_valid()
usethis::use_data(un_water_bodies, overwrite = TRUE)
#un_sdg_regions
un_sdg_regions = get_baselayer(WFS_UNFAO_NFI, "fifao:cl_un_sdg_regions") |> sf::st_make_valid()
usethis::use_data(un_sdg_regions, overwrite = TRUE)
#un_sdg_regions_lowres
un_sdg_regions_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:cl_un_sdg_regions_lowres") |> sf::st_make_valid()
usethis::use_data(un_sdg_regions_lowres, overwrite = TRUE)
#un_sdg_regions_placemarks
un_sdg_regions_placemarks = get_baselayer(WFS_UNFAO_NFI, "fifao:cl_un_sdg_regions_placemarks") |> sf::st_make_valid()
usethis::use_data(un_sdg_regions_placemarks, overwrite = TRUE)

#FAO layers of interest

#fao_areas
fao_areas = get_baselayer(WFS_UNFAO_NFI, "fifao:FAO_AREAS_ERASE_LOWRES") |> sf::st_make_valid()
usethis::use_data(fao_areas, overwrite = TRUE)
#fao_areas_inland
fao_areas_inland = get_baselayer(WFS_UNFAO_NFI, "fifao:FAO_AREAS_INLAND") |> sf::st_make_valid()
usethis::use_data(fao_areas_inland, overwrite = TRUE)
#fao_areas_lines
fao_areas_lines = get_baselayer(WFS_UNFAO_NFI, "fifao:FAO_MAJOR_Lines_ERASE") |> sf::st_make_valid()
usethis::use_data(fao_areas_lines, overwrite = TRUE)
#fao_areas_lowres
fao_areas_lowres = get_baselayer(WFS_UNFAO_NFI, "fifao:FAO_AREAS_ERASE_LOWRES") |> sf::st_make_valid()
usethis::use_data(fao_areas_lowres, overwrite = TRUE)
#fao_major_areas_lowres
fao_major_areas_lowres = fao_areas_lowres[fao_areas_lowres$F_LEVEL == 'MAJOR',]
usethis::use_data(fao_major_areas_lowres, overwrite = TRUE)

#CWP layers of interests
wja_level0 = get_baselayer(WFS_UNFAO_NFI, "cwp:wja_level0") |> sf::st_make_valid()
usethis::use_data(wja_level0, overwrite = TRUE)
wja_level1 = get_baselayer(WFS_UNFAO_NFI, "cwp:wja_level1") |> sf::st_make_valid()
usethis::use_data(wja_level1, overwrite = TRUE)

#ICCAT layers of interest

#sampling areas
iccat_sampling_areas_lowres = get_baselayer(WFS_UNFAO_NFI, "iccat:iccat_sa_lowres") |> sf::st_make_valid()
usethis::use_data(iccat_sampling_areas_lowres, overwrite = TRUE)

#IOTC layers of interest
#eur_iotc_cpc
wja_level1_eur_iotc_cpc = get_baselayer(WFS_UNFAO_NFI, "cwp:wja_level1_eur_iotc_cpc") |> sf::st_make_valid()
usethis::use_data(wja_level1_eur_iotc_cpc, overwrite = TRUE)
