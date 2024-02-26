# create OCR top level function, calls further
# DOCUMENTATION
#

create_ocr <- function(file, pages = NULL, language = c("deu", "eng")) {
  checkmate::assert_file_exists(file)
  checkmate::assert_integerish(pages, lower = 1, null.ok = TRUE)
  checkmate::assert_string(language)

  # download language modul for tesseract if unaivailable
  if (!(language %in% tesseract_info()[["available"]])) {
    tesseract::tesseract_download(language)
  }

  # get OCR for pages
  pdftools::pdf_ocr_data(pdf = file, pages = pages, language = language)
}
