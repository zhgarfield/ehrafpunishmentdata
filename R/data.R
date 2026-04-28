#' Paragraph-level coding records
#'
#' Coder-by-paragraph coding records from the eHRAF Probability Sample Files
#' (PSF) ethnographic punishment study. Each row represents one coder's
#' evaluation of one paragraph for one set of punishment categories. Eight
#' coders independently rated 5,478 ethnographic paragraphs from 60 societies,
#' producing 11,893 codings; this table contains all coder-paragraph records.
#' Inferential analyses are restricted to paragraphs coded by at least two
#' coders and to rows with \code{offense_present == 1}, since punishment is
#' only meaningfully coded in the context of a preceding offense.
#'
#' Codings reflect manual review of paragraph text against operational
#' definitions of second-party punishment, third-party punishment, and three
#' subtypes of third-party punishment (kin-directed, partner-directed,
#' generalized). For each category, coders selected one of three values:
#' "Evidence for", "No evidence", or "Evidence against".
#'
#' @format A data frame with 11960 rows and 9 variables:
#' \describe{
#'   \item{\code{uuid}}{Unique paragraph identifier from eHRAF World Cultures.
#'     One uuid corresponds to one paragraph of ethnographic text and may
#'     appear in multiple rows of this table (one per coder).}
#'   \item{\code{coder}}{Anonymized identifier for the coder who produced the
#'     coding record. Eight coders contributed to the project.}
#'   \item{\code{unspecified}}{Coder's evaluation of evidence for unspecified
#'     punishment, defined as punishment whose enforcer (second-party,
#'     third-party, or otherwise) cannot be identified from the paragraph
#'     text. One of "Evidence for", "No evidence", or "Evidence against".}
#'   \item{\code{secondparty}}{Coder's evaluation of evidence for second-party
#'     punishment, defined as enforcement carried out by the victim of the
#'     offense or their close kin acting on the victim's behalf. One of
#'     "Evidence for", "No evidence", or "Evidence against".}
#'   \item{\code{thirdparty}}{Coder's evaluation of evidence for third-party
#'     punishment, defined as enforcement carried out by an individual or
#'     institution other than the victim. One of "Evidence for", "No
#'     evidence", or "Evidence against".}
#'   \item{\code{thirdparty_kin}}{Coder's evaluation of evidence for
#'     kin-directed third-party punishment, defined as third-party
#'     enforcement by relatives of the victim or offender (e.g., lineage
#'     members, extended family). One of "Evidence for", "No evidence", or
#'     "Evidence against".}
#'   \item{\code{thirdparty_partner}}{Coder's evaluation of evidence for
#'     partner-directed third-party punishment, defined as third-party
#'     enforcement by exchange partners or in-group affiliates of the
#'     offender (e.g., trading partners, age-mates, ritual associates).
#'     One of "Evidence for", "No evidence", or "Evidence against".}
#'   \item{\code{thirdparty_general}}{Coder's evaluation of evidence for
#'     generalized third-party punishment, defined as third-party
#'     enforcement by individuals or institutions with no specific
#'     relationship to either party (e.g., chiefs, councils, courts,
#'     police, unrelated community members). One of "Evidence for", "No
#'     evidence", or "Evidence against".}
#'   \item{\code{offense_present}}{Binary indicator (0 or 1) for whether the
#'     paragraph describes an offense, transgression, or rule violation.
#'     Inferential analyses are restricted to rows with
#'     \code{offense_present == 1}.}
#' }
#' @source eHRAF World Cultures Probability Sample Files (PSF), accessed via
#'   the Human Relations Area Files (\url{https://ehrafworldcultures.yale.edu}).
#'   Codings produced by the project team using OCM subject codes 626, 627,
#'   696, and 681-689 to retrieve relevant ethnographic passages.
"data_paragraph"


