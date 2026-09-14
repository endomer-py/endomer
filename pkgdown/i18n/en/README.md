# endomer 0.5.0

`endomer 0.5.0` brings together **enftr >= 0.9.0**, **encftr >= 0.10.0**, **enhogar >= 0.5.0** and **engihr >= 0.3.0**. R requires those dependencies when installing the package; `library(endomer)` attaches the four interfaces. The metapackage does not change their calculations or combine questionnaires.

## Included packages

| Package | Survey and scope |
|---|---|
| enftr | Traditional ENFT; semester contracts and historical poverty for 2005–2016 |
| encftr | Continuous ENCFT; indicators and integrated historical SIUBEN ICV |
| enhogar | ENHOGAR 2018 and 2022; indicators and edition-specific dictionaries |
| engihr | ENGIH 2018; 25 modules with documented dictionary coverage |

The metapackage covers these four surveys. labeler and Dmisc are dependencies of their interfaces; it does not attach every project in the ENDOM directory. Each survey retains its methodological limits and dictionary coverage.

## A verifiable workflow

The examples below are invented. They separate ENFT periods, calculate an ENCFT extract weight with an explicit divisor, and calculate ENHOGAR 2022 inactivity. They do not produce national estimates. Use qualified names for shared objects: `enftr::dict`, `encftr::dict` and `engihr::dict` are different dictionaries. For ENGIH, select the module and revision with `engihr::egi_dict()`. Each survey guide explains its preparation and rules.

ENHOGAR 2022 adds five complete ONE REDATAM modules and a combined coverage-2 revision with 603 definitions. ENGIH 2018 offers coverage-2 across 25 modules, with 1700 descriptions of 1702 fields. Provenance distinguishes official dictionary entries, questionnaires and headers; HOLGURA and PERDIDA_TURISMO remain undefined. Both surveys preserve baseline-1.

[Start](articles/endomer.html) · [Version reports](articles/versiones.html) · [Install and deploy](articles/deployment.html) · [Python](articles/python.html) · [Dictionary revisions / Revisiones](articles/diccionarios.html).
