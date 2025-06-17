# Load necessary packages and data
library(dplyr)
library(caTools)
library(ROCR)
library(glmnet)

data <- read.csv("data.csv")
data$is_male <- ifelse(data$M.F == 'M', 1, 0)
data$is_alzheimer <- ifelse(data$CDR > 0, 1, 0)
data  = subset(data, select = -c(M.F,CDR,Delay,ID,X))

# Splitting dataset
set.seed(123)
split <- sample.split(data$is_alzheimer, SplitRatio = 0.1)

train_reg <- subset(data, split == TRUE)
test_reg <- subset(data, split == FALSE)

# Training model with regularization
x <- model.matrix(is_alzheimer ~ ., data = train_reg)[,-1]
y <- as.numeric(train_reg$is_alzheimer) - 1
logistic_model <- glmnet(x, y, family = "binomial")

# Predicting on test set
x_test <- model.matrix(is_alzheimer ~ ., data = test_reg)[,-1]
predict_reg <- predict(logistic_model, s = 0.01, newx = x_test, type = "response")

# Handling extreme probabilities
predict_reg <- pmax(0.01, pmin(0.99, predict_reg))

# Evaluating model accuracy
conf_matrix <- table(test_reg$is_alzheimer, predict_reg > 0.5)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste('Accuracy =', accuracy))

# Print confusion matrix
cat("Confusion Matrix:\n")
print(conf_matrix)

# Calculate class-specific errors
class_errors <- 1 - diag(conf_matrix) / rowSums(conf_matrix)
cat("Class-specific Errors:\n")
print(class_errors)

# ROC-AUC Curve
ROCPred <- prediction(predict_reg, test_reg$is_alzheimer)
ROCPer <- performance(ROCPred, measure = "tpr", x.measure = "fpr")

auc <- performance(ROCPred, measure = "auc")
auc <- auc@y.values[[1]]

# Create ROC curve and Lift chart side by side
par(mfrow = c(1, 2), mar = c(4, 4, 2, 2))

# Plotting ROC curve
plot(ROCPer, colorize = TRUE, print.cutoffs.at = seq(0.1, by = 0.1), main = "ROC Curve")
abline(a = 0, b = 1)
auc <- round(auc, 4)
legend(0.4, 0.3, auc, title = "AUC", cex = 0.75)

# Create Lift Chart
lift_values <- data.frame(Actual = test_reg$is_alzheimer, Predicted = predict_reg)
lift_values <- lift_values[order(-lift_values$Predicted), ]

lift_chart <- cumsum(lift_values$Actual) / sum(test_reg$is_alzheimer)
plot(1:length(lift_chart), lift_chart, type = "l", col = "blue", lwd = 2,
     xlab = "Top N Predictions", ylab = "Cumulative Lift", main = "Lift Chart")

# Add dashed reference line for random model
abline(h = sum(test_reg$is_alzheimer) / length(test_reg$is_alzheimer), col = "red", lwd = 2, lty = 2)

# Add legend
legend("topleft", legend = c("Lift Chart", "Random Model"),
       col = c("blue", "red"), lty = c(1, 2), lwd = 2)
