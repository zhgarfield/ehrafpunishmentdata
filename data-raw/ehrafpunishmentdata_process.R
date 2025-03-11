### Testing evolutionary alternative models of punishment in the ethnographic record
### Data processing script

# Load libraries ----------------------------------------------------------
library(tidyverse)
library(readxl)
library(stringi)
library(purrr)  # For map function to replace lapply
library(readr)


# Custom functions --------------------------------------------------------

# Function to select vars
select_variables <- function(data, var_names) {
  if (!is.data.frame(data)) {
    stop("Input 'data' must be a data frame.")
  }

  data %>%
    select(all_of(var_names))
}

# Function to replace "NA NA" with NA in character columns
replace_na_na <- function(column) {
  column <- gsub("NA NA", NA, column)
}

# Data management ---------------------------------------------------------

# Read in the raw data from team3PP eHRAF search
raw_data <- read_csv("data-raw/hraf-export-15380.csv")

# Subset just texts
all_text <- raw_data %>%
  select(c("uuid", "text"))

# Read coder data files
data_coder1 <- readxl::read_xlsx("data-raw/data_coder1.xlsx")
data_coder2 <- readxl::read_xlsx("data-raw/data_coder2.xlsx")
data_coder3 <- readxl::read_xlsx("data-raw/data_coder3.xlsx")
data_coder4 <- readxl::read_xlsx("data-raw/data_coder4.xlsx")
data_coder5 <- readxl::read_xlsx("data-raw/data_coder5.xlsx")
data_coder6 <- readxl::read_xlsx("data-raw/data_coder6.xlsx")
data_coder7 <- readxl::read_xlsx("data-raw/data_coder7.xlsx")
data_coder8 <- readxl::read_xlsx("data-raw/data_coder8.xlsx")

# Order and rename data sets
d1 <- data_coder1[order(data_coder1$uuid),]
d2 <- data_coder2[order(data_coder2$uuid),]
d3 <- data_coder3[order(data_coder3$uuid),]
d4 <- data_coder4[order(data_coder4$uuid),]
d5 <- data_coder5[order(data_coder5$uuid),]
d6 <- data_coder6[order(data_coder6$uuid),]
d7 <- data_coder7[order(data_coder7$uuid),]
d8 <- data_coder8[order(data_coder8$uuid),]

# Add coder ID variable
d1$coder <- "coder1"
d2$coder <- "coder2"
d3$coder <- "coder3"
d4$coder <- "coder4"
d5$coder <- "coder5"
d6$coder <- "coder6"
d7$coder <- "coder7"
d8$coder <- "coder8"


## Combine coded data sets
# Select variables for study
study_vars <- c("uuid","coder", "UP", "2PP", "3PP", "3PP_kin", "3PP_partner", "3PP_stranger")

d1 <- select_variables(d1, study_vars)
d2 <- select_variables(d2, study_vars)
d3 <- select_variables(d3, study_vars)
d4 <- select_variables(d4, study_vars)
d5 <- select_variables(d5, study_vars)
d6 <- select_variables(d6, study_vars)
d7 <- select_variables(d7, study_vars)
d8 <- select_variables(d8, study_vars)

data_coded <- bind_rows(d1, d2, d3, d4, d5, d6, d7, d8)

# Rename variables
data_coded <- data_coded %>%
  rename(secondparty = "2PP",
         thirdparty = "3PP",
         thirdparty_kin = "3PP_kin",
         thirdparty_partner = "3PP_partner",
         thirdparty_general = "3PP_stranger",
         unspecified = "UP")

coded_vars <- c("secondparty",
                "thirdparty",
                "thirdparty_kin",
                "thirdparty_partner",
                "thirdparty_general",
                "unspecified")


# Fill in uncoded sub-codes for third-party
data_coded$thirdparty_kin[data_coded$thirdparty=="No evidence"] <- "No evidence"
data_coded$thirdparty_partner[data_coded$thirdparty=="No evidence"] <- "No evidence"
data_coded$thirdparty_general[data_coded$thirdparty=="No evidence"] <- "No evidence"

# Filter rows where all coded variables are NA, i.e., coder did not code those rows
# List of columns to check for NA
cols_to_check <- c("unspecified", "secondparty", "thirdparty", "thirdparty_kin", "thirdparty_partner", "thirdparty_general")

# Filter out rows where all specified columns are NA
data_coded <- data_coded[!apply(data_coded[cols_to_check], 1, function(row) all(is.na(row))), ]

# Replace remaining NAs with "No evidence" in the specified columns
data_coded[cols_to_check] <- lapply(data_coded[cols_to_check], function(x) ifelse(is.na(x), "No evidence", x))


## Additional culture-level variables

