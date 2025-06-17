library(readr)
library(dplyr)
library(ggplot2)


data <- read_csv("alzheimer.csv")
dim(data)
str(data)
table(data$Hand)

# Remove the 'Hand' column
data$Hand <- NULL

# Store values of 'Subject.ID' and 'MRI.ID' columns in separate variables
subject_id <- data$Subject.ID
MRI_id <- data$MRI.ID

# Remove 'Subject.ID' and 'MRI.ID' columns
data$Subject.ID <- NULL
data$MRI.ID <- NULL

# Checking for null values in each column
null_counts <- sort(apply(data, 2, function(x) sum(is.na(x))), decreasing = TRUE)
print(null_counts)


table(data$SES)


# List of columns to skip
columns_to_skip <- c("ID", "M/F")

# Loop through each column
for (col_name in setdiff(colnames(data), columns_to_skip)) {
  # Convert "N/A" to NA
  na_positions <- which(data[[col_name]] == "N/A")
  data[[col_name]][na_positions] <- NA
  
  # Convert the column to numeric if it's not already
  if (!is.numeric(data[[col_name]])) {
    data[[col_name]] <- as.numeric(data[[col_name]])
  }
  
  # Calculate the mean of the column (excluding NA values)
  mean_value <- mean(data[[col_name]], na.rm = TRUE)
  
  # Replace NA values with the mean
  data[[col_name]][is.na(data[[col_name]])] <- mean_value
}
write.csv(data, "data.csv", row.names = TRUE)


# Print the updated data
print(data)



