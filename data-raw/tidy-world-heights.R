world_heights <- readxl::read_excel(here::here("data-raw",
                                                  "Height_Compact.xlsx"),
                                       sheet = 2) %>%
  dplyr::rename(code = ccode,
         country = country.name,
         height_cm = value)

usethis::use_data(world_heights)
