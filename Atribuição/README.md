# Atribuição

## Introdução
Implementação em R da abordagem markoviana para caminhos de conversão de usuários. Do início de jornada do consumidor até a conversão (ou nã, delimitada por uma lookback window).

## Markov
Código em R para comparar o modelo de Markov com modelos heurísticos. Exportação dos nós e arestas para posterior estudo com o Gephi

## Path Conversion
Código em R para estudo de principais combinações de canais em caminhos de conversão.

```
pathConversion = function(input, n_gram)
```

* Argumentos: 
** input: Dataframe com 3 colunas (paths, quantidade e conversion).
** n_gram: Inteiro que representa o tamanho da quebra dos paths.

* Retorno:
** dataframe com os n_grams, a quantidade e conversões.

## Referências
### https://cran.r-project.org/web/packages/ChannelAttribution/ChannelAttribution.pdf
### https://analyzecore.com/2016/08/03/attribution-model-r-part-1/
### https://www.analyticsvidhya.com/blog/2018/01/channel-attribution-modeling-using-markov-chains-in-r/
