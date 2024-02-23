library(checkmate)
library(pdftools)
library(tesseract)
library(data.table)

# create OCR top level function, calls further
# DOCUMENTATION
#

create_ocr <- function(file, pages = NULL, language = c("deu", "eng")) {
  assertFileExists(file)
  assertIntegerish(pages, lower = 1, null.ok = TRUE)
  assertString(language)

  # download language modul for tesseract if unaivailable
  if (!(language %in% tesseract_info()[["available"]])) {
    tesseract::tesseract_download(language)
  }

  # get OCR for pages
  texts <- pdftools::pdf_ocr_data(pdf = file, pages = pages, language = language)

  # for each page, show current text and ask for improvement
  for (p in seq_along(texts)) {
    text_df <- texts[[p]]

    text_output <- paste(text_df[["word"]], collapse = " ")

    # print current suggestion
    cat("CURRENT SUGGESTION:\n\n", text_output)

    # check whether user wants to improve upon this
    repeat {
      ask_improvement <- readline("Do you want to improve on this? (y/n/q) \n")

      if (ask_improvement == "y") {
        text_output <- improve_ocr(text_df = text_df)
        return(text_output)
      } else if (ask_improvement == "n") {
        return(text_output)
      } else if (ask_improvement == "q") {
        next
      } else {
        cat("Not a valid option.\n")
        next
      }
    }
  }
}


# improve
# DOCUMENTATION
# TODO: show all sorrounding misses +-5, then go through every entry

improve_ocr <- function(text_df) {
  setDT(text_df)

  # get indices with low confidence
  indices_low_conf <- which(text_df$confidence < 50)

  # group indices if close together (<=3) for display
  ranges_low_conf

  # go through all entries with low confidence
  for (i in indices_low_conf) {
    text_df[seq.int(i-4, i+5), ]
  }
}
