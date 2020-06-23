#################################################
## Convert MoS Corona Files to binary format   ##
## Minimize storage space and loading times    ##
## Files to be read in as data.tables          ##
## James Hunter                                ##
## 6/23/20                                     ##
#################################################

options(scipen = 10)
pacman::p_load(scales, tidyverse, lubridate, glue, here, data.table)

## setup variables

region_names <- tibble(pt = c("Norte", "Nordeste", "Sudeste", "Sul",
                              "Centro-Oeste"),
                       region_en = c("North", "Northeast", "Southeast", "South",
                                     "Center-West"))
state_names <- tibble(sigla = c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES",
                                "GO", "MA", "MG", "MS", "MT", "PA", "PB", "PE",
                                "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC",
                                "SE", "SP", "TO"),
                      state_name = c("Acre", "Alagoas", "Amazonas", "Amapá",
                                     "Bahia", "Ceará", "Distrito Federal", 
                                     "Espírito Santo", "Goiás", "Maranhão",
                                     "Minas Gerais", "Mato Grosso do Sul", 
                                     "Mato Grosso", "Pará", "Paraíba", 
                                     "Pernambuco", "Piauí", "Paraná",
                                     "Rio de Janeiro", "Rio Grande do Norte",
                                     "Rondônia", "Roraima", "Rio Grande do Sul",
                                     "Santa Catarina", "Sergipe", "São Paulo", 
                                     "Tocantins"))

# identify the data file

file_date <- "2020-06-21"
filename <-  here("data/HIST_PAINEL_COVIDBR_21jun2020.csv") # ALWAYS Check the name!

# load the data file using `data.table::fread()`. 

br_data <- fread(filename)

br_data <- br_data %>% 
  select(reg = regiao, st = estado, mun = municipio, date = data, 
         pop = populacaoTCU2019, cases_accum = casosAcumulado, 
         cases_new = casosNovos, deaths_accum = obitosAcumulado, 
         deaths_new = obitosNovos) %>% 
  mutate(pop = as.numeric(pop)) %>%  # make pop numeric; NA in place of blank
  mutate(date_d = as.Date(date, format = "%m/%d/%Y")) # put dates in calculable 

# Clean region and state names

br_data <- br_data %>% 
  left_join(state_names, by = c("st" = "sigla")) 

# code lines to store data file if needed (execute code after comment #)
# sys_date = as.character(Sys.Date())

saveRDS(br_data, here(glue("data/br_data_", file_date, ".rds")))

#saveRDS(br_data, here(glue("data/", "br_data_160621.rds")))  # use to save data 