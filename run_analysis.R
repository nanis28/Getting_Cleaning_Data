# Carregando Pacote
library(dplyr) 

# Mudando de directorio
setwd("UCI_data")

# Lendo dados de treino 
x_treino   <- read.table("./train/X_train.txt")
y_treino   <- read.table("./train/Y_train.txt") 
sub_treino <- read.table("./train/subject_train.txt")

# Lendo dados de teste
x_teste   <- read.table("./test/X_test.txt")
y_teste   <- read.table("./test/Y_test.txt") 
sub_teste <- read.table("./test/subject_test.txt")

# Lendo descrição de recursos  
recursos <- read.table("./features.txt") 

# Lendo rotulos de atividade 
atividade_labels <- read.table("./activity_labels.txt") 

# Juntando os dados
x_total   <- rbind("x_treino", "x_teste")
y_total   <- rbind("y_treino", "y_teste") 
sub_total <- rbind("sub_treino", "sub_teste") 

# Mantendo apenas média e desvio padrão
sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", recursos[,2], ignore.case = FALSE),]
x_total      <- x_total[,sel_features[,1]]

# Nome das colunas
colnames(x_total)   <- sel_features[,2]
colnames(y_total)   <- "atividade"
colnames(sub_total) <- "subject"

# Juntando dados final
total <- cbind(sub_total, y_total, x_total)

# Transformando atividade e subject 
total$atividade <- factor(total$atividade, levels = atividade_labels[,1], labels = atividade_labels[,2]) 
total$subject  <- as.factor(total$subject) 

# criar um conjunto de dados organizado independente e resumido a partir do conjunto de dados final 
# com a média de cada variável para cada atividade e cada disciplina.
total_mean <- total %>% group_by(atividade, subject) %>% summarize_all(funs(mean)) 

# exportando resumo dos dados
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
