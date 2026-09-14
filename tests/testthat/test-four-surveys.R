test_that("the catalog and installation requirements agree for all four surveys", {
  catalog <- endomer_packages()
  depends <- gsub("[[:space:]]+", " ", utils::packageDescription("endomer")$Depends)
  for (i in seq_len(nrow(catalog))) {
    expect_match(depends, paste0(catalog$package[i], " (>= ", catalog$required[i], ")"), fixed=TRUE)
  }
  expect_identical(catalog$repository[catalog$package=="engihr"], "https://github.com/endomer-py/engihr")
})
test_that("ENGIH appears when missing, outdated, absent from an index or still loaded", {
  db <- fixture(); db <- db[db$Package!="engihr", ]
  mock_local(db)
  missing <- endomer_deps(); row <- missing[missing$package=="engihr", ]
  expect_identical(row$status, "not_installed"); expect_identical(row$action, "install")
  mock_local(fixture(c("0.9.0","0.10.0","0.5.0","0.1.0")))
  row <- endomer_deps(); row <- row[row$package=="engihr", ]
  expect_identical(row$status, "below_minimum"); expect_identical(row$action, "update")
  mock_local(loaded=function(package) if(package=="engihr") "0.1.0" else NA_character_)
  row <- endomer_deps(); row <- row[row$package=="engihr", ]
  expect_true(row$restart_required); expect_identical(row$action, "restart_session")
  row <- endomer_deps(available=db); row <- row[row$package=="engihr", ]
  expect_identical(row$status, "unavailable"); expect_true(is.na(row$behind))
  expect_identical(row$action, "resolve_source")
})
test_that("all survey workflows remain usable together with qualified names", {
  enft <- enftr::ft_peri_vars(data.frame(EFT_PERIODO=c("1/2005","2/2005")))
  expect_identical(enft$semestre, c(1L,2L)); expect_true(all(enft$ano==2005))
  encft <- encftr::ftc_factor_expansion_anual(data.frame(FACTOR_EXPANSION=c(100,200)), periods=4)
  expect_identical(encft$factor_expansion_anual, c(25,50))
  ehg <- enhogar::ehg_inactivo(enhogar::enhogar_example(2022), min_edad=10, edition=2022)
  expect_equal(nrow(ehg),12); expect_true(all(ehg$pet==1)); expect_equal(ehg$inactivo[8],1)
  original <- engihr::egi_example()
  labelled <- engihr::egi_set_labels(original, version="baseline-1")
  expect_identical(names(labelled),names(original))
  expect_identical(as.numeric(labelled$A201),original$A201)
  expect_identical(is.na(labelled$A201),is.na(original$A201))
  expect_identical(engihr::egi_dict_versions("b1")$version,c("baseline-1","coverage-2"))
  expect_equal(nrow(engihr::egi_modules()),25)
  expect_true(is.factor(engihr::egi_use_labels(original)$A201))
})
test_that("a single-variable ENGIH revision preserves the other definitions", {
  skip_if_not_installed("RSQLite")
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  on.exit(DBI::dbDisconnect(con))
  original <- engihr::egi_dict("b1",version="baseline-1")
  labeler::db_import_dict_version(con,original)
  draft <- labeler::dict_draft(original)
  draft$FREC_COMPRA_ALIMENTOS$label <- "Frecuencia revisada"
  revised <- engihr::egi_register_dict(con,draft,"review-2",module="b1",parent_version="baseline-1")
  before <- labeler::dict_revision(original)$variable_refs
  after <- labeler::dict_revision(revised)$variable_refs
  unchanged <- setdiff(names(before),"FREC_COMPRA_ALIMENTOS")
  expect_length(unchanged,3L)
  expect_identical(before[unchanged],after[unchanged])
  expect_false(identical(before$FREC_COMPRA_ALIMENTOS,after$FREC_COMPRA_ALIMENTOS))
  loaded <- engihr::egi_dict("b1",version="review-2",con=con)
  expect_identical(labeler::dict_revision(loaded)$content_hash,labeler::dict_revision(revised)$content_hash)
  expect_identical(labeler::dict_revision(engihr::egi_dict("b1"))$version,"coverage-2")
  expect_identical(engihr::egi_dict_versions("b1",con=con)$version,c("baseline-1","review-2"))
})