# Master cross-ID data
eHRAF_EA_IDs <- read_xlsx("data-raw/eHRAF_EA_SCCS_IDs.xlsx", sheet = 1)
eHRAF_EA_IDs$owc_id <- eHRAF_EA_IDs$`OWC ID`
eHRAF_EA_IDs$owc_name <- eHRAF_EA_IDs$`OWC CULTURE NAME`
eHRAF_EA_IDs$ea_name <- eHRAF_EA_IDs$`EA CULTURE NAME`
eHRAF_EA_IDs$ea_id <- eHRAF_EA_IDs$`EA ID`
eHRAF_EA_IDs <- eHRAF_EA_IDs %>%
  select(owc_id, owc_name, ea_name, ea_id)

eHRAF_SCCS_IDs <- read_xlsx("data-raw/eHRAF_EA_SCCS_IDs.xlsx", sheet = 2)
eHRAF_SCCS_IDs$owc_id <- eHRAF_SCCS_IDs$`OWC CODE`
eHRAF_SCCS_IDs$owc_name <- eHRAF_SCCS_IDs$`OWC CULTURE NAME`
eHRAF_SCCS_IDs$sccs_id <- eHRAF_SCCS_IDs$`SCCS ID`
eHRAF_SCCS_IDs$sccs_name <- eHRAF_SCCS_IDs$`SCCS SAMPLE CULTURE NAME`
eHRAF_SCCS_IDs <- eHRAF_SCCS_IDs %>%
  select(owc_id, owc_name, sccs_name, sccs_id)

# SCCS data
load("data-raw/sccs.RData")
sccs_data <- data.frame(sccs)
sccs_data$sccs_id <- sccs_data$SCCS.

# Select SCCS vars for study
sccs_data <- sccs_data %>%
  select(sccs_id, V1, V20, V63,
         V149, V150, V151, V153, V155, V156, V157, V158,
         V204, V210, V211, V213, V219, V230, V247,
         V1716, V1732, V1734)

# Recode SCCS vars
sccs_data <- sccs_data %>%
  mutate(External_trade_SCCSv1 = recode_factor(V1,
                                               `No Trade` = "Minimal/Absent",
                                               `No Food Imports` = "Minimal/Absent",
                                               `Salt & Minerals only` = "Minimal/Absent",
                                               `< 10% of Food` = "Minimal/Absent",
                                               `< 50% of Food/less local source` = "Present",
                                               `> 50% of Food` = "Present"),
         Food_storage_SCCSv20 = recode_factor(V20,
                                              `None` = 0,
                                              `Economic agent controlled` = 1,
                                              `Political agent controlled` = 1,
                                              `Communal facilities` = 1,
                                              `Individual households` = 1),
         Community_size_SCCSv63 = factor(V63, levels = c("< 50",
                                                         "50-99",
                                                         "100-199",
                                                         "200-399",
                                                         "400-999",
                                                         "1,000-4,999",
                                                         "5,000-49,999",
                                                         "> 50,000"),
                                         ordered = TRUE
         ),
         Community_size_SCCSv63 <- dplyr::recode(Community_size_SCCSv63,
                                                        "< 50" = "1",
                                                        "50-99" = "1",
                                                        "100-199" = "2",
                                                        "200-399" = "3",
                                                        "400-999" = "4",
                                                        "1,000-4,999" = "5",
                                                        "5,000-49,999" = "5",
                                                        "> 50,000" = "5"
         ),
         # Convert the recoded variable to a factor with ordered levels
         Community_size_SCCSv63 <- factor(Community_size_SCCSv63,
                                                 levels = c("1", "2", "3", "4", "5"),
                                                 ordered = TRUE),
         Writing_SCCSv149 = recode_factor(V149,
                                          `True writing, records` = 5,
                                          `True writing; no records` = 4,
                                          `Nonwritten records` = 3,
                                          `Mnemonic devices` = 2,
                                          `None` = 1),
         Fixity_residence_SCCS_v150 = recode_factor(V150,
                                                    `Sedentary` = 5,
                                                    `Sedentary; impermanent` = 4,
                                                    `Semisedentary` = 3,
                                                    `Seminomadic` = 2,
                                                    `Nomadic` = 1),
         Labor_specialization_SCCS_v153 = recode_factor(V153,
                                                    `Smiths, weavers, potters` = 5,
                                                    `Metalwork only` = 4,
                                                    `Loom weaving only` = 3,
                                                    `Pottery only` = 2,
                                                    `None` = 1),
         Agricultre_SCCSv151 = recode_factor(V151,
                                             `Primary; intensive` = 5,
                                             `Primary; not intensive` = 4,
                                             `10 %; secondary` = 3,
                                             `10% food supply` = 2,
                                             `None` = 1),
         Agricultre_SCCSv151 = factor(Agricultre_SCCSv151,
                                      levels = c(
                                        1,
                                        2,
                                        3,
                                        4,
                                        5),
                                      ordered = TRUE),
         Money_SCCSv155 = recode_factor(V155,
                                        `True money` = 5,
                                        `Elementary forms ` = 4,
                                        `Alien currency` = 3,
                                        `Domestically usable particles` = 2,
                                        `None` = 1),
         Desnity_population_SCCSv156 = recode_factor(V156,
                                                     `< 1 person / sq. mile` = 1,
                                                     `1-5 persons / sq. mile` = 2,
                                                     `5.1-25 persons/ sq. mile` = 3,
                                                     `26-100 persons  / sq. mile` = 4,
                                                     `100 persons / sq. mile` = 5),
         Political_integration_SCCSv157 = recode(V157,
                                                 `None` = 1,
                                                 `Autonomous local communities` = 2,
                                                 `1 level above community` = 3,
                                                 `2 levels above community` = 4,
                                                 `3 levels above community` = 5),
         Political_integration_SCCSv157 = factor(Political_integration_SCCSv157,
                                                 levels = c(1,
                                                            2,
                                                            3,
                                                            4,
                                                            5),
                                                 ordered = TRUE
         ),
         Social_stratification_SCCSv158 = recode_factor(V158,
                                                        `Egalitarian` = 1,
                                                        `2 social classes, no castes/slavery` = 3,
                                                        `Hereditary slavery` = 2,
                                                        `2 social classes, castes/slavery` = 4,
                                                        `3 social classes or castes, w/ or w/out slavery` = 5),
         Hunting_SCCSv204 = factor(V204, levels = c("0-5% Dependence",
                                                    "6-15%",
                                                    "16-25%",
                                                    "26-35%",
                                                    "36-45%",
                                                    "46-55%",
                                                    "56-65%",
                                                    "66-75%",
                                                    "76-85%",
                                                    "86-100% Dependence"),
                                   ordered = TRUE),
         Hunting_SCCSv204 <- dplyr::recode(Hunting_SCCSv204,
                                                  "0-5% Dependence" = 0,
                                                  "6-15%" = 1,
                                                  "16-25%" = 2,
                                                  "26-35%" = 3,
                                                  "36-45%" = 4,
                                                  "46-55%" = 5,
                                                  "56-65%" = 6,
                                                  "66-75%" = 7,
                                                  "76-85%" = 8,
                                                  "86-100% Dependence" = 9
         ),
         Domestic_organization_SCCSv120 = recode_factor(V210,
                                                        `Small extended families` = "Small extended families",
                                                        `Minimal extended families` = "Minimal extended families",
                                                        `Polygynous: Usual Co-wife` = "Polygynous: Usual Co-wife",
                                                        `Polygynous: Unusual Co-wives` = "Polygynous: Unusual Co-wives",
                                                        `Polyandrous Families` = "Polyandrous Families",
                                                        `Nuclear Family,  Occasional Polygyny` = "Nuclear Family,  Occasional Polygyny",
                                                        `Nuclear Family, Monogamous` = "Nuclear Family, Monogamous"),
         Community_marriage_organization_SCCSv219 = recode_factor(V219,
                                                                  `Clan communities` = "Clan communities",
                                                                  `Segmented communities with local Exogamy` = "Segmented communities with local Exogamy",
                                                                  `Exogamous communities` = "Exogamous communities",
                                                                  `Agamous communities` = "Agamous communities",
                                                                  `segmented communities without local Exogamy` = "Segmented communities without local Exogamy",
                                                                  `Demes` = "Demes"
         ),
         Primary_subsistence_SCCSv1716 = recode_factor(V1716,
                                                       `wage labor` = "Commercial economy",
                                                       `trade` = "Commercial economy",
                                                       `gathering` = "Foraging",
                                                       `hunting` = "Foraging",
                                                       `fishing` = "Foraging",
                                                       `animal husbandary` = "Animal husbandary",
                                                       `extensive agriculture` = "Agriculture",
                                                       `intensive agriculture` = "Agriculture"),
         Wage_labor_present_SCCSv1732 = recode_factor(V1732,
                                                      `no wage labor` = "Absent",
                                                      `wage labor, mainly in form of migratory labor` = "Present",
                                                      `wage labor present, migratory labor unimportant` = "Present"
         )
  )

sccs_data <- sccs_data[,c(1,23:25,27:39)]

# Create PSF culture-level data set
culture_level_data <- read_xlsx("data-raw/2021-06-30-cultures-covered.xlsx") %>%
  filter(PSF == "Yes")
culture_level_data$owc_id <- culture_level_data$OWC
culture_level_data$owc_name <- culture_level_data$`eHRAF World Cultures Name`
culture_level_data <- culture_level_data %>%
  select(owc_id, owc_id, owc_name, Documents, Region, Subregion, `Subsistence Type`, PSF)

## Merge all culture-level data
# Add eHRAF ID key data frames
culture_level_data <- left_join(culture_level_data, eHRAF_SCCS_IDs, by = "owc_id")
culture_level_data$owc_name <- coalesce(culture_level_data$owc_name.x, culture_level_data$owc_name.y)
culture_level_data <- culture_level_data %>%
  select(-c(owc_name.y, owc_name.x))

