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

