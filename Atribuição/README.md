# Atribuição

## Introdução
Implementação em R da abordagem markoviana para caminhos de conversão de usuários. Do início de jornada do consumidor até a conversão (ou não, delimitada por uma lookback window).

## Markov
Código em R para comparar o modelo de Markov com modelos heurísticos. Exportação dos nós e arestas para posterior estudo com o Gephi

## Shapley Value
Abordagem baseada no conceito da teoria de jogo cooperativo. É uma solução que resolve o problema de dividir o payoff de um jogo entre os jogadores que tiveram uma contribuição desigual. Similar ao cenário de distribuir crédito para uma conversão online entre canais de marketing.

## MTA
Classe desenvolvida pelo Igor Korostil com implementações de multi-touch attribution. Mais detalhes no [github](https://github.com/eeghor/mta). Salvo a matriz de transição do método de markov em um dict com chave 'markov' e ploto a matriz de transição com seaborn.

## Path Conversion
Código em R para estudo das principais combinações de canais em caminhos de conversão.

```
pathConversion = function(input, n_gram)
```

* Argumentos: 
** input: Dataframe com 3 colunas (paths, quantidade e conversion).
** n_gram: Inteiro que representa o tamanho da quebra dos paths.

* Retorno:
** dataframe com os n_grams, a quantidade e conversões.

## Referências
* [ChannelAttribution](https://cran.r-project.org/web/packages/ChannelAttribution/ChannelAttribution.pdf) - Library utilizada
* [Analyzecore](https://analyzecore.com/2016/08/03/attribution-model-r-part-1/) - Exemplo modelo utilizado
* [Analyticsvidhya](https://www.analyticsvidhya.com/blog/2018/01/channel-attribution-modeling-using-markov-chains-in-r/) - Exemplo modelo utilizado
* [DataFeedToolbox](http://datafeedtoolbox.com/attribution-theory-the-two-best-models-for-algorithmic-marketing-attribution-implemented-in-apache-spark-and-r/) - Exemplo modelo Shapley Value
* [MTA Igor Korostil](https://github.com/eeghor/mta)