#' Paragraph-level raw text and metadata
#'
#' Raw ethnographic text and identifiers for every paragraph in the eHRAF
#' Probability Sample Files (PSF) retrieval used in this study. Each row
#' represents one paragraph of text. This table is the source of paragraph
#' text shown to coders and provides the join keys (uuid, owc_id,
#' document_id) that link paragraph-level codings to document- and society-
#' level metadata. The IDs column carries the comma-separated list of OCM
#' (Outline of Cultural Materials) subject codes assigned by eHRAF
#' indexers, used downstream as predictors in the exploratory horseshoe-
#' prior models.
#'
#' @format A data frame with 15380 rows and 6 variables:
#' \describe{
#'   \item{\code{uuid}}{Unique paragraph identifier assigned by eHRAF World
#'     Cultures. Serves as the primary key linking this table to
#'     \code{data_paragraph}.}
#'   \item{\code{owc_id}}{Society identifier in the eHRAF Outline of World
#'     Cultures (e.g., "fx10", "ng06"). Lowercase. Joins to
#'     \code{data_culture$owc_id} to attach society-level covariates.}
#'   \item{\code{document_id}}{Identifier of the primary ethnographic
#'     document containing the paragraph. Joins to
#'     \code{data_document$document_id} to attach document-level metadata.}
#'   \item{\code{text}}{Full paragraph text as displayed to coders during
#'     coding. Sourced verbatim from eHRAF World Cultures.}
#'   \item{\code{original_pgno}}{Page number of the paragraph in the original
#'     ethnographic source document, where recorded.}
#'   \item{\code{IDs}}{Comma-separated list of OCM (Outline of Cultural
#'     Materials) subject codes assigned to the paragraph by eHRAF
#'     indexers. Used in the exploratory OCM analyses to identify
#'     ethnographic content domains co-occurring with each punishment
#'     type.}
#' }
#' @source eHRAF World Cultures Probability Sample Files
#'   (\url{https://ehrafworldcultures.yale.edu}).
"data_rawtext"


#' Document-level metadata for ethnographic sources
#'
#' Bibliographic metadata for the primary ethnographic documents from which
#' paragraphs in the PSF retrieval were drawn. Each row represents one
#' document. Documents are nested within societies (one society may have
#' multiple primary documents) and contain multiple paragraphs (one
#' document contributes many paragraphs to \code{data_rawtext}). The
#' document_id column serves as the join key for attaching document-level
#' metadata to paragraph-level data and as a varying-intercept grouping
#' variable in multilevel models.
#'
#' @format A data frame with 843 rows and 5 variables:
#' \describe{
#'   \item{\code{owc_id}}{Society identifier in the eHRAF Outline of World
#'     Cultures (e.g., "fx10", "ng06"). Lowercase. Joins to
#'     \code{data_culture$owc_id} and \code{data_rawtext$owc_id}.}
#'   \item{\code{document_id}}{Unique identifier for the ethnographic
#'     document. Used as a join key with \code{data_rawtext} and as a
#'     varying-intercept grouping variable in multilevel models to
#'     account for between-document heterogeneity in coding.}
#'   \item{\code{author}}{Author name(s) of the ethnographic source.}
#'   \item{\code{pubdate}}{Publication year of the ethnographic source.}
#'   \item{\code{title}}{Title of the ethnographic source.}
#' }
#' @source eHRAF World Cultures Probability Sample Files
#'   (\url{https://ehrafworldcultures.yale.edu}).
"data_document"


