source("source_all.R")

# Show all pdfs in pdf dir
list.files("pdf/", pattern = "*.pdf")
# Select file
file <- file.path("pdf/test3-noocr.pdf")
# Open PDF
system2('open', args = file, wait = FALSE)


# Create OCR
# "deu" for Deutsch, "eng" for English
create_ocr(file = file, pages = 1, language = "deu")

# crop (maybe for headers, titles, etc.)
# use image to set values, then filter through text
# https://www.rdocumentation.org/packages/imagefx/versions/0.4.1/topics/crop.image
# https://rdrr.io/cran/OpenImageR/man/cropImage.html
# https://r-charts.com/miscellaneous/image-processing-magick/
imgs <- pdf_convert(file, pages = 1)
grid::grid.raster(png::readPNG(imgs))
unlink(imgs)

img_cropped <- imagefx::crop.image(png::readPNG(imgs))
png::writePNG(image = img_cropped$img.crop, target = "img_cropped.png")
grid::grid.raster(img_cropped$img.crop)

# Export text to output.txt
outConn <- file("output.txt")
writeLines(text, outConn)
close(outConn)
file.show("output.txt")

rmarkdown::pandoc_convert(input = output.txt, output = output.md)
