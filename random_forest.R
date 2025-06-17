# Load necessary packages and data
library(randomForest)
library(ROCR)

data <- read.csv("data.csv")
data$is_male <- ifelse(data$M.F == 'M', 1, 0)
data$is_alzheimer <- ifelse(data$CDR > 0, 1, 0)
data  = subset(data, select = -c(M.F,CDR,Delay))

# Splitting dataset
set.seed(123)
split <- sample.split(data$is_alzheimer, SplitRatio = 0.1)

train_reg <- subset(data, split == TRUE)
test_reg <- subset(data, split == FALSE)

# Training Random Forest model
rf_model <- randomForest(factor(is_alzheimer) ~ ., data = train_reg, ntree = 100)

# Predicting on test set
rf_pred <- predict(rf_model, newdata = test_reg)

# Evaluating model accuracy
conf_matrix <- table(test_reg$is_alzheimer, rf_pred)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste('Accuracy =', accuracy))

# ROC-AUC Curve
ROCPred <- prediction(as.numeric(rf_pred) - 1, test_reg$is_alzheimer)
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
lift_values <- data.frame(Actual = test_reg$is_alzheimer, Predicted = rf_pred)
lift_values <- lift_values[order(-lift_values$Predicted), ]

lift_chart <- cumsum(lift_values$Actual) / sum(test_reg$is_alzheimer)
plot(1:length(lift_chart), lift_chart, type = "l", col = "blue", lwd = 2,
     xlab = "Top N Predictions", ylab = "Cumulative Lift", main = "Lift Chart")

# Add dashed reference line for random model
abline(h = sum(test_reg$is_alzheimer) / length(test_reg$is_alzheimer), col = "red", lwd = 2, lty = 2)

# Add legend
legend("topleft", legend = c("Lift Chart", "Random Model"),
       col = c("blue", "red"), lty = c(1, 2), lwd = 2)

# Creating confusion matrix
conf_matrix <- table(test_reg$is_alzheimer, rf_pred)

# Calculating accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

# Calculating precision, recall, and F1 score
precision <- conf_matrix[2, 2] / sum(conf_matrix[, 2])
recall <- conf_matrix[2, 2] / sum(conf_matrix[2, ])
f1_score <- 2 * (precision * recall) / (precision + recall)

# Printing accuracy, precision, recall, and F1 score
print(paste('Precision =', precision))
print(paste('Recall =', recall))
print(paste('F1 Score =', f1_score))

# Printing confusion matrix
print(conf_matrix)

