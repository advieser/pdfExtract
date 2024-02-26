#' Correct OCR
#'
#' @description
#' Guides the user through correcting outputted words from create_ocr with low
#' confidence scores.
#'
#' @param texts List of data frames from create_ocr with columns c("word", "confidence", "bbox")
#' @param conf_cutoff Numeric of length 1. Must be between 0 und 100. Cutoff value for
#' confidence scores from create_ocr to revisit. Can be seen as a strictness parameter.
#' @returns List of data frames with words corrected by the user

correct_ocr <- function(texts, conf_cutoff = 80) {
  assert_list(texts)
  lapply(texts, function (text_df) {
    checkmate::assert_data_frame(text_df, ncols = 3)
    checkmate::assert_names(names(text_df), identical.to = c("word", "confidence", "bbox"))
  })
  checkmate::assert_number(conf_cutoff, lower = 0, upper = 100)

  # pre-allocate output
  texts_output <- vector("list", length(texts))

  # for each page, show current text and ask for improvement
  for (p in seq_along(texts)) {
    text_df <- texts[[p]]

    # print current suggestion
    base::cat("CURRENT SUGGESTION:\n", text_output)

    # check whether user wants to improve upon this
    repeat {
      ask_improvement <- base::tolower(base::readline("Do you want to improve on this? (y/n) \n"))

      if (ask_improvement == "y") {
        corrected_text_df <- improve_text(text_df = text_df)
        texts_output[[p]] <- corrected_text_df
      } else if (ask_improvement == "n") {
        break  # does this break only the repeat or also the for loop?
      } else {
        base::cat("Not a valid option. Choose \"y\" for Yes or \"n\" for No.\n")
        next
      }
    }
  }
  texts_output
}



improve_text <- function(text_df, conf_cutoff) {
  # get indices with low confidence
  indices_low_conf <- base::which(text_df[["confidence"]] <= conf_cutoff)

  # go through all entries with low confidence
  for (i in indices_low_conf) {
    sorrounding_indices <- get_sorrounding_indices(indices_low_conf, i)
    text_segment <- paste(text_df[sorrounding_indices, "word"][[1]], collapse = " ")

    base::cat("Text:", "\"[...]", text_segment, "[...]\"\n")
    base::cat("Word:", text_df[i, "word"][[1]])
    base::cat("Correction? (\"keep\" to keep current word) \n")
    correct_word <- readline()

    if (!(correct_word == "keep")) {
      text_df[i, "word"][[1]] <- correct_word
    }
  }

  return(text_df)
}



get_sorrounding_indices <- function(vec, start) {
  checkmate::assertIntegerish(vec, lower = 1, any.missing = FALSE)
  checkmate::assertInt(start, lower = 1)

  # Calculate differences
  diffs <- c(1, base::diff(vec))

  # Identify groups by cumulative sum of breaks (difference > 2)
  groups <- base::cumsum(diffs > 2)

  # Find the group of the starting number
  start_group <- groups[vec == start]

  # create vector of sorrounding numbers of start
  res <- if (!base::identical(start_group, integer(0))) {
    vec[groups == start_group]
  } else {
    start
  }

  # extend res by 5 in both directions
  base::seq.int(res[[1]] - 5, res[[length(res)]] + 5)
}
