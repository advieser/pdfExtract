library(checkmate)
library(pdftools)
library(tesseract)

source("source_all.R")

# Show all pdfs in pdf dir
list.files("pdf/", pattern = "*.pdf")
# Select file
file <- file.path("pdf/test3-noocr.ign.pdf")
# Open PDF
system2('open', args = file, wait = FALSE)


# Create OCR
# "deu" for Deutsch, "eng" for English
texts <- create_ocr(file = file, pages = c(1, 2), language = "deu")
convert_dfs_to_text(texts)

# if still errorous, call correct_ocr() to be guided through improving on it
corrected_texts <- correct_ocr(texts)

# function to use on dfs to filter all words from certain areas of the page
# (counterpart to crop, to avoid doubles)

# function to replace all words with low confidence with "" (might be useful sometimes)

# text conversion functions: replace all occurances of "(1: [A-z])- (2: [A-z])"

# crop (maybe for headers, titles, etc.)
crop_text()


# build output list


# construct output text for whole document
# text bodies, page numbering, headers

# Export text to output.txt
outConn <- file("output.txt")
writeLines(text, outConn)
close(outConn)
file.show("output.txt")
# convert to different format if wanted
rmarkdown::pandoc_convert(input = output.txt, output = output.md)
