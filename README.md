# pdfExtract
## Description
R functions for extracting text from PDFs, mainly for processing them into formats more accessible to blind people.

## Installation


## Loaded packages
- `pdftools` for handling PDFs
- `tesseract` for OCR
- `checkmate` for assertions
- ´data.table´ for efficient data handling (might throw out if not necessary)
- might load `rmarkdown` for pandoc functionality


## Notes
- Finish implementation of `create_ocr`
  - give function parameter to always or never do improvements
  - ask for improvements: show all relevant text bits
  - implement improvement: replace questionable entries with inputs
- think about separate `.R` file for all user input functions
- Implement `crop_text`
  - think about different options, maybe using the graphics device
    - `imagefx`
    - `manipulate` package
- conversion functions for different distance measures for PDFs
- think about creating a `settings.R` for default call options
- `roxygen2` documentation
- ...
- In the far future: attempt to build htmlwidgets environment
- how to handle necessary dependicies from imported packages? (e.g. `png`)
