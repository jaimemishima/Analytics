# Forecast
- Técnicas para previsão em séries temporais

## BSTS (Bayesian structural time series)
- Modelo de machine learning usado para seleção de variáveis, previsão em séries temporais, inferir o impacto causal.
- Designado para trabalhar com dados de séries temporais.
- Possui aplicação promissora no campo de *analytical marketing*. Pode ser usado para determinar em quanto diferentes campanhas contribuiram na variação do volume de buscas, vendas de produtos, popularidade de marca, entre outros.
- Descrição do modelo - Composto em 3 partes:
	- Kalman Filter: Decomposição da série temporal (tendência, sazonalidade).
	- Spike-and-Slab: Seleção dos preditores da regressão.
	- Bayesian Model Averaging: Combinar os resultados e cálculo da predição.

## Prophet
- Implementacao em Python para previsão em séries temporais utilizando a API Prophet do Facebook.
- O modelo é decomposto em 3 componentes principais:
	- Tendências (g(t) - mudanças não periódicas)
	- Sazonalidade (s(t) - mudanças periódicas (semanal, anual))
	- Feriados (h(t))
	- Combinados na equação: y(t) = g(t) + s(t) + h(t) + et, onde et é o termo de erro.
- Vantagens
	- Flexibilidade: Acomoda facilmente sazonalidade com múltiplos períodos.
	- ARIMA: os dados medidos não precisam ser esparçados regularmente e não precisa tratar dados faltantes ou remover outliers.