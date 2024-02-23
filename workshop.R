source("source_all.R")

# Show all pdfs in pdf dir
list.files("pdf/", pattern = "*.pdf")
# Select file
file <- file.path("pdf/test3-noocr.ign.pdf")
# Open PDF
system2('open', args = file, wait = FALSE)


# Create OCR
# "deu" for Deutsch, "eng" for English
create_ocr(file = file, pages = 1, language = "deu")

# crop (maybe for headers, titles, etc.)
crop_text()

# Export text to output.txt
outConn <- file("output.txt")
writeLines(text, outConn)
close(outConn)
file.show("output.txt")

rmarkdown::pandoc_convert(input = output.txt, output = output.md)
