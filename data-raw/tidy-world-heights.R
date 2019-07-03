world_heights <- readxl::read_excel(here::here("data-raw",
                                                  "Height_Compact.xlsx"),
                                       sheet = 2) %>%
  dplyr::rename(country = country.name,
                height_cm = value) %>%
  dplyr::select(-ccode)

usethis::use_data(world_heights, overwrite = TRUE)
