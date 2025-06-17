# Load necessary packages and data
library(dplyr)
library(caTools)
library(ROCR)

data <- read.csv("data.csv")
data$is_male <- ifelse(data$M.F == 'M', 1, 0)
data$is_alzheimer <- ifelse(data$CDR > 0, 1, 0)
data  = subset(data, select = -c(M.F,CDR,Delay,ID,X))

# Splitting dataset
set.seed(123)
split <- sample.split(data, SplitRatio = 0.1)

train_reg <- subset(data, split == TRUE)
test_reg <- subset(data, split == FALSE)

# Training model with regularization
library(glmnet)
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

# ROC-AUC Curve
ROCPred <- prediction(predict_reg, test_reg$is_alzheimer)
ROCPer <- performance(ROCPred, measure = "tpr", x.measure = "fpr")

auc <- performance(ROCPred, measure = "auc")
auc <- auc@y.values[[1]]

# Plotting ROC curve
par(mar = c(4, 4, 2, 2))
plot(ROCPer, colorize = TRUE, print.cutoffs.at = seq(0.1, by = 0.1), main = "ROC CURVE")
abline(a = 0, b = 1)
auc <- round(auc, 4)
legend(0.6, 0.4, auc, title = "AUC", cex = 1)