culture_level_data <- left_join(culture_level_data, eHRAF_EA_IDs, by = "owc_id")
culture_level_data$owc_name <- coalesce(culture_level_data$owc_name.x, culture_level_data$owc_name.y)
culture_level_data <- culture_level_data %>%
  select(-c(owc_name.y, owc_name.x))

# Weird issue when filtering, non-EA societies getting set to NA for the entire row...will add 999 for NA for EA and SCCS ids
culture_level_data$ea_id[is.na(culture_level_data$ea_id)==TRUE] <- 999
culture_level_data$sccs_id[is.na(culture_level_data$sccs_id)==TRUE] <- 999


# Filter rows for duplicate EA cases and PSF/SCCS
culture_level_data <- culture_level_data[!c(culture_level_data$ea_id=="Af12"|
                                              culture_level_data$ea_id=="Af42"|
                                              culture_level_data$ea_id=="Ca10"|
                                              culture_level_data$ea_id=="Cb01"|
                                              culture_level_data$ea_id=="Cb26"|
                                              culture_level_data$ea_id=="Cd18"|
                                              culture_level_data$ea_id=="Ne13"|
                                              culture_level_data$ea_id=="Ne18"|
                                              culture_level_data$ea_id=="Na33"|
                                              culture_level_data$ea_id=="Na34"|
                                              culture_level_data$ea_id=="Na35"|
                                              culture_level_data$ea_id=="Na36"|
                                              culture_level_data$ea_id=="Na37"|
                                              culture_level_data$ea_id=="Ne14"|
                                              culture_level_data$ea_id=="Sd04"|
                                              culture_level_data$ea_id=="Sd06"|
                                              culture_level_data$ea_id=="Sd08"|
                                              culture_level_data$ea_id=="Se12"),
]


# Add SCCS data
culture_level_data <- left_join(culture_level_data, sccs_data, by = "sccs_id")

## Add KII data compiled by GFF
gregs_kii_data <- read_csv("data-raw/cultural_data_SCCS.csv")
gregs_kii_data$sccs_id <- gregs_kii_data$society_id

# Recode KII variables
gregs_kii_data <- gregs_kii_data %>%
  mutate(community_organization_recode = recode(community_organization,
                                                "Agamous" = 0,
                                                "Exogamous" = 0,
                                                "Segmented, no exogamy" = 0,
                                                "Clans" = 1,
                                                "Demes" = 1,
                                                "Segmented, exogamy" = 1
  ))


gregs_kii_data <- gregs_kii_data %>%
  mutate(cousin_marriage_recode = recode(cousin_marriage,
                                         "None preferred" = 0,
                                         "Second cousin" = 1,
                                         "Cross-cousin" = 2,
                                         "MoBrDa" = 2,
                                         "FaBrDa" = 3,
                                         "FaSiDa" = 3
  ))


gregs_kii_data <- gregs_kii_data %>%
  mutate(lineage_organization_recode = recode(lineage_organization,
                                              "Bilateral" = 0,
                                              "Ambilineal" = 1,
                                              "Duolateral" = 1,
                                              "Matrilineal" = 1,
                                              "Patrilineal" = 1,
                                              "Quasi-lineages" = 1,
                                              "Mixed" = 1
  ))

gregs_kii_data <- gregs_kii_data %>%
  mutate(domestic_organization_recode = recode(domestic_organization,
                                               "Nuclear, monogamous" = 0,
                                               "Nuclear, limited polygyny" = 0,
                                               "Polyandrous" = 0,
                                               "Polygyny, atypical cowives pattern" = 0,
                                               "Polygyny, typical cowives pattern" = 0,
                                               "Minimal extended" = 1,
                                               "Small extended" = 2,
                                               "Large extended" = 3
  ))


gregs_kii_data <- gregs_kii_data %>%
  mutate(polygamy_recode = recode(polygamy,
                                  "Monogamous" = 0,
                                  "Limited polygyny" = 1,
                                  "Polygyny, non-sororal cohabit" = 2,
                                  "Polygyny, sororal cohabit" = 2,
                                  "Polygyny, non-sororal separate" = 1,
                                  "Polygyny, sororal separate" = 1,
                                  "Polyandrous" = 2
  ))


gregs_kii_data <- gregs_kii_data %>%
  mutate(marital_residence_recode = recode(marital_residence,
                                           "Neolocal" = 0,
                                           "Ambilocal" = 1,
                                           "Ambi-uxo" = 1,
                                           "Ambi-viri" = 1,
                                           "Patrilocal" = 2,
                                           "Matrilocal" = 2,
                                           "Avunculocal" = 2,
                                           "Avuncu-virilocal" = 2,
                                           "Avuncu-uxorilocal" = 2,
                                           "Virilocal" = 2,
                                           "Uxorilocal" = 2,
                                           "Separate" = 2
  ))

# Merge KII data
culture_level_data <- left_join(culture_level_data, gregs_kii_data)



## Getting KII vars directly from DPLACE
CommunitymarriageEA015 <- read_csv("data-raw/EA_DPLACE_vars/CommunitymarriageEA015.csv") %>%
  select(society_id, society_name, EA015code, EA015code_label)
CousinmarriagesEA026 <- read_csv("data-raw/EA_DPLACE_vars/CousinmarriagesEA026.csv") %>%
  select(society_id, society_name, EA026code, EA026code_label)
DescentEA043 <- read_csv("data-raw/EA_DPLACE_vars/DescentEA043.csv") %>%
  select(society_id, society_name, EA043code, EA043code_label)
DomesticorganizationEA008 <- read_csv("data-raw/EA_DPLACE_vars/DomesticorganizationEA008.csv") %>%
  select(society_id, society_name, EA008code, EA008code_label)
MaritalcompositionEA009 <- read_csv("data-raw/EA_DPLACE_vars/MaritalcompositionEA009.csv") %>%
  select(society_id, society_name, EA009code, EA009code_label)
MaritalresidenceEA012 <- read_csv("data-raw/EA_DPLACE_vars/MaritalresidenceEA012.csv") %>%
  select(society_id, society_name, EA012code, EA012code_label)

DPLACE_EA_Data <- left_join(CommunitymarriageEA015, CousinmarriagesEA026) %>%
  left_join(.,DescentEA043) %>%
  left_join(.,DomesticorganizationEA008) %>%
  left_join(.,MaritalcompositionEA009) %>%
  left_join(., MaritalresidenceEA012)
DPLACE_EA_Data$ea_id <- DPLACE_EA_Data$society_id
DPLACE_EA_Data$ea_name <- DPLACE_EA_Data$society_name

# Fix three characther EA names in DPLACe
add_zero_if_three <- function(x) {
  ifelse(nchar(x) == 3, paste0(substr(x, 1, 2), "0", substr(x, 3, 3)), x)
}

# Apply the function to the character vector
DPLACE_EA_Data$ea_id <- sapply(DPLACE_EA_Data$ea_id, add_zero_if_three)

### FIX ISSUES OF LABELS OF RECODES NOT CONSISTENT WHEN MERGING AND COALESCING NEED TO DO

# Recode the EA015code_label variable
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(community_organization_recode = recode(EA015code_label,
                                                "Agamous" = 0,
                                                "Exogamous" = 0,
                                                "Segmented, no exogamy" = 0,
                                                "Clans" = 1,
                                                "Demes" = 1,
                                                "Segmented, exogamy" = 1
  ))

# Recode EA026code_label (Cousin Marriage Preference)
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(cousin_marriage_recode = recode(EA026code_label,
                                             "None preferred" = 0,
                                             "Second cousin" = 1,
                                             "Cross-cousin" = 2,
                                             "MoBrDa" = 2,
                                             "FaBrDa" = 3,
                                             "FaSiDa" = 3
  ))

# Recode EA043code_label (Lineage Organization)
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(lineage_organization_recode = recode(EA043code_label,
                                       "Bilateral" = 0,
                                       "Ambilineal" = 1,
                                       "Duolateral" = 1,
                                       "Matrilineal" = 1,
                                       "Patrilineal" = 1,
                                       "Quasi-lineages" = 1,
                                       "Mixed" = 1
  ))

# Recode EA008code_label (Domestic Organization)
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(domestic_organization_recode = recode(EA008code_label,
                                        "Nuclear, monogamous" = 0,
                                        "Nuclear, limited polygyny" = 0,
                                        "Polyandrous" = 0,
                                        "Polygyny, atypical cowives pattern" = 0,
                                        "Polygyny, typical cowives pattern" = 0,
                                        "Minimal extended" = 1,
                                        "Small extended" = 2,
                                        "Large extended" = 3
  ))

# Recode EA009code_label (Polygamy)
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(polygamy_recode = recode(EA009code_label,
                           "Monogamous" = 0,
                           "Limited polygyny" = 1,
                           "Polygyny, non-sororal cohabit" = 2,
                           "Polygyny, sororal cohabit" = 2,
                           "Polygyny, non-sororal separate" = 1,
                           "Polygyny, sororal separate" = 1,
                           "Polyandrous" = 2
  ))

# Recode EA012code_label (Marital Residence)
DPLACE_EA_Data <- DPLACE_EA_Data %>%
  mutate(marital_residence_recode = recode(EA012code_label,
                                    "Neolocal" = 0,
                                    "Ambilocal" = 1,
                                    "Ambi-uxo" = 1,
                                    "Ambi-viri" = 1,
                                    "Patrilocal" = 2,
                                    "Matrilocal" = 2,
                                    "Avunculocal" = 2,
                                    "Avuncu-virilocal" = 2,
                                    "Avuncu-uxorilocal" = 2,
                                    "Virilocal" = 2,
                                    "Uxorilocal" = 2,
                                    "Separate" = 2
  ))

