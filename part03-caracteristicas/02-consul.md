# Service Discovery com Consul

A descoberta de serviço é um dos princípios fundamentais de uma arquitetura baseada em microsserviço. Tentar configurar manualmente cada cliente ou alguma forma de convenção pode ser muito difícil de fazer e pode ser muito frágil. A Consul fornece serviços de descoberta de serviços por meio de uma API HTTP e DNS. O Spring Cloud Consul aproveita a API HTTP para registro e descoberta de serviços. Isso não impede que aplicativos que não sejam da Spring Cloud aproveitem a interface do DNS. Os servidores da Consul Agents são executados em um cluster que se comunica por meio de um protocolo gossip (peer-to-peer communication) e usa o protocolo de consenso do Raft.

## Como ativar

Para ativar o Consul Service Discovery, é necessário incluir a dependência ```spring-cloud-starter-consul-discovery```.

## Registrando com o Consul

Quando um cliente se registra no Consul, ele fornece metadados sobre si mesmo, como host e porta, id, nome e tags. Uma verificação HTTP é criada por padrão que o Consul atinge o end-point /health a cada 10 segundos. Se a verificação de integridade falhar, a instância do serviço será marcada como crítica.

Exemplo do cliente Consul:

```java
@SpringBootApplication
@RestController
public class Application {

    @RequestMapping ("/")
    public String home () {
        return "Olá mundo";
    }

    public static void main (String [] args) {
        new SpringApplicationBuilder (Application.class) .web (true) .run (args);
    }

}
```

Se o cliente Consul estiver localizado em algum lugar diferente de localhost:8500, a configuração é necessária para localizar o cliente. Exemplo:

**application.yml.**

```yml
spring:
  cloud:
    consul:
      host: localhost
      port: 8500
```

> Cuidado: Se você usar o Spring Cloud Consul Config, os valores acima precisarão ser colocados em ```bootstrap.yml``` em vez de ```application.yml```.

O nome do serviço padrão, o ID da instância e a porta, obtidos do Ambiente, são ```$ {spring.application.name}```, o Spring Context ID e ```${server.port}``` respectivamente.

Para desativar o Consul Discovery Client, você pode definir ```spring.cloud.consul.discovery.enabled``` como ```false```.

Para desativar o registro de serviço, você pode definir ```spring.cloud.consul.discovery.register``` como ```false```.

## Verificação de Saúde HTTP

A verificação de integridade de uma instância Consul é padronizada como "/health", que é a localização padrão do end-point em um aplicativo Spring Boot Actuator. 

## Iniciando o Consul

Para iniciar uma instância local do Consul, execute o seguinte comando:

```sh
> consul agent -dev -bind=127.0.0.1
```

Você pode verificar se o serviço está operacional consultando o endereço http://localhost:8500

## Adicionando Dependências ao ```pom.xml``` de Nossa Aplicação

Vamos incluir as depenências ```spring-cloud-starter-consul-discovery``` em nosso ```pom.xml```:

- ```pom.xml```

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-consul-discovery</artifactId>
</dependency>
```

Para que nossa aplicação consiga se registrar junto ao Consul ela precisa ter um ID, vamos adicionar mais uma configuração:

**bootstrap.properties**

```
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
```

## Habilitando o Discovery Client

Precisamos incluir a anotação ```@EnableDiscoveryClient``` à classe ```LivroServiceApplication``` para habilitar a aplicação como cliente de um serviço de discovery:

**LivroServiceApplication.java**

```java
// Código anterior omitido

@SpringBootApplication
// Novidade aqui
@EnableDiscoveryClient
public class LivroServiceApplication {
    // Código atual omitido
}
```

Tudo certo, execute agora a aplicação e consulte o status da mesma na tela de gerenciamento do Consul http://localhost:8500, hum, um **Service 'application' check** está com erro, o problema é que não colocamos o Spring Boot Actuator em nossa aplicação, faremos isso em seguida.
