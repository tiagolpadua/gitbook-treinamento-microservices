https://dzone.com/articles/quick-guide-to-microservices-with-spring-boot-20-e

https://pt.wikipedia.org/wiki/Lista_de_livros_mais_vendidos

# Initial page

5 dias

Introdução a arquitetura de microserviços

Spring Cloud

Welcome to the cloud, Spring
Building microservices with Spring Boot
Controlling your configuration with Spring Cloud configuration server
On service discovery
When bad things happen: client resiliency patterns with Spring Cloud and Netflix Hystrix
Service routing with Spring Cloud and Zuul
Securing your microservices
Event-driven architecture with Spring Cloud Stream
Distributed tracing with Spring Cloud Sleuth and Zipkin
Deploying your microservices



## Microserviços

Produtos
    id
    nome
    preco

Clientes
    id
    nome
    endereco

Pedido
    id
    idCliente
    idProduto
    status  

###

Cap 1
Introdução aos MicroServiços

Cap 2
Introdução ao Spring

Cap 3
Introdução ao SpringBoot

Cap 4
Montagem do Ambiente
    Pasta devkit
    Instalar o STS4 - https://spring.io/tools
    Instalar o JDK
    Baixar o Maven e colocar no Path: https://maven.apache.org/download.cgi

Cap 5
Building an Application with Spring Boot
    https://spring.io/guides/gs/spring-boot/

Criar projeto inicial em https://start.spring.io/

Group -> com.example
Atifact -> ProdutoMS
Dependencies -> Web

Fazer download na workspace
Importar no STS

Executar

Acessar localhost:8080

```java
 // OlaController.java
 package com.example.ProdutoMS;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OlaController {

    @RequestMapping("/")
    public String index() {
        return "Olá do Spring Boot!";
    }
}
 ```

 Executar a partir da linha de comandos:
 ```$ mvn package && java -jar target/ProdutoMS-0.0.1-SNAPSHOT.jar```

 Incluindo o Developer Tools para live reload

 https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html



 https://docs.spring.io/spring-boot/docs/current/reference/html/index.html

 

10 dias

Bibliografia
Spring Microservices in Action
redbook ibm microservices from theory to pratice

Bem-vindo à nuvem, primavera
Construindo microsserviços com o Spring Boot
Controlando sua configuração com o servidor de configuração do Spring Cloud
Na descoberta de serviço
Quando coisas ruins acontecem: padrões de resiliência do cliente com Spring Cloud e Netflix Hystrix
Roteamento de serviços com Spring Cloud e Zuul
Protegendo seus microsserviços
Arquitetura orientada a eventos com o Spring Cloud Stream
Rastreamento distribuído com Spring Cloud Sleuth e Zipkin
Implantando seus microsserviços


Spring Cloud

Welcome to the cloud, Spring
Building microservices with Spring Boot
Controlling your configuration with Spring Cloud configuration server
On service discovery
When bad things happen: client resiliency patterns with Spring Cloud and Netflix Hystrix
Service routing with Spring Cloud and Zuul
Securing your microservices
Event-driven architecture with Spring Cloud Stream
Distributed tracing with Spring Cloud Sleuth and Zipkin
Deploying your microservices



https://spring.io/guides/tutorials/bookmarks/