#' Society-level covariates and identifiers
#'
#' Society-level covariates for the 60 societies in the eHRAF Probability
#' Sample Files (PSF), used as predictors and identifiers throughout the
#' analysis pipeline. Each row represents one society. Variables include
#' standard cross-cultural identifiers (OWC, SCCS), regional and subsistence
#' classifications, society-level cultural-evolutionary covariates from the
#' Standard Cross-Cultural Sample (SCCS), recoded kinship and residence
#' variables used to compute the Kinship Intensity Index (KII), and the
#' three latent factors used as primary predictors in the manuscript:
#' resource-use intensification (RI_factor), technological and social
#' differentiation (TSD_factor), and kinship intensity (KII).
#'
#' RI_factor and TSD_factor are computed from SCCS variables using the
#' phylogenetic factor-analysis pipeline of Ringen et al. (2021), via a
#' fork available at
#' \url{https://github.com/zhgarfield/complex_coev_sccs}. KII is computed
#' from recoded kinship variables following Schulz et al. (2019).
#'
#' @format A data frame with 60 rows and 29 variables:
#' \describe{
#'   \item{\code{owc_name}}{Society name as recorded in the eHRAF Outline of
#'     World Cultures (OWC). Used for human-readable society identification
#'     in tables and figures.}
#'   \item{\code{owc_id}}{Society identifier in the eHRAF Outline of World
#'     Cultures (e.g., "fx10", "ng06"). Used as the primary join key
#'     between paragraph-, document-, and society-level data tables, and
#'     as a varying-intercept grouping variable in multilevel models.}
#'   \item{\code{sccs_id}}{Society identifier in the Standard Cross-Cultural
#'     Sample (Murdock & White, 1969), where applicable. Used to link to
#'     SCCS-derived covariates.}
#'   \item{\code{Documents}}{Number of primary ethnographic documents
#'     contributing to the eHRAF retrieval for this society.}
#'   \item{\code{Region}}{Major world region (e.g., "Africa", "South
#'     America"), as classified in eHRAF.}
#'   \item{\code{Subregion}}{Sub-regional classification within Region (e.g.,
#'     "Western Africa", "Andes").}
#'   \item{\code{Subsistence Type}}{Primary subsistence mode (e.g.,
#'     hunter-gatherers, horticulturalists, intensive agriculturalists,
#'     pastoralists).}
#'   \item{\code{Writing_SCCSv149}}{Presence and complexity of writing,
#'     SCCS variable 149.}
#'   \item{\code{Fixity_residence_SCCSv150}}{Fixity of residence, SCCS
#'     variable 150.}
#'   \item{\code{Agricultre_SCCSv151}}{Agricultural intensity, SCCS variable
#'     151. Note: column name retains the original misspelling to preserve
#'     compatibility with downstream code.}
#'   \item{\code{Urbanization_SCCSv152}}{Mean size of local communities,
#'     SCCS variable 152. Used as the community-size (CS) predictor in
#'     multilevel models, after standardization.}
#'   \item{\code{Labor_specialization_SCCSv153}}{Technological and craft
#'     specialization, SCCS variable 153.}
#'   \item{\code{Land_transport_SCCSv1554}}{Land transport methods, SCCS
#'     variable 154. Note: column name contains a typo (1554) preserved to
#'     maintain compatibility with downstream code.}
#'   \item{\code{Money_SCCSv155}}{Presence and complexity of money, SCCS
#'     variable 155.}
#'   \item{\code{Density_population_SCCSv156}}{Population density, SCCS
#'     variable 156.}
#'   \item{\code{Political_integration_SCCSv157}}{Levels of political
#'     integration, SCCS variable 157.}
#'   \item{\code{Social_stratification_SCCSv158}}{Class stratification,
#'     SCCS variable 158.}
#'   \item{\code{Hunting_SCCSv204}}{Dependence on hunting, SCCS variable
#'     204.}
#'   \item{\code{Food_storage_SCCSv20}}{Food storage practices, SCCS
#'     variable 20.}
#'   \item{\code{community_organization_recode}}{Recoded community
#'     organization variable (e.g., kin-based vs non-kin-based community
#'     structure) used as input to the kinship intensity index (KII)
#'     following Schulz et al. (2019).}
#'   \item{\code{domestic_organization_recode}}{Recoded domestic
#'     organization variable (e.g., extended- vs nuclear-family households)
#'     used as input to the KII.}
#'   \item{\code{marital_residence_recode}}{Recoded post-marital residence
#'     pattern (e.g., patrilocal, matrilocal, neolocal) used as input to
#'     the KII.}
#'   \item{\code{coresidency_ext_families_recode}}{Recoded indicator of
#'     extended-family co-residence used as input to the KII.}
#'   \item{\code{polygamy_recode}}{Recoded marriage system (e.g., monogamous
#'     vs polygynous vs polyandrous) used as input to the KII.}
#'   \item{\code{cousin_marriage_recode}}{Recoded cousin marriage practices
#'     used as input to the KII.}
#'   \item{\code{lineage_organization_recode}}{Recoded descent and lineage
#'     system (e.g., patrilineal, matrilineal, bilateral) used as input to
#'     the KII.}
#'   \item{\code{RI_factor}}{Resource-use intensification, a latent factor
#'     summarizing societal investment in agricultural production, food
#'     storage, and resource-use intensification, computed from SCCS
#'     variables using the phylogenetic factor-analysis pipeline of Ringen
#'     et al. (2021). Used as a primary predictor in the manuscript after
#'     within-outcome standardization.}
#'   \item{\code{TSD_factor}}{Technological and social differentiation, a
#'     latent factor summarizing societal investment in occupational
#'     specialization, political integration, and stratification, computed
#'     from SCCS variables using the same pipeline as RI_factor. Used as a
#'     primary predictor in the manuscript after within-outcome
#'     standardization.}
#'   \item{\code{KII}}{Kinship Intensity Index, computed from the recoded
#'     kinship and residence variables in this table following Schulz et
#'     al. (2019, \emph{Science}). Captures intensity of kin-based social
#'     organization, including cousin marriage, polygyny, co-residence,
#'     and lineage organization. Used as a primary predictor in the
#'     manuscript after within-outcome standardization.}
#' }
#' @source eHRAF World Cultures Probability Sample Files
#'   (\url{https://ehrafworldcultures.yale.edu}); Standard Cross-Cultural
#'   Sample (Murdock & White, 1969); Schulz, Bahrami-Rad, Beauchamp, &
#'   Henrich (2019, \emph{Science}); Ringen, Duda, & Jaeggi (2019,
#'   \emph{Evolution and Human Behavior}); Ringen et al. (2021).
"data_culture"


