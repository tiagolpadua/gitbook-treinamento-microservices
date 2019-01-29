# Rascunho

https://www.companyweb.com.br/treinamento/metodologias-praticas/design-arquitetural-de-microservico/

https://dzone.com/articles/quick-guide-to-microservices-with-spring-boot-20-e

https://pt.wikipedia.org/wiki/Lista_de_livros_mais_vendidos

## Adicionais

jar de build info

Executando a partir da linha de comandos:

`$ mvn package && java -jar target/ProdutoMS-0.0.1-SNAPSHOT.jar`

## Levantando o ambiente

1 - Verificar se o Redis está ativo -> Windows -> Redis client -> info
2 - RabbitMQ -> docker-compose up -> http://localhost:15672
3 - Consul -> consul.bat -> http://localhost:8500
4 - Prometheus -> prometheus.bat -> http://localhost:9091
5 - Grafana -> grafana.bat -> http://localhost:3000
6 - Config Server
7 - Gateway
8 - livro-service
9 - avaliacao-service

- http://localhost:8080 -> livro-service
- http://localhost:8081 -> avaliacao-service
- http://localhost:8888 -> config-server
- http://localhost:8500 -> Consul
- http://localhost:15672 -> RabbitMQ
- http://localhost:6379 -> Redis (sem interface Web)
- http://localhost:9090 -> Gateway
