library(ggplot2)

print(ggplot(data = data, aes(x = Age, fill = factor(`M/F`))) +
  geom_histogram(binwidth = 5, position = "identity", alpha = 0.7) +
  facet_wrap(~`M/F`, ncol = 2) +
  scale_fill_manual(values = c("magenta", "blue")) +
  labs(title = "Age Distribution by Gender") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)))


print(ggplot(data = data, aes(x = factor(`M/F`), fill = factor(`M/F`))) +
  geom_bar() +
  scale_fill_manual(values = c("magenta", "blue")) +
  geom_text(stat = "count", aes(label = ..count..), y = 5, col = "white", fontface = "bold") +
  labs(title = "Count of Males vs Females") +  # Changed title here
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)))


print(ggplot(data = data, aes(x = factor(`M/F`), fill = as.factor(CDR))) +
        geom_bar() +
        ggtitle("Count of Gender by CDR") +
        theme(plot.title = element_text(hjust = 0.5)))