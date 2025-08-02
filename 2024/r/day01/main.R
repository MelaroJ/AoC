data <- read.delim("input", header = FALSE, sep = "", col.names = c("left", "right")) # nolint: line_length_linter.

data |>
  (\(df) {
    left <- sort(df$left)
    right <- sort(df$right)
    part1 <- sum(abs(left - right))
    message(part1)
  })()

data |>
  (\(df) {
    left_vals <- df$left
    right_counts <- table(df$right)
    part2 <- sum(sapply(left_vals, function(x) {
      count <- right_counts[as.character(x)]
      x * ifelse(is.na(count), 0, count)
    }))
    message(part2)
  })()
