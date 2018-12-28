install.packages("ggthemes")
install.packages("ChannelAttribution")
install.packages("markovchain")
install.packages("visNetwork")
install.packages("ggplot2")
install.packages("magrittr")

library(dplyr) # Para uso do group_by
library(reshape2)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(RColorBrewer)
library(ChannelAttribution) # Para uso da função markov_model
library(markovchain)
library(visNetwork)
library(magrittr)

# Referências:
#   https://cran.r-project.org/web/packages/ChannelAttribution/ChannelAttribution.pdf
#   https://analyzecore.com/2016/08/03/attribution-model-r-part-1/
#   https://www.analyticsvidhya.com/blog/2018/01/channel-attribution-modeling-using-markov-chains-in-r/


# Leitura arquivo de entrada em .csv
# Formato:  
# 3 Colunas: paths, conv e conv_null
# Exemplo: organic > direct > paid search, 5, 10
# Significado: O caminho orgânico, direto e search gerou 5 conversões. esse mesmo caminho também não gerou conversões em 10 ocasiões.
df2 <- read.csv(file="C:/Users/jaime.mishima/Documents/R/Scripts/Bases/pathsSimplified2.csv", fileEncoding="UTF-8", sep=",")


# Modelo de Markov de ordem 1, ou seja, análise dois a dois entre canais
# Argumentos:
# Data:     Dataframe contendo os caminhos e conversões
# var_path: nome da coluna contendo os caminhos
# var_conv: nome da coluna contendo todas as conversões
# sep:      separador entre os canais   

# Saída: uma lista com 3 dataframes
# result:            resultados por canal e conversões
# transition_matrix: dataframe com canal de origem, canal de destino e probabilidade de transição
# removal_effects 
mod2 <- markov_model(df2,
                     var_path = 'path',
                     var_conv = 'conv',
                     var_null = 'conv_null',
                     order = 1,
                     out_more = TRUE) # TRUE indica que ele retorna a probabilidade de transição entre os canais e o removal effects

# Cria dataframe para modelos heurísticos
df_hm <- df2 %>% # "%>%"" funciona semelhante a um pipeline no prompt de comando
  # O mutate serve para ir adicionando novas variáveis ao dataframe
  mutate(channel_name_ft = sub('>.*', '', path), # Substitui tudo que estiver depois do primeiro ">" por um vazio
         channel_name_ft = sub(' ', '', channel_name_ft), # Remove o espaço que sobra
         channel_name_lt = sub('.*>', '', path), # Substitui tudo que estiver antes do último ">" por um vazio
         channel_name_lt = sub(' ', '', channel_name_lt))
# Forma alternativa usando a função da library de ChannelAttribution:
# H <- heuristic_models(df2, 'path', 'conv', var_value = 'conv')


# Agrupamento das conversões pelo canal introdutor
df_ft <- df_hm %>%
  group_by(channel_name_ft) %>% # Agrupa pela coluna channel_name_ft. Semelhante ao pivot de uma pivot_table
  summarise(first_touch_conversions = sum(conv)) %>% # Reduz os valores em um único valor
  ungroup()

# Agrupamento das conversões pelo canal conversor
df_lt <- df_hm %>%
  group_by(channel_name_lt) %>%
  summarise(last_touch_conversions = sum(conv)) %>%
  ungroup()

# Dataframe consolidado por canal: volume de conversões visão introdutora e conversora
h_mod2 <- merge(df_ft, df_lt, by.x = 'channel_name_ft', by.y = 'channel_name_lt')

# Agrupa os modelos heurísticos com o resultado de Markov
all_models <- merge(h_mod2, mod2$result, by.x = 'channel_name_ft', by.y = 'channel_name')
colnames(all_models)[c(1, 4)] <- c('channel_name', 'attrib_model_conversions')


# Vizualização
df_plot_trans <- mod2$transition_matrix

cols <- c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", "#4ab04a", "#ffd73e", "#eec73a",
          "#e29421", "#e29421", "#f05336", "#ce472e")
t <- max(df_plot_trans$transition_probability)

