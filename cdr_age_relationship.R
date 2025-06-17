# Create a boxplot to visualize the relationship between CDR and Age
print(ggplot(data, aes(as.factor(CDR), Age)) +
        geom_boxplot(col = "darkgreen") +
        labs(title = "Relationship between CDR and Age", x = "CDR") +
        theme(plot.title = element_text(hjust = 0.5)))

summary_table <- data %>%
  group_by(CDR, `M/F`) %>%
  summarise(n = n())

print(summary_table)

table(data$CDR)
data$CDR<-ifelse(data$CDR==2, 1, data$CDR)

# Create a boxplot to visualize the relationship between CDR and Age
ggplot(data, aes(x = as.factor(CDR), y = Age)) +
  geom_boxplot() +
  labs(title = "Degree of CDR by Age", x = "CDR", y = "Age") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))