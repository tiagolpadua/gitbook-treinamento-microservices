# Table of contents

* [Microsserviços](part01-microsservicos/README.md)
    * [Spring](part01-microsservicos/01-spring.md)
    * [Construindo uma aplicação com Spring Boot](part01-microsservicos/02-hello-spring-boot.md)
    * [Entendendo REST](part01-microsservicos/03-rest.md)
    * [Criando um end-point REST](part01-microsservicos/04-end-point-rest.md)
    * [Recuperando um Recurso](part01-microsservicos/05-recuperando-um-recurso.md)
    * [Incluindo um Recurso](part01-microsservicos/06-incluindo-um-recurso.md)
    * [Alterando Recursos](part01-microsservicos/07-alterando-recursos.md)
    * [Persistindo em um Banco de Dados](part01-microsservicos/08-persistindo.md)
    * [Comunicação entre Microsserviços](part01-microsservicos/09-comunicacao.md)
* [RabbitMQ](part02-rabbitmq/README.md)
    * [Principais Conceitos](part02-rabbitmq/01-conceitos.md)
    * [Cadastro de Livro Assíncrono](part02-rabbitmq/02-async-book.md)
    * [Uso em alta disponibilidade (cluster)](part02-rabbitmq/03-ha.md)
* [Características da Arquitetura Orientada a Microsserviço](part03-caracteristicas/README.md)
    * [Config Server](part03-caracteristicas/01-config-server.md)
    * [Service Discovery com Consul](part03-caracteristicas/02-consul.md)
    * [Service Boot Actuator](part03-caracteristicas/03-actuator.md)
    * [Cache com Redis](part03-caracteristicas/04-redis.md)
    * [Gateway](part03-caracteristicas/05-gateway.md)
    * [Admin](part03-caracteristicas/06-admin.md)
* [Design Arquitetural de Microsserviços](part04-design/README.md)
    * [Análise de domínio](part04-design/01-dominio.md)
    * [Identificando limites de microsserviço](part04-design/02-limites.md)
    * [Considerações de dados](part04-design/03-dados.md)
    * [Comunicação entre serviços](part04-design/04-comunicacao.md)
    * [Design de API](part04-design/05-design.md)
    * [Ingestão de dados e fluxo de trabalho](part04-design/06-ingestao.md)
    * [Gateways de API](part04-design/07-gateways.md)
    * [Log e monitoramento](part04-design/08-log.md)
    * [Integração contínua](part04-design/09-integracao.md)
<!-- * [Microsserviços em Container Docker](part05-docker/README.md) -->
* [Implantação e Monitoramento](part06-monitoramento/README.md)
    * [Monitoramento](part06-monitoramento/01-monitoramento.md)
    * [Tolerância a Falhas](part06-monitoramento/02-falhas.md)
    * [Testes](part06-monitoramento/03-testes.md)

<!--

- http://localhost:8080 -> livro-service
- http://localhost:8081 -> avaliacao-service
- http://localhost:8888 -> config-server
- http://localhost:8500 -> Consul
- http://localhost:15672 -> RabbitMQ
- http://localhost:6379 -> Redis (sem interface Web)
- http://localhost:9090 -> Gateway

-->