culture_level_data <- left_join(culture_level_data, DPLACE_EA_Data, by = "ea_id")

## Merge and coalesce GF KII data and EA data
culture_level_data$community_organization_recode <- coalesce(culture_level_data$community_organization_recode.x,
                                                           culture_level_data$community_organization_recode.y)

culture_level_data$domestic_organization_recode <- coalesce(culture_level_data$domestic_organization_recode.x,
                                                          culture_level_data$domestic_organization_recode.y)

culture_level_data$marital_residence_recode <- coalesce(culture_level_data$marital_residence_recode.x,
                                                      culture_level_data$marital_residence_recode.y)

culture_level_data$polygamy_recode <- coalesce(culture_level_data$polygamy_recode.x,
                                             culture_level_data$polygamy_recode.y)

culture_level_data$cousin_marriage_recode <- coalesce(culture_level_data$cousin_marriage_recode.x,
                                                    culture_level_data$cousin_marriage_recode.y)

culture_level_data$lineage_organization_recode <- coalesce(culture_level_data$lineage_organization_recode.x,
                                                         culture_level_data$lineage_organization_recode.y)

# Select relevant variables
culture_level_data <- culture_level_data %>%
  select("owc_id", "sccs_id","owc_name", #IDs
         "Documents", "Region", "Subregion", "Subsistence Type", #Culture metadata
         "Writing_SCCSv149", "Fixity_residence_SCCS_v150", "Agricultre_SCCSv151", "Community_size_SCCSv63", "urbanization_code", # Complexity variables
         "Labor_specialization_SCCS_v153", "transport_code", "money_use_code", "Money_SCCSv155",
         "Desnity_population_SCCSv156", "pop_density_code", "pol.integration_code", "Political_integration_SCCSv157",
         "Social_stratification_SCCSv158", "stratification_code", "Hunting_SCCSv204", "Food_storage_SCCSv20",
         "community_organization_recode", "domestic_organization_recode", "marital_residence_recode", #KII variables
         "polygamy_recode", "cousin_marriage_recode", "lineage_organization_recode")

# Read in additional KII data coded by GF
missing_kii_data <- readxl::read_xlsx("data-raw/Culture-level missing data collection.xlsx", sheet = 1)

# Read in additional SCCS data coded by A and ZG
missing_sccs_data <- readxl::read_xlsx("data-raw/Culture-level missing data collection.xlsx", sheet = 2)

# Merge additional hand coded data
culture_level_data <- left_join(culture_level_data, missing_kii_data, by = 'owc_id')
culture_level_data <- left_join(culture_level_data, missing_sccs_data, by = 'owc_id')

# Coalesce all duplicate columns
culture_level_data %>% mutate_if(is.factor, as.character) -> culture_level_data

# Coalescing duplicate variables with type conversion where needed
culture_level_data <- culture_level_data %>%
  mutate(
    Writing_SCCSv149 = coalesce(as.character(Writing_SCCSv149.x), as.character(Writing_SCCSv149.y)),
    Density_population_SCCSv156 = coalesce(as.character(Density_population_SCCSv156), as.character(Desnity_population_SCCSv156)),
    Density_population_SCCSv156 = coalesce(as.character(Density_population_SCCSv156), as.character(pop_density_code)),
    Labor_specialization_SCCSv153 = coalesce(as.character(Labor_specialization_SCCSv153), as.character(Labor_specialization_SCCS_v153)),
    Fixity_residence_SCCSv150 = coalesce(as.character(Fixity_residence_SCCS_v150.x), as.character(Fixity_residence_SCCS_v150.y)),
    Agricultre_SCCSv151 = coalesce(as.character(Agricultre_SCCSv151.x), as.character(Agricultre_SCCSv151.y)),
    Land_transport_SCCSv1554 = coalesce(as.character(Land_transport_SCCSv1554), as.character(transport_code)),
    Urbanization_SCCSv152 = coalesce(as.character(Urbanization_SCCSv152), as.character(urbanization_code)),
    Money_SCCSv155 = coalesce(as.character(Money_SCCSv155.x), as.character(Money_SCCSv155.y)),
    Money_SCCSv155 = coalesce(as.character(Money_SCCSv155), as.character(money_use_code)),
    Political_integration_SCCSv157 = coalesce(as.character(Political_integration_SCCSv157.x), as.character(Political_integration_SCCSv157.y)),
    Political_integration_SCCSv157 = coalesce(as.character(Political_integration_SCCSv157), as.character(pol.integration_code)),
    Social_stratification_SCCSv158 = coalesce(as.character(Social_stratification_SCCSv158.x), as.character(Social_stratification_SCCSv158.y)),
    Social_stratification_SCCSv158 = coalesce(as.character(Social_stratification_SCCSv158), as.character(stratification_code)),
    Hunting_SCCSv204 = coalesce(as.character(Hunting_SCCSv204.x), as.character(Hunting_SCCSv204.y)),
    Food_storage_SCCSv20 = coalesce(as.character(Food_storage_SCCSv20.x), as.character(Food_storage_SCCSv20.y)),
    cousin_marriage_recode = coalesce(as.character(cousin_marriage_recode.x), as.character(cousin_marriage_recode.y)),
    domestic_organization_recode = coalesce(as.character(domestic_organization_recode.x), as.character(domestic_organization_recode.y)),
    lineage_organization_recode = coalesce(as.character(lineage_organization_recode.x), as.character(lineage_organization_recode.y)),
    polygamy_recode = coalesce(as.character(polygamy_recode.x), as.character(polygamy_recode.y)),
    community_organization_recode = coalesce(as.character(community_organization_recode.x), as.character(community_organization_recode.y)),
    marital_residence_recode = coalesce(as.character(marital_residence_recode.x), as.character(marital_residence_recode.y)),
    owc_name = coalesce(as.character(owc_name.x), as.character(owc_name.y)),
    sccs_id = coalesce(as.character(sccs_id.x), as.character(sccs_id.y)),
    ea_id = coalesce(as.character(ea_id.x), as.character(ea_id.y))
  )

