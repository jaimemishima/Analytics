install.packages('stringr')
install.packages('tokenizers')
install.packages("plyr")
install.packages("dplyr")
library(plyr)
library(dplyr)


pathConversion = function(input, n_gram){
  # Computa a quebra dos paths no tamanho n_gram
  # 
  # Args:
  # 
  #   input: Dataframe com 3 colunas (paths, quantidade e conversion)
  #   n_gram: Inteiro que representa o tamanho da quebra dos paths
  #
  # Returns:
  #   Um dataframe com os n_grams, a quantidade e conversões
  df=input
  df$paths <- gsub(' ', '_', df$paths)
  df$paths <- gsub('_>_', ' > ', df$paths)
  library(stringr)
  library(tokenizers)
  paths=c(0,0)
  quantidade=c(0,0)
  conversion=c(0,0)
  
  # Para cada linha do dataframe
  for (i in 1:nrow(df)){
    # Salva o tamanho do caminho antes do append para calculo posterior do tamanho adicionado
    t0 = length(paths)
    # Trata caminho maior que o n_gram
    if(str_count(df[[i,1]], ">")>(n_gram-1)){
      paths=append(paths, as.array(tokenize_ngrams(as.character(df[[i,1]]), n=n_gram)[[1]]))
    }
    # Trata caminho menor que o n_gram
    else{
      paths=append(paths, as.array(tokenize_ngrams(as.character(df[[i,1]]), n=str_count(df[[i,1]], ">")+1)[[1]]))
    }
    # Calcula o tamanho que foi adicionado em paths
    t = length(paths) - t0
    # Repete o valor da quantidade para a lista 'quantidade'
    q = rep(df[[i,2]],t)
    quantidade = append(quantidade, q)
    # Repete o valor da conversion para a lista 'conversion'
    c=rep(df[[i,3]],t)
    conversion = append(conversion, c)
  }
  output=data.frame(paths, quantidade, conversion)
  # Agrupa os paths
  output <- aggregate(.~paths, output, sum)
  # Remove a coluna com zero
  output = output[-1,]
  output$paths <- gsub(' ', ' > ', output$paths)
  output$paths <- gsub('_', ' ', output$paths)
  return(output)
}

# Exemplo de uso
# Cria Dataframe de entrada
paths <- c('direct > email marketing > organic','a > b > c > t','g > h')
quantidade <- c(10, 3, 2)
conversion <- c(3, 2, 1)
input <- data.frame(paths, quantidade, conversion)

# Chama a função criada. Saída é um dataframe com a quebra pelos n-grams e a quantidade de paths que contém esse n-gram e as conversões.
output = pathConversion(input,3)
