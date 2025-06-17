# Alzheimer-s-Disease-Prediction-and-Risk-Assessment


🧠 Project Overview
This project focuses on predictive analysis and risk identification for Alzheimer's disease using machine learning techniques. The primary objectives are to:

Identify whether a person currently has Alzheimer's disease
Predict individuals who may be at risk of developing the disease in the future

Early detection of mild cognitive impairment (MCI), which is the early stage of Alzheimer's disease, is crucial for delaying cognitive decline and implementing timely interventions.
📊 Dataset Information
The dataset contains 436 observations with 12 variables including:
Demographic Variables

ID: Unique identifier for each individual
M/F: Gender (Male/Female)
Hand: Handedness (Right/Left)
Age: Age in years
EDUC: Years of formal education
SES: Socioeconomic status (1-5 scale)

Clinical Variables

MMSE: Mini Mental State Examination score (cognitive assessment)
CDR: Clinical Dementia Rating (0 = no dementia, higher values = more severe)
eTIV: Estimated Total Intracranial Volume
nWBV: Normalized Whole Brain Volume
ASF: Atlas Scaling Factor
Delay: Time delay in data collection

Data Source: Kaggle - Alzheimer's Classification Dataset
🔍 Key Findings
Data Insights

Age Distribution: Mean age of 51.36 years (range: 18-96 years)
Gender Split: 69% female, 31% male
Strong Correlation: Negative correlation between MMSE scores and CDR ratings
Brain Volume: Decreases with age (correlation with nWBV)

Model Performance
ModelAccuracyF1 ScoreAUCRandom Forest89.8%0.920.88K-Nearest Neighbors88.4%--Logistic Regression88.1%--
🛠️ Technologies Used

Programming Language: R
Libraries:

Data manipulation and visualization
Machine learning algorithms
Statistical analysis tools



📈 Methodology
1. Data Preprocessing

Handled missing values using mean imputation
Removed irrelevant features (handedness, delay)
Created binary risk indicator based on CDR scores
Split data: 90% training, 10% testing

2. Feature Engineering

Created new binary feature for Alzheimer's risk (CDR > 0)
Normalized brain volume measurements
Correlation analysis for feature selection

3. Model Implementation
K-Nearest Neighbors (KNN)

K value: 5 (odd number for binary classification)
Strength: Captures complex non-linear relationships
Use case: Effective when similar cases have similar outcomes

Logistic Regression

Strength: High interpretability with odds ratios
Use case: Binary classification with clear feature relationships
Advantage: Easy to understand and explain to medical professionals

Random Forest

Best Performance: Highest accuracy and F1 score
Strength: Handles complex interactions and non-linear relationships
Robustness: Ensemble method reduces overfitting

alzheimer-prediction/
├── data/
│   ├── alzheimer.csv
│   └── alzheimer_data_description.xlsx
├── scripts/
│   ├── clean_data.R
│   ├── data_vis_histograms.R
│   ├── age_by_gender.R
│   └── cdr_age_relationship.R
├── results/
│   ├── model_performance.txt
│   └── visualizations/
└── README.md



🚀 Getting Started
Prerequisites

R (version 4.0 or higher)
Required R packages: readr, ggplot2, dplyr, caret, randomForest

Installation
r# Install required packages
install.packages(c("readr", "ggplot2", "dplyr", "caret", "randomForest"))

# Load the dataset
library(readr)
alzheimer <- read_csv("data/alzheimer.csv")
Running the Analysis

Clone this repository
Install required dependencies
Run the data preprocessing scripts
Execute model training and evaluation
View results and visualizations

📊 Key Visualizations

Correlation Heatmap: Shows relationships between variables
Age Distribution: Histogram of age distribution by gender
CDR vs Age: Boxplot showing cognitive decline by age groups
ROC Curves: Model performance comparison
Feature Importance: Random Forest feature rankings

🎯 Clinical Significance
This project addresses a critical healthcare challenge:

Current Impact: Alzheimer's affects millions globally
Future Projection: Expected to reach 152 million patients by 2050
Early Detection: Can help maintain healthy brain activity and delay progression
Economic Benefit: Reduces healthcare costs through early intervention


Sabancı University 

🔮 Future Improvements

Larger Dataset: More diverse and comprehensive data
Feature Engineering: Additional biomarkers and genetic factors
Deep Learning: Neural networks for complex pattern recognition
Real-time Prediction: Integration with medical imaging systems
Longitudinal Analysis: Tracking disease progression over time

📚 References

Lock, M. (2013). Striving to standardize alzheimer disease. The Alzheimer Conundrum
Yang, Q., Li, X., Ding, X., Xu, F., & Ling, Z. (2022). Deep learning-based speech analysis for alzheimer's disease detection. Alzheimer's Research & Therapy

📄 License
This project is part of an academic research study. Please cite appropriately if using this work.
🤝 Contributing
This project was completed as part of an academic term project. For questions or collaboration opportunities, please contact the team members.

This project demonstrates the application of machine learning techniques in healthcare, specifically focusing on early detection and risk assessment for Alzheimer's disease.
