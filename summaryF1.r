
summaryF1 <- function(x_labeled) {
    rowData(x_labeled)$truth <- as.logical(!apply(rowData(x_labeled)$mixture, 1, function(x) sum(x == 1 )))
    confusion_mat <- confusionMatrix(data = as.factor(rowData(x_labeled)$is_mixed), 
                             reference = as.factor(rowData(x_labeled)$truth), 
                             positive = "TRUE")$table
    TN <- confusion_mat[1]
    FP <- confusion_mat[2]
    FN <- confusion_mat[3]
    TP <- confusion_mat[4]
    precision <- TP/(TP + FP)
    recall <- TP/(TP + FN)
    F1_score = (2*precision*recall) / sum(precision, recall)
    f1_results <- data.frame(TN,FP,FN,TP,precision,recall,F1_score)
    return(f1_results)
}
