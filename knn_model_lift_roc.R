# Load necessary packages and data
library(dplyr)
library(caTools)
library(ROCR)
library(class)  # Load the class package for k-NN

data <- read.csv("data.csv")
data$is_male <- ifelse(data$M.F == 'M', 1, 0)
data$is_alzheimer <- ifelse(data$CDR > 0, 1, 0)
data  = subset(data, select = -c(M.F,CDR,Delay))

# Splitting dataset
set.seed(123)
split <- sample.split(data$is_alzheimer, SplitRatio = 0.1)

train_reg <- subset(data, split == TRUE)
test_reg <- subset(data, split == FALSE)

# Select only the numeric features for scaling
numeric_features <- sapply(train_reg, is.numeric)
scaled_train <- scale(train_reg[, numeric_features])
scaled_test <- scale(test_reg[, numeric_features])

# Training k-NN model
k <- 5  # Choose the number of neighbors
knn_model <- knn(train = scaled_train, test = scaled_test, cl = train_reg$is_alzheimer, k = k)

# Evaluating model accuracy
conf_matrix <- table(test_reg$is_alzheimer, knn_model)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste('Accuracy =', accuracy))

# ROC-AUC Curve
ROCPred <- prediction(as.numeric(knn_model) - 1, test_reg$is_alzheimer)
ROCPer <- performance(ROCPred, measure = "tpr", x.measure = "fpr")

auc <- performance(ROCPred, measure = "auc")
auc <- auc@y.values[[1]]

# Plotting ROC curve and Lift chart side by side
par(mfrow = c(1, 2), mar = c(4, 4, 2, 2))

# Plotting ROC curve
plot(ROCPer, colorize = TRUE, print.cutoffs.at = seq(0.1, by = 0.1), main = "ROC Curve")
abline(a = 0, b = 1)
auc <- round(auc, 4)
legend(0.4, 0.3, auc, title = "AUC", cex = 0.5)

# Create Lift Chart
lift_values <- data.frame(Actual = test_reg$is_alzheimer, Predicted = knn_model)
lift_values <- lift_values[order(-lift_values$Predicted), ]

lift_chart <- cumsum(lift_values$Actual) / sum(test_reg$is_alzheimer)
plot(1:length(lift_chart), lift_chart, type = "l", col = "blue", lwd = 2,
     xlab = "Top N Predictions", ylab = "Cumulative Lift", main = "Lift Chart")

# Add dashed reference line for random model
abline(h = sum(test_reg$is_alzheimer) / length(test_reg$is_alzheimer), col = "red", lwd = 2, lty = 2)

# Add legend
legend("topleft", legend = c("Lift Chart", "Random Model"),
       col = c("blue", "red"), lty = c(1, 2), lwd = 2)
