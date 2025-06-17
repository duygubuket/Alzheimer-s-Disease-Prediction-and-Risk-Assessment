library(ggplot2)
library(patchwork)

# Extract numeric variable names
numeric_vars <- names(data)[sapply(data, is.numeric)]

# Create histograms for each numeric variable
histograms <- lapply(numeric_vars, function(var) {
  ggplot(data, aes(x = !!as.name(var))) +
    geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") +
    labs(x = var, y = "Frequency") +
    theme_minimal()
})

# Combine histograms using patchwork
combined_histograms <- wrap_plots(histograms, ncol = 3)

# Display combined histograms
print(combined_histograms)