ggplot(df_plot_trans, aes(y = channel_from, x = channel_to, fill = transition_probability)) +
  theme_minimal() +
  geom_tile(colour = "white", width = .9, height = .9) +
  scale_fill_gradientn(colours = cols, limits = c(0, t),
                       breaks = seq(0, t, by = t/4),
                       labels = c("0", round(t/4*1, 2), round(t/4*2, 2), round(t/4*3, 2), round(t/4*4, 2)),
                       guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
  geom_text(aes(label = 100*round(transition_probability, 4)), fontface = "bold", size = 3) +
  theme(legend.position = 'bottom',
        legend.direction = "horizontal",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 15, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
        axis.title.x = element_text(size = 15, face = "bold"),
        axis.title.y = element_text(size = 15, face = "bold"),
        axis.text.y = element_text(size = 12, face = "plain", color = 'black'),
        axis.text.x = element_text(size = 12, color = 'black', angle = 25, hjust = 0.5, vjust = 0.5, face = "plain")) +
  labs(title = "Matriz de Transição", x = "Canal Destino",
       y = "Canal Origem\n", fill = "Probabilidade de Transição", color = "")
#ggtitle("Matriz de Transição")


# Gera dataframe com as Arestas do Grafo
edges <-
  data.frame(
    from = df_plot_trans$channel_from,
    to = df_plot_trans$channel_to,
    label = round(df_plot_trans$transition_probability, 2)*1000
  )

# Gera dataframe com os Nós do Grafo
nodes <- data_frame(id = c( c(df_plot_trans$channel_from), c(df_plot_trans$channel_to) )) %>%
  distinct(id) %>%
  arrange(id)

# Salva os Dataframes gerados em arquivos .csv
write.csv(nodes, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/outputNodes.csv")
write.csv(edges, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/outputEdges.csv")
write.csv(df_hm, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/df.csv")
write.csv(df_plot_trans, file = "C:/Users/jaime.mishima/Downloads/Magazine/Análises/Push/outputMatrix.csv")
###################################################################################
# PARTE D #
# Usando: https://www.analyticsvidhya.com/blog/2018/01/channel-attribution-modeling-using-markov-chains-in-r/

H <- heuristic_models(df2, 'path', 'conv', var_value = 'conv')
M <- markov_model(df2, 'path', 'conv', var_value='conv', order = 1)

# Merges the two data frames on the "channel_name" column.
R <- merge(H, M, by='channel_name')

# Select only relevant columns
R1 <- R[, (colnames(R) %in% c('channel_name', 'first_touch_conversions', 'last_touch_conversions', 'linear_touch_conversions', 'total_conversion'))]

# Transforms the dataset into a data frame that ggplot2 can use to plot the outcomes
R1 <- melt(R1, id='channel_name')

# Plot the total conversions
ggplot(R1, aes(channel_name, value, fill = variable)) +
  geom_bar(stat='identity', position='dodge') +
  ggtitle('TOTAL CONVERSIONS') +
  theme(axis.title.x = element_text(vjust = -2)) +
  theme(axis.title.y = element_text(vjust = +2)) +
  theme(title = element_text(size = 16)) +
  theme(plot.title=element_text(size = 20)) +
  ylab("")

install.packages("ggthemes")
install.packages("ChannelAttribution")
install.packages("markovchain")
install.packages("visNetwork")
install.packages("ggplot2")
install.packages("magrittr")

library(dplyr) # Para uso do group_by
library(reshape2)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(RColorBrewer)
library(ChannelAttribution) # Para uso da função markov_model
library(markovchain)
library(visNetwork)
library(magrittr)

# Referências:
#   https://cran.r-project.org/web/packages/ChannelAttribution/ChannelAttribution.pdf
#   https://analyzecore.com/2016/08/03/attribution-model-r-part-1/
#   https://www.analyticsvidhya.com/blog/2018/01/channel-attribution-modeling-using-markov-chains-in-r/


# Leitura arquivo de entrada em .csv
# Formato:  
# 3 Colunas: paths, conv e conv_null
# Exemplo: organic > direct > paid search, 5, 10
# Significado: O caminho orgânico, direto e search gerou 5 conversões. esse mesmo caminho também não gerou conversões em 10 ocasiões.
df2 <- read.csv(file="C:/Users/jaime.mishima/Documents/R/Scripts/Bases/pathsSimplified2.csv", fileEncoding="UTF-8", sep=",")


# Modelo de Markov de ordem 1, ou seja, análise dois a dois entre canais
# Argumentos:
# Data:     Dataframe contendo os caminhos e conversões
# var_path: nome da coluna contendo os caminhos
# var_conv: nome da coluna contendo todas as conversões
# sep:      separador entre os canais   

# Saída: uma lista com 3 dataframes
# result:            resultados por canal e conversões
# transition_matrix: dataframe com canal de origem, canal de destino e probabilidade de transição
# removal_effects 
mod2 <- markov_model(df2,
                     var_path = 'path',
                     var_conv = 'conv',
                     var_null = 'conv_null',
                     order = 1,
                     out_more = TRUE) # TRUE indica que ele retorna a probabilidade de transição entre os canais e o removal effects

# Cria dataframe para modelos heurísticos
df_hm <- df2 %>% # "%>%"" funciona semelhante a um pipeline no prompt de comando
  # O mutate serve para ir adicionando novas variáveis ao dataframe
  mutate(channel_name_ft = sub('>.*', '', path), # Substitui tudo que estiver depois do primeiro ">" por um vazio
         channel_name_ft = sub(' ', '', channel_name_ft), # Remove o espaço que sobra
         channel_name_lt = sub('.*>', '', path), # Substitui tudo que estiver antes do último ">" por um vazio
         channel_name_lt = sub(' ', '', channel_name_lt))

# Agrupamento das conversões pelo canal introdutor
df_ft <- df_hm %>%
  group_by(channel_name_ft) %>% # Agrupa pela coluna channel_name_ft. Semelhante ao pivot de uma pivot_table
  summarise(first_touch_conversions = sum(conv)) %>% # Reduz os valores em um único valor
  ungroup()

# Agrupamento das conversões pelo canal conversor
df_lt <- df_hm %>%
  group_by(channel_name_lt) %>%
  summarise(last_touch_conversions = sum(conv)) %>%
  ungroup()

# Dataframe consolidado por canal: volume de conversões visão introdutora e conversora
h_mod2 <- merge(df_ft, df_lt, by.x = 'channel_name_ft', by.y = 'channel_name_lt')

# Agrupa os modelos heurísticos com o resultado de Markov
all_models <- merge(h_mod2, mod2$result, by.x = 'channel_name_ft', by.y = 'channel_name')
colnames(all_models)[c(1, 4)] <- c('channel_name', 'attrib_model_conversions')


# Vizualização
df_plot_trans <- mod2$transition_matrix

cols <- c("#e7f0fa", "#c9e2f6", "#95cbee", "#0099dc", "#4ab04a", "#ffd73e", "#eec73a",
          "#e29421", "#e29421", "#f05336", "#ce472e")
t <- max(df_plot_trans$transition_probability)

ggplot(df_plot_trans, aes(y = channel_from, x = channel_to, fill = transition_probability)) +
  theme_minimal() +
  geom_tile(colour = "white", width = .9, height = .9) +
  scale_fill_gradientn(colours = cols, limits = c(0, t),
                       breaks = seq(0, t, by = t/4),
                       labels = c("0", round(t/4*1, 2), round(t/4*2, 2), round(t/4*3, 2), round(t/4*4, 2)),
                       guide = guide_colourbar(ticks = T, nbin = 50, barheight = .5, label = T, barwidth = 10)) +
  geom_text(aes(label = 100*round(transition_probability, 4)), fontface = "bold", size = 3) +
  theme(legend.position = 'bottom',
        legend.direction = "horizontal",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 15, face = "bold", vjust = 2, color = 'black', lineheight = 0.8),
        axis.title.x = element_text(size = 15, face = "bold"),
        axis.title.y = element_text(size = 15, face = "bold"),
        axis.text.y = element_text(size = 12, face = "plain", color = 'black'),
        axis.text.x = element_text(size = 12, color = 'black', angle = 25, hjust = 0.5, vjust = 0.5, face = "plain")) +
  labs(title = "Matriz de Transição", x = "Canal Destino",
       y = "Canal Origem\n", fill = "Probabilidade de Transição", color = "")
#ggtitle("Matriz de Transição")


# Gera dataframe com as Arestas do Grafo
edges <-
  data.frame(
    from = df_plot_trans$channel_from,
    to = df_plot_trans$channel_to,
    label = round(df_plot_trans$transition_probability, 2)*1000
  )

df_plot_trans$channel_from <- as.character(df_plot_trans$channel_from)
df_plot_trans$channel_to <- as.character(df_plot_trans$channel_to)
df_plot_trans$transition_probability <- round(df_plot_trans$transition_probability, 10)

# Gera dataframe com os Nós do Grafo
nodes <- data_frame(id = c( c(df_plot_trans$channel_from), c(df_plot_trans$channel_to) )) %>%
  distinct(id) %>%
  arrange(id)

# Salva os dataframes gerados em arquivos .csv
write.csv(nodes, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/outputNodes.csv")
write.csv(edges, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/outputEdges.csv")
write.csv(df_hm, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/df.csv")
write.csv(df_plot_trans, file = "C:/Users/jaime.mishima/Documents/R/Scripts/Bases/outputMatrix.csv")