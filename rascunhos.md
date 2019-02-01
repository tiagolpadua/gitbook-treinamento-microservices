# Rascunho

https://www.companyweb.com.br/treinamento/metodologias-praticas/design-arquitetural-de-microservico/

https://coderi.com.br/2016/04/14/microsservicos/

https://dzone.com/articles/quick-guide-to-microservices-with-spring-boot-20-e

https://pt.wikipedia.org/wiki/Lista_de_livros_mais_vendidos

## Adicionais

jar de build info

Executando a partir da linha de comandos:

`$ mvn package && java -jar target/ProdutoMS-0.0.1-SNAPSHOT.jar`

## Levantando o ambiente

1 - Verificar se o Redis está ativo -> Windows -> Redis client -> info (porta 6379)
2 - RabbitMQ -> docker-compose up -> http://localhost:15672 (guest/guest)
3 - Consul -> consul.bat -> http://localhost:8500
4 - Prometheus -> prometheus.bat -> http://localhost:9091
5 - Grafana -> grafana.bat -> http://localhost:3000
6 - Config Server - http://localhost:8888
7 - Gateway - http://localhost:9090/livros http://localhost:9090/avaliacoes
8 - livro-service - http://localhost:8080
9 - avaliacao-service - http://localhost:8081

- http://localhost:8080 -> livro-service
- http://localhost:8081 -> avaliacao-service
- http://localhost:8888 -> config-server
- http://localhost:8500 -> Consul
- http://localhost:15672 -> RabbitMQ
- http://localhost:6379 -> Redis (sem interface Web)
- http://localhost:9090 -> Gateway

Exclusão das avaliações após excluir um livro usando RabbitMQ
