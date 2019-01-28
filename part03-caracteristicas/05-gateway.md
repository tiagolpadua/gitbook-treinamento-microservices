# Gateway

Em tempos em que centenas de dispositivos interagem com Microserviços e servidores baseado em APIs, um Gateway de APIs pode se ser uma porta de entrada única para a sua arquitetura interna.

Vale lembrar que ter um Gateway de APIs é uma escolha óbvia quando falamos de aumentar segurança, experiência do usuário e facilidade para construção de um ecossistema digital.

## Necessidades

- A granularidade das APIs fornecidas pelos microsserviços é frequentemente diferente do que um cliente precisa. Os microsserviços geralmente fornecem APIs refinadas, o que significa que os clientes precisam interagir com vários serviços. Por exemplo, um cliente que precisa dos detalhes de um produto precisa buscar dados de vários serviços.
- Clientes diferentes precisam de dados diferentes. Por exemplo, a versão do navegador de desktop de uma área de trabalho de página de detalhes do produto é tipicamente mais elaborada do que a versão para celular.
- O desempenho da rede é diferente para diferentes tipos de clientes. Por exemplo, uma rede móvel é normalmente muito mais lenta e tem latência muito maior do que uma rede não móvel. E, claro, qualquer WAN é muito mais lenta que uma LAN. Isso significa que um cliente móvel nativo usa uma rede que possui características de desempenho muito diferentes de uma LAN usada por um aplicativo da Web do lado do servidor. O aplicativo da Web do lado do servidor pode fazer várias solicitações para serviços de back-end sem afetar a experiência do usuário, pois um cliente móvel pode fazer apenas alguns.
- O número de instâncias de serviço e suas localizações (host + porta) muda dinamicamente
- Particionar em serviços pode mudar ao longo do tempo e deve ser escondido dos clientes
- Os serviços podem usar um conjunto diversificado de protocolos, alguns dos quais podem não ser amigáveis ​​para a web

## O que é um API Gateway?

Basicamente, o Gateway é uma interface que recebe as chamadas para seus sistemas internos, sendo uma grande porta de entrada.

Ele pode atuar de cinco diferentes maneiras:

- **Filtro** para o tráfego de chamadas dos diferentes meios (web, mobile, cloud, entre outros);
- **Única porta de entrada** para as diversas APIs que você deseja expor;
- **Componente essencial** do gerenciamento de APIs, como no API Suite;
- **Roteador** do tráfego nas APIs e de Rate Limit;
- **Mecanismo de segurança**, com autenticação, log e muito mais;

O acesso para o Gateway pode ser feito de muitos dispositivos diferentes. Por isso, ele deve possuir o poder de unificar as chamadas feitas e conseguir entregar ao usuário um conteúdo que pode ser acessado de qualquer tipo de navegador e sistema.

![API Gateway](../assets/05-SENSEDIA-api-gateway-visualization-flow-architecture-nordic-apis.png)

## Diferenças entre API Gateway e API Management

Quando a discussão sobre APIs chega no nível de controle e gerenciamento, sempre existem dúvidas quanto a Gateway e Management.

O Gateway é responsável por criar uma **camada sobre suas APIs**, para uma arquitetura unificada.

O Management por sua vez possui um **escopo mais amplo**, pois enquanto o Gateway é responsável pelo "redirecionamento" e filtro de chamadas, uma solução de Management conta com analytics, controle de versão, business data, entre outras coisas.

Sendo assim, o Gateway acaba sendo uma parte da solução mais completa (como o Management), para um controle total de suas APIs.

## Os 6 Benefícios de um API Gateway

Seguem 6 benefícios de se ter um Gateway como a porta de entrada de APIs:

1. Separação de Camada de Aplicação e diferentes requisições: Um dos melhores benefícios dessa camada é que um Gateway consegue separar claramente APIs e microserviços implementados, das pessoas que irão efetivamente utilizar elas.
1. Aumento de simplicidade para o consumidor: Utilizando um Gateway, você consegue mostrar ao seu usuário final um front-end único com sua coleção de APIs, podendo ser muito mais transparente com os usuários da API;
1. Melhoria no desenvolvimento: Separação das funcionalidades e propósitos não apenas faz com que o desenvolvimento dê muito mais foco ao que realmente é necessário, mas também ajuda o servidor a aguentar a demanda de informação pelos serviços utilizados; Por exemplo: um serviço que é chamado poucas vezes durante o dia precisa de menos recursos do que o chamado a toda hora, aproveitando melhor a performance de sua máquina.
1. Buffer Zone contra ataques: Com a utilização de vários serviços independentes e controlados pelo Gateway, qualquer ataque em sua aplicação não irá afetar o seu sistema como um todo, apenas aquele serviço, mantendo tudo funcionando perfeitamente. Isso é a Buffer Zone. Além da segurança, essa estratégia deixa tudo muito mais simples para o usuário, pois todas as outras funcionalidades mantém-se normais, não causando "stress".
1. Dedicação de Serviços em favor de User Experience: Com a estratégia de independência dos serviços das APIs, um desenvolvedor consegue ter toda a documentação necessária para a utilização de maneira muito mais simplificada, podendo otimizar o seu tempo e se dedicando exclusivamente a sua atividade. Deste modo, você consegue ter SDKs de utilização para cada API separadamente de modo a deixar sua documentação o mais específica possível;
1. Log de Atividades antecipando erros: Como todas as chamadas aos seus serviços passarão pelo Gateway, o controle de todas elas é muito simples. Esse tipo de log consegue dar um poder altíssimo para o dono da API. Com ele, é possível achar todos os erros que podem derrubar seu serviço, e até mesmo quem é o responsável por um bom consumo da API. Assim, você consegue prever a quantidade de chamadas possíveis evitando qualquer tipo de problema para o seu usuário.

## Gateways como uma feature de Segurança

No universo das APIs, um dos assuntos mais abordados é sempre a segurança, e possuir um Gateway de APIs é uma das melhores soluções no mercado para conseguir ter o controle integral de sua API.

Digo isso, pois essa ferramenta contempla o chamado CID de forma quase impecável (a sigla em inglês é CIA: Confidentiality, Integrity, Availability).

### Confidencialidade

Ao isolar os servidores que possuem cada tipo de informação do seu sistema utilizando um API Gateway, a confidencialidade dos dados é garantida evitando muitos tipos de ataque em sua aplicação.

Os seus servidores são desenhados e criados para resistir a invasões e manipulação de dados.

Segregando os dados na exposição da API, você consegue criar um estreitamento no caminho da informação, e neste caminho você possui total controle, sabendo até mesmo os dados que irão ser levados como resposta antes mesmo dele deixar seu servidor.

### Integridade

Quando você possui um API Gateway, todos os dados de chamada e de retorno são controlados de forma automática, fazendo com que você possua garantia de que cada request em seu servidor irá ser tratado de forma única.

Deste modo, a integridade dos dados é uma certeza dentro do seu domínio.

### Disponibilidade

Um dos maiores desafios de uma API é a disponibilidade 100%. Esse é um desafio de todo fornecedor de serviços.

Mesmo se sua API não estiver tão suscetível a ataques, os servidores podem sofrer perda de energia, queda da conexão e até erros humanos específicos.

É impossível imunizar totalmente a API, obviamente. Porém, se a sua API for atacada ou sofrer quedas constantes, um API Gateway possui uma segurança excelente, e pode ajudar a aumentar drasticamente sua Disponibilidade.

Você ainda consegue distribuir os seus Gateways perante os servidores dos microserviços, e possuir um roteamento de chamadas tão elaborado que fica praticamente impossível as quedas afetarem e derrubarem a sua API.

## O seu Gateway

Com certeza, um API Gateway é uma das ferramentas no mercado mais efetivas para segurança, controle e desenvolvimento de sua API.

Para um melhor aproveitamento de toda sua estratégia digital, utilizar uma ferramenta como essa lado a lado do conceito de microserviços faz com que sua arquitetura seja totalmente governada e controlada, te levando um passo a frente de seus concorrentes.


## Variação: backend para front-end

Uma variação desse padrão é o padrão Backend for Front-End. Ele define um gateway de API separado para cada tipo de cliente.

![BFFe](../assets/05-bffe.png)

Neste exemplo, existem três tipos de clientes: aplicativo da web, aplicativo móvel e aplicativo externo de terceiros. Existem três gateways de API diferentes. Cada um deles fornece uma API para seu cliente.

## Spring Cloud Gateway

É uma ferramenta que fornece mecanismos de roteamento prontos para uso, geralmente usados em aplicativos de microsserviços, como forma de ocultar vários serviços por trás de uma única fachada.

O Spring Cloud Gateway tem como objetivo fornecer uma maneira simples, mas eficaz, de rotear para APIs e fornecer soluções para questões como segurança, monitoramento/métricas e resiliência.

### Recursos do Spring Cloud Gateway

- Construído no Spring Framework 5, Project Reactor e Spring Boot 2.0;
- Capaz de combinar rotas em qualquer atributo de solicitação;
- Predicados e filtros são específicos para rotas;
- Integração do Circuit Breaker Hystrix;
- Integração Spring Cloud DiscoveryClient
- Fácil de escrever Predicados e Filtros
- Limitação de Request Rate;
- Reescrita de caminho;

### Routing Handler

Com foco em roteamento de solicitações, o Spring Cloud Gateway encaminha solicitações para um *Gateway Handler Mapping*  - que determina o que deve ser feito com solicitações correspondentes a uma rota específica.

Vamos começar com um exemplo rápido de como o *Gateway Handler* resolve as configurações de rota usando o RouteLocator:

```java
@Bean
public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
    return builder.routes()
      .route("r1", r -> r.host("**.baeldung.com")
        .and()
        .path("/baeldung")
        .uri("http://baeldung.com"))
      .route(r -> r.host("**.baeldung.com")
        .and()
        .path("/myOtherRouting")
        .filters(f -> f.prefixPath("/myPrefix"))
        .uri("http://othersite.com")
        .id("myOtherID"))
    .build();
}
```

Observe como usamos os principais blocos de construção desta API:

- **Route** - a API principal do gateway. É definido por uma determinada identificação (ID), um destino (URI) e um conjunto de predicados e filtros;
- **Predicate** - um predicado do Java 8 - que é usado para correspondência de solicitações HTTP usando cabeçalhos, métodos ou parâmetros;
- **Filter** - um WebFilter Spring padrão;

### Dynamic Routing

Assim como o Zuul, o Spring Cloud Gateway fornece meios para rotear solicitações para diferentes serviços.

A configuração de roteamento pode ser criada usando Java puro (RouteLocator) ou usando a configuração de propriedades:

```
spring:
  application:
    name: gateway-service  
  cloud:
    gateway:
      routes:
      - id: baeldung
        uri: baeldung.com
      - id: myOtherRouting
        uri: localhost:9999
```

### Suporte ao Spring Cloud DiscoveryClient

O Spring Cloud Gateway pode ser facilmente integrado às bibliotecas de Service Discovery and Registry, como o Eureka Server e o Consul:

```java
@Configuration
@EnableDiscoveryClient
public class GatewayDiscoveryConfiguration {
  
    @Bean
    public DiscoveryClientRouteDefinitionLocator 
      discoveryClientRouteLocator(DiscoveryClient discoveryClient) {
  
        return new DiscoveryClientRouteDefinitionLocator(discoveryClient);
    }
}
```

### Monitoramento

O Spring Cloud Gateway faz uso da API do Actuator, uma biblioteca bem conhecida do Spring-Boot que fornece vários serviços prontos para monitorar o aplicativo.

Depois que a API do Actuator é instalada e configurada, os recursos de monitoramento do gateway podem ser visualizados acessando endpoint ```/gateway/```.

## Utilizando um Gateway API em nosso projeto

O primeiro passo é importarmos o projeto avaliacoes-service e executá-lo, deste modo, ficaremos com os seguintes serviços executados localmente:

- http://localhost:8080 -> livro-service
- http://localhost:8081 -> avaliacao-service
- http://localhost:8888 -> config-server
- http://localhost:8500 -> Consul
- http://localhost:15672 -> RabbitMQ
- http://localhost:6379 -> Redis (sem interface Web)

Nosso objetivo é disponibilizar nossos microsserviços através de uma única porta, que será nosso API Gateway, deste modo ficaremos com:

- http://localhost:9090/livros -> http://localhost:8080/livros
- http://localhost:9090/avaliacoes -> http://localhost:8080/avaliacoes

### Criando um projeto de Gateway

Acesse https://start.spring.io/, em Group altere para ```com.acme```, em Artifact digite ```gateway``` e nas dependências busque por ```Gateway```, ```Consul Discovery```, ```Config Client``` e ```Actuator```, gere o projeto, faça o download e importe no Spring Tools.

Podemos ajustar as configurações para que o Gateway utilize as configurações armazenadas através do Config Server assim como utilizar o serviço de discovery do Consul para encontrá-lo (como já fizemos com as outras aplicações):

**bootstrap.properties**

```
spring.cloud.config.name=gateway
spring.profiles.active=default

spring.cloud.config.discovery.serviceId=config-server
spring.cloud.config.fail-fast=true

spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
spring.cloud.consul.discovery.serviceName=${spring.cloud.config.name}

management.endpoints.web.exposure.include=*
```

O último passo é criar um arquivo de configurações para nosso gateway no config-repo, neste caso, utilizaremos o formato yml pois existem configurações multivaloradas:

**gateway.yml**

```yml
server:
  port: 9090
  
spring:
  cloud:
    gateway:
      routes:
      - id: livro_service_route
        uri: http://localhost:8080
        predicates:
        - Path=/livros
      - id: avalicacao_service_route
        uri: http://localhost:8081
        predicates:
        - Path=/avaliacoes
    config:
      name: gateway
    consul:
      host: localhost
      port: 8500
      discovery:
        instanceId: ${spring.cloud.config.name}:${random.value}
        serviceName: ${spring.cloud.config.name}

management:
  endpoints:
    web:
      exposure:
        include: "*"
```

Acesse http://localhost:9090/livros e http://localhost:9090/avaliacoes para testar o funcionamento do Gateway.

### Utilizando o Discovery e o Load Balancer

Uma vez que nossos microsserviços já se encontram disponíveis para descoberta no Consul não seria adequado que nosso gateway buscasse esta informação de lá? Isto é possível de ser feito, primeiro, devemos ativar o serviço de cliente de Discovery na classe ```GatewayApplication```:

**GatewayApplication.java**

```java
package com.acme.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
// Novidade aqui
@EnableDiscoveryClient
public class GatewayApplication {
	public static void main(String[] args) {
		SpringApplication.run(GatewayApplication.class, args);
	}
}
```

O segundo passo é ajustar as URLs de nossos microsserviços utilizando o esquema "lb" seguido do nome do serviço ao invés de sua URL:

**gateway.yml**

```yml
server:
  port: 9090
  
spring:
  cloud:
    gateway:
      routes:
      - id: livro_service_route
        # Novidade aqui
        uri: lb://livro-service
        predicates:
        - Path=/livros
      - id: avalicacao_service_route
        # Novidade aqui
        uri: lb://avaliacao-service
        predicates:
        - Path=/avaliacoes
    config:
      name: gateway
    consul:
      host: localhost
      port: 8500
      discovery:
        instanceId: ${spring.cloud.config.name}:${random.value}
        serviceName: ${spring.cloud.config.name}

management:
  endpoints:
    web:
      exposure:
        include: "*"
```

Nosso gateway agora já deve estar funcionando corretamente descobrindo os serviços a partir do Consul.

## Fontes
- https://nordicapis.com/api-gateways-direct-microservices-architecture/
- https://microservices.io/patterns/apigateway.html
- https://www.baeldung.com/spring-cloud-gateway
- https://www.baeldung.com/spring-cloud-gateway-pattern