# Dropping the original duplicate columns
culture_level_data <- culture_level_data %>%
  select(-matches("\\.x$"), -matches("\\.y$"))

culture_level_data <- culture_level_data %>%
  select("owc_name", "owc_id", "sccs_id",
         "Documents", "Region", "Subregion","Subsistence Type",
         "Writing_SCCSv149", "Fixity_residence_SCCSv150", "Agricultre_SCCSv151",
         "Urbanization_SCCSv152", "Labor_specialization_SCCSv153", "Land_transport_SCCSv1554",  "Money_SCCSv155",
         "Density_population_SCCSv156", "Political_integration_SCCSv157", "Social_stratification_SCCSv158", "Hunting_SCCSv204", "Food_storage_SCCSv20",
         "community_organization_recode", "domestic_organization_recode", "marital_residence_recode" , "polygamy_recode",
         "cousin_marriage_recode","lineage_organization_recode"
         )


# Recode the hunting variable
culture_level_data <- culture_level_data %>%
  mutate(Hunting_SCCSv204 = recode(Hunting_SCCSv204,
                                   "0-5% Dependence" = "0",  # Recoding percentage ranges to numeric codes
                                   "6-15%" = "1",
                                   "16-25%" = "2",
                                   "26-35%" = "3",
                                   "36-45%" = "4",
                                   "46-55%" = "5",
                                   "56-65%" = "6",
                                   "66-75%" = "7",
                                   "76-85%" = "8",
                                   "86-100% Dependence" = "9", # Matching earlier coding scheme
                                   .default = Hunting_SCCSv204 # Keep any existing numeric codes unchanged
  ))

# Ensure the result is a factor with levels 0-9 in order
culture_level_data$Hunting_SCCSv204 <- factor(culture_level_data$Hunting_SCCSv204,
                                              levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9"),
                                              ordered = TRUE)


# Add in missing fixity of residence variables (not sure why these are missing here)
sccs_v150_data <- read_csv("data-raw/sccs_V150.csv")
# Mutate the "id" column to create a new "sccs_id" column
sccs_v150_data <- sccs_v150_data %>%
  mutate(sccs_id = sub("^SCCS150-SCCS([0-9]+)-.*$", "\\1", id))

# Mutate the "name" column to "Fixity_residence_SCCSv150" and remove everything after the first space
sccs_v150_data <- sccs_v150_data %>%
  rename(Fixity_residence_SCCSv150 = name) %>%
  mutate(Fixity_residence_SCCSv150 = sub(" .*", "", Fixity_residence_SCCSv150))

# Recode the "Fixity_residence_SCCSv150" variable
sccs_v150_data <- sccs_v150_data %>%
  mutate(Fixity_residence_SCCSv150 = recode(Fixity_residence_SCCSv150,
                                            "Nomadic" = 1,
                                            "Seminomadic" = 2,
                                            "Semisedentary" = 3,
                                            "Sedentary" = 5,
                                            "Sedentary;" = 4 # Recoding "Sedentary;" to "Sedentary; impermanent"
  ))

sccs_v150_data$Fixity_residence_SCCSv150_2 <- as.character(sccs_v150_data$Fixity_residence_SCCSv150)

sccs_v150_data <- sccs_v150_data %>%
  select(sccs_id, Fixity_residence_SCCSv150_2)

# Merge in data
culture_level_data <- left_join(culture_level_data, sccs_v150_data)

culture_level_data$Fixity_residence_SCCSv150 <- coalesce(culture_level_data$Fixity_residence_SCCSv150, culture_level_data$Fixity_residence_SCCSv150_2)

