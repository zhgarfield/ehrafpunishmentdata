# ehrafpunishmentdata

Paragraph-level coded ethnographic data on punishment from 60 societies in the eHRAF Probability Sample Files (PSF), packaged as an R data package.

## Overview

This package archives the data underlying the manuscript:

> [Author list]. Third-party punishment is common across human societies but varies with socioecology. *Nature Human Behaviour* (in press).

Eight coders independently rated 5,478 ethnographic paragraphs from 60 societies in the eHRAF Probability Sample Files (PSF), producing 11,893 paragraph-level codings of evidence for second-party punishment, third-party punishment, and three subtypes of third-party punishment (kin-directed, partner-directed, generalized). Each paragraph received at least two independent codings.

The package contains six data tables: paragraph-level codings, paragraph-level raw text and metadata, document-level metadata, society-level covariates, and the variable loadings for the two latent socioecological factors (RI and TSD) used as predictors in the analysis.

## Installation

Install from GitHub:

```r
# install.packages("remotes")
remotes::install_github("zhgarfield/ehrafpunishmentdata")
```

Or, from Zenodo:

```r
remotes::install_url("https://zenodo.org/records/[DOI]/files/ehrafpunishmentdata.tar.gz")
```

## Usage

```r
library(ehrafpunishmentdata)

# Paragraph-level codings
head(data_paragraph)

# Paragraph-level text and metadata
head(data_rawtext)

# Document-level metadata
head(data_document)

# Society-level covariates including RI, TSD, and KII
head(data_culture)

# Loadings on the resource-use intensification (RI) factor
loadings_df_RI

# Loadings on the technological and social differentiation (TSD) factor
loadings_df_TSD
```

Roxygen documentation for each table is accessible via R's help system:

```r
?data_paragraph
?data_rawtext
?data_document
?data_culture
?loadings_df_RI
?loadings_df_TSD
```

## Data tables

**`data_paragraph`** — Coder-by-paragraph coding records. One row per coder-paragraph pair. Columns include the unique paragraph identifier (`uuid`), anonymized coder ID (`coder`), six punishment-category outcomes (`secondparty`, `thirdparty`, `thirdparty_kin`, `thirdparty_partner`, `thirdparty_general`, `unspecified`), and an offense-presence indicator (`offense_present`). Each outcome takes one of three values: "Evidence for", "No evidence", or "Evidence against".

**`data_rawtext`** — Paragraph-level text and metadata. One row per paragraph. Columns include the unique paragraph identifier (`uuid`), society identifier (`owc_id`), document identifier (`document_id`), full paragraph text (`text`), original page number (`original_pgno`), and comma-separated OCM subject codes assigned by eHRAF indexers (`IDs`).

**`data_document`** — Document-level metadata. One row per primary ethnographic document. Columns include the society identifier (`owc_id`), document identifier (`document_id`), author, publication date, and title.

**`data_culture`** — Society-level covariates and identifiers. One row per society (n = 60). Columns include society identifiers (`owc_name`, `owc_id`, `sccs_id`), regional and subsistence classifications, SCCS cultural-evolutionary covariates, recoded kinship and residence variables, and the three latent factors used as primary predictors in the manuscript: resource-use intensification (`RI_factor`), technological and social differentiation (`TSD_factor`), and the Kinship Intensity Index (`KII`).

**`loadings_df_RI`** — Per-variable loadings on the resource-use intensification (RI) factor. Reference table for the latent factor stored in `data_culture$RI_factor`.

**`loadings_df_TSD`** — Per-variable loadings on the technological and social differentiation (TSD) factor. Reference table for the latent factor stored in `data_culture$TSD_factor`.

## Joining tables

The four primary tables are joined via three keys:

```
data_paragraph     -- uuid -->        data_rawtext
data_rawtext       -- document_id --> data_document
data_rawtext       -- owc_id -->      data_culture
```

A typical analysis pipeline restricts `data_paragraph` to paragraphs coded by at least two coders and then attaches metadata from the other tables. See the analysis scripts in the manuscript repository for a worked example: [analysis repo URL].

## Data sources

The paragraph text and OCM subject codes derive from the eHRAF World Cultures Probability Sample Files (PSF), accessed via the Human Relations Area Files (https://ehrafworldcultures.yale.edu). The PSF is a stratified sample of 60 societies designed for cross-cultural comparison.

Society-level covariates derive from three sources:

- **Standard Cross-Cultural Sample (SCCS)** (Murdock & White 1969): community size, urbanization, agricultural intensity, political integration, and other society-level cultural-evolutionary variables.
- **Schulz et al. (2019, *Science*)**: Kinship Intensity Index (KII) computed from recoded SCCS kinship variables.
- **Ringen et al. (2019, 2021)**: resource-use intensification (RI) and technological and social differentiation (TSD) latent factors, computed from SCCS variables using the phylogenetic factor-analysis pipeline available at https://github.com/zhgarfield/complex_coev_sccs.

## Coding protocol

Coders were trained on a shared set of operational definitions for each punishment category and rated paragraphs against three discrete options ("Evidence for", "No evidence", "Evidence against"). Operational definitions used in coding:

- **Second-party punishment (2PP)**: enforcement carried out by the victim of the offense or their close kin acting on the victim's behalf.
- **Third-party punishment (3PP)**: enforcement carried out by an individual or institution other than the victim.
- **Kin-directed 3PP**: third-party enforcement by relatives of the victim or offender (e.g., lineage members, extended family).
- **Partner-directed 3PP**: third-party enforcement by exchange partners or in-group affiliates of the offender (e.g., trading partners, age-mates, ritual associates).
- **Generalized 3PP**: third-party enforcement by individuals or institutions with no specific relationship to either party (e.g., chiefs, councils, courts, police, unrelated community members).
- **Unspecified punishment**: punishment whose enforcer cannot be identified from the paragraph text.

Inter-coder reliability was evaluated on a training subset; details are reported in the Supplementary Materials of the manuscript.

## License

[CC BY 4.0 for the data, MIT for the code]

## Citation

If you use this data package, please cite both the package and the underlying manuscript:

```
[Author list]. (under review). Third-party punishment is common across human societies but varies with socioecology. *Nature Human Behaviour*.

Garfield, Z. H. (2026). ehrafpunishmentdata: Paragraph-level coded ethnographic data on punishment from 60 societies (Version X.Y.Z) [R package]. https://github.com/zhgarfield/ehrafpunishmentdata
```

For the SCCS-derived predictors, please also cite:

- Ringen, E. J., Duda, P., & Jaeggi, A. V. (2019). The evolution of daily food sharing: A Bayesian phylogenetic analysis. *Evolution and Human Behavior*, 40(4), 375–384.
- Ringen, E. J., et al. (2021). Novel phylogenetic methods reveal that resource-use intensification drives the evolution of "complex" societies. [Add full citation.]
- Schulz, J. F., Bahrami-Rad, D., Beauchamp, J. P., & Henrich, J. (2019). The Church, intensive kinship, and global psychological variation. *Science*, 366(6466), eaau5141.

## Contact

Corresponding author: Zachary H. Garfield (zachary.garfield@um6p.ma; zhgarfield@gmail.com)

For questions, bug reports, or contributions, please open an issue: https://github.com/zhgarfield/ehrafpunishmentdata/issues

## Acknowledgments

We thank the eight coders who contributed to this project. The eHRAF World Cultures database is maintained by the Human Relations Area Files at Yale University.