#' Variable loadings on the resource-use intensification (RI) factor
#'
#' Per-variable loadings on the resource-use intensification (RI) latent
#' factor, derived from a phylogenetic factor analysis of Standard
#' Cross-Cultural Sample (SCCS) variables. Loadings indicate the strength
#' and direction of each input variable's contribution to the RI factor
#' score. Higher absolute values denote stronger contributions; positive
#' values indicate that higher input values increase RI, while negative
#' values indicate that higher input values decrease RI.
#'
#' Computed using the phylogenetic factor-analysis pipeline of Ringen et
#' al. (2021), via a fork available at
#' \url{https://github.com/zhgarfield/complex_coev_sccs}. Provided here for
#' reference and reproducibility; the per-society RI scores are stored in
#' \code{data_culture$RI_factor}.
#'
#' @format A data frame with 6 rows and 2 variables:
#' \describe{
#'   \item{\code{variable}}{Name of the input SCCS variable contributing to
#'     the RI factor.}
#'   \item{\code{RI_loading}}{Loading of the input variable on the RI
#'     factor (numeric).}
#' }
#' @source Ringen, Duda, & Jaeggi (2019, \emph{Evolution and Human
#'   Behavior}); Ringen et al. (2021); Standard Cross-Cultural Sample
#'   (Murdock & White, 1969).
"loadings_df_RI"


#' Variable loadings on the technological and social differentiation (TSD)
#' factor
#'
#' Per-variable loadings on the technological and social differentiation
#' (TSD) latent factor, derived from a phylogenetic factor analysis of
#' Standard Cross-Cultural Sample (SCCS) variables. Loadings indicate the
#' strength and direction of each input variable's contribution to the TSD
#' factor score. Higher absolute values denote stronger contributions;
#' positive values indicate that higher input values increase TSD, while
#' negative values indicate that higher input values decrease TSD.
#'
#' Computed using the phylogenetic factor-analysis pipeline of Ringen et
#' al. (2021), via a fork available at
#' \url{https://github.com/zhgarfield/complex_coev_sccs}. Provided here for
#' reference and reproducibility; the per-society TSD scores are stored in
#' \code{data_culture$TSD_factor}.
#'
#' @format A data frame with 6 rows and 2 variables:
#' \describe{
#'   \item{\code{variable}}{Name of the input SCCS variable contributing to
#'     the TSD factor.}
#'   \item{\code{TSD_loading}}{Loading of the input variable on the TSD
#'     factor (numeric).}
#' }
#' @source Ringen, Duda, & Jaeggi (2019, \emph{Evolution and Human
#'   Behavior}); Ringen et al. (2021); Standard Cross-Cultural Sample
#'   (Murdock & White, 1969).
"loadings_df_TSD"