culture_level_data <- culture_level_data %>%
  select(-Fixity_residence_SCCSv150_2)


# Rename dataframes
data_culture <- culture_level_data
data_paragraph <- data_coded


# Create document data frame
raw_data$document_id <- raw_data$docid
data_rawtext <- raw_data %>%
  select(uuid, owc_id, document_id, original_pgno, text)

data_document <- raw_data %>%
  select(owc_id, document_id, author, pubdate, title)


# Read in complexity factor data from Ringen et al methods
complexity_factors_data <- read.csv("data-raw/complexity_factor_scores.csv")

# Deal with arbitrary SCCS numbers
# Create a named vector with OWC names as keys and assigned SCCS IDs as values
sccs_ids <- c(
  "Dogon" = 901,
  "Kanuri" = 902,
  "Shluh" = 903,
  "Libyan Bedouin" = 904,
  "Serbs" = 905,
  "Yakut" = 906,
  "Sinhalese" = 907,
  "Khasi" = 908,
  "Lau Fijians" = 909,
  "Taiwan Hokkien" = 910,
  "Highland Scots" = 911,
  "Bahia Brazilians" = 912,
  "Tlingit" = 913,
  "Blackfoot" = 914,
  "Iroquois" = 915,
  "Hopi" = 916,
  "Tarahumara" = 917,
  "Tzeltal" = 918,
  "Kogi" = 919,
  "Ona" = 920,
  "Mataco" = 921,
  "Bororo" = 922
)

# Only replace where sccs_id is currently 999
data_culture$sccs_id[data_culture$sccs_id == 999] <- sccs_ids[data_culture$owc_name[data_culture$sccs_id == 999]]

data_culture$sccs_id <- as.numeric(data_culture$sccs_id)

# Merge in complexity factor data

data_culture <- left_join(data_culture, complexity_factors_data)

# Computation of the Kinship Intensity Index (Schulz et al. 2018).
# Function to convert character columns with numeric values to numeric
convert_numeric_columns <- function(df) {
  for (col_name in names(df)) {
    # Check if the column is a character vector
    if (is.character(df[[col_name]])) {
      # Try to convert the column to numeric, suppress warnings for non-numeric values
      converted_col <- suppressWarnings(as.numeric(df[[col_name]]))

      # Check if all elements can be coerced to numeric
      if (all(!is.na(converted_col))) {
        # If all elements are numeric, replace the column with the numeric version
        df[[col_name]] <- converted_col
      }
    }
  }
  return(df)
}

# Apply the function to the data frame
data_culture <- convert_numeric_columns(data_culture)


# Compute the co-residence of extended families subdimension - the mean of domestic organization and residence.
data_culture <- data_culture %>%
  mutate(coresidency_ext_families_recode = rowMeans(across(c(domestic_organization_recode, marital_residence_recode)))) %>%
  relocate(coresidency_ext_families_recode, .before = starts_with("polygamy_recode"))

# Select the re-coded subdimensions related to kinship practices, then standardize (z-score) them.
standardized_dim <- data_culture %>%
  select(cousin_marriage_recode, polygamy_recode,
         lineage_organization_recode, community_organization_recode, coresidency_ext_families_recode) %>%
  mutate(across(everything(), scale))

# Compute the standardized mean of these standardized subdimensions to calculate the KII scores.
KII_scores <- as.vector(scale(rowMeans(standardized_dim)))
data_culture <- data_culture %>%
  mutate(KII = KII_scores)


# Combine CSV files in one dplyr pipe
# Function to read each CSV and specify "IDs" as a character
read_csv_as_character <- function(file) {
  read_csv(file, col_types = cols(IDs = col_character()))  # Ensure "IDs" is read as character
}

# Function to ensure all columns are of the same type across datasets
standardize_column_types <- function(df) {
  df %>%
    mutate(across(everything(), as.character))  # Convert all columns to character
}

# Combine CSV files in one dplyr pipe
combined_data <- list.files(path = "data-raw/", pattern = "(?i)ehrafSearch.*\\.csv$", full.names = TRUE) %>%
  map(read_csv_as_character) %>%  # Read each CSV file and treat "IDs" as character
  map(standardize_column_types) %>%  # Standardize all columns to character type
  bind_rows()  # Bind the rows together

# Add additional metadata to raw text data
data_rawtext <- left_join(data_rawtext, combined_data, by = "uuid") %>%
  select(uuid, owc_id, document_id, text, original_pgno, IDs)

# Only need unique documents
data_document <- unique(data_document)

# Remove second culture name
data_culture <- data_culture %>%
  select(-society)

# Load data from Ringen et al analyses
load("data-raw/complex_coev_sccs_UPDATE.RData")

# End
usethis::use_data(data_rawtext, data_paragraph, data_document, data_culture, loadings_df_RI, loadings_df_TSD, overwrite = TRUE)
