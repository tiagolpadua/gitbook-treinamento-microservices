# Service Boot Actuator

Em suma, o Actuator traz recursos prontos para produção para o nosso aplicativo.

Monitorar nosso aplicativo, coletar métricas, entender o tráfego ou o estado do nosso banco de dados torna-se trivial com essa dependência.

O principal benefício desta biblioteca é que podemos obter ferramentas de nível de produção sem ter que implementar esses recursos por conta própria.

O Actuator é usado principalmente para expor informações operacionais sobre o aplicativo em execução - saúde, métricas, informações, dump, env etc. Ele usa nós de extremidade HTTP ou JMX para nos permitir interagir com ele.

Uma vez que esta dependência esteja no caminho de classe, vários end-points estarão disponíveis automaticamente. Como na maioria dos módulos Spring, podemos facilmente configurá-lo ou estendê-lo de várias maneiras.

## Iniciando

Para ativar o Spring Boot Actuator, precisamos apenas adicionar a dependência do ```spring-boot-actator``` ao nosso **pom.xml**:

- ```pom.xml```

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

## Habilitando os End-points

O Actuator vem com a maioria dos end-points desativados. Assim, os únicos dois disponíveis por padrão são ```/health``` e ``` /info```.

Se quisermos habilitar todos eles, poderíamos definir na configuração ```management.endpoints.web.exposure.include=*```. Alternativamente, poderíamos listar terminais que deveriam ser habilitados programaticamente.

## End-points predefinidos

Vamos dar uma olhada em alguns end-points disponíveis:

- /auditevents - lista eventos relacionados à auditoria de segurança, como login/logout do usuário;
- /beans - retorna todos os beans disponíveis em nosso BeanFactory;
- /conditions - anteriormente conhecido como /autoconfig, cria um relatório das condições de configuração automática;
- /configprops - nos permite buscar todos os beans ```@ConfigurationProperties```;
- /env - retorna as propriedades atuais do ambiente;
- /flyway - fornece detalhes sobre nossas migrações de banco de dados Flyway;
- /health - resume o status de integridade de nosso aplicativo;
- /heapdump - cria e retorna um dump de heap da JVM usada pelo nosso aplicativo;
- /info - retorna informações gerais. Pode ser dados personalizados, informações de compilação ou detalhes sobre o último commit;
- /liquibase - comporta-se como /flyway mas para Liquibase;
- /logfile - retorna logs comuns de aplicativos;
- /loggers - nos permite consultar e modificar o nível de log do nosso aplicativo;
- /metrics - detalha as métricas do nosso aplicativo;
- /prometheus - retorna métricas como a anterior, mas formatada para funcionar com um servidor Prometheus;
- /scheduledtasks - fornece detalhes sobre cada tarefa agendada dentro do nosso aplicativo;
- /sessions - lista sessões HTTP, uma vez que estamos usando o Spring Session;
- /shutdown - executa um desligamento normal do aplicativo;
- /threaddump - realiza um dump da thread da JVM;

## Habilitando o Spring Boot Actuator em nossa aplicação

Conforme descrito, devemos incluir a depenência ```spring-boot-starter-actuator``` no ```pom.xml``` da aplicação e a configuração ```management.endpoints.web.exposure.include=*``` no arquivo de configuração da aplicação.

Faça estes ajustes, reinicie a aplicação e veja que agora ela está passando nos Health Checks do Consul.

## Ajustando o config-server para se registrar ao Consul

Podemos aproveitar e registrar nosso config server junto ao Consul.

Primeiramente, incluiremos as dependências necessárias:

**pom.xml**

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-consul-discovery</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

Agora, devemos ajustar o arquivo de configuração para que se comunique com o Consul:

**application.properties**

```
server.port=8888

spring.cloud.config.server.git.uri=file:///c:/config-repo
spring.cloud.config.name=config-server

spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
spring.cloud.consul.discovery.serviceName=${spring.cloud.config.name}

management.endpoints.web.exposure.include=*
```

O último passo é adicionar a anotação na classe principal da aplicação:

**ConfigServerApplication.java**

```java
package com.acme.configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
@EnableDiscoveryClient
public class ConfigServerApplication {
	public static void main(String[] args) {
		SpringApplication.run(ConfigServerApplication.class, args);
	}
}
```

Ótimo, agora podemos compilar e iniciar o config-server e consultar no Consul seu status.

Os arquivos de configuração de livro-service devem estar desta maneira:

**bootstrap.properties**

```
spring.cloud.config.name=livro-service
spring.profiles.active=default

spring.cloud.config.uri=http://localhost:8888

spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
spring.cloud.consul.discovery.serviceName=${spring.cloud.config.name}

management.endpoints.web.exposure.include=*
```

**config-repo/livro-service.properties**

```
server.port=8080

spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672

spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

spring.cache.type=redis
spring.cache.redis.time-to-live=5000
spring.redis.host=localhost
spring.redis.port=6379
```

Agora, ao abrir a interface de gerenciamento do Consul (http://localhost:8500/) devem ser listados 3 serviços ativos, ```config-server```, ```consul``` e ```livro-service```.

Porém, se o Consul é um serviço de descoberta, ele não poderia então ser utilizado para que a aplicação ```livro-service``` "descubra" o endereço do ```config-server```?

Se você usar uma implementação do DiscoveryClient, como Spring Cloud Consul, poderá ter o registro do Config Server com o Discovery Service. No entanto, no modo padrão "Config First", os clientes não podem utilizar o registro.

Se você preferir usar o DiscoveryClient para localizar o Config Server. O resultado é que todos os aplicativos clientes precisam de um bootstrap.yml (ou uma variável de ambiente) com a configuração de descoberta apropriada. O preço para usar esta opção é uma ida e volta extra da rede na inicialização, para localizar o registro do serviço. O benefício é que, desde que o Discovery Service seja um ponto fixo, o Config Server pode alterar de endereço. O ID de serviço padrão é configserver, mas você pode alterá-lo no cliente configurando ```spring.cloud.config.discovery.serviceId``` (e no servidor, da maneira usual para um serviço, como definindo ```spring.application.name```) .

Todas as implementações do cliente de descoberta suportam algum tipo de mapa de metadados. Algumas propriedades adicionais do Config Server podem precisar ser configuradas em seus metadados de registro de serviço para que os clientes possam se conectar corretamente. Se o Config Server estiver protegido com o HTTP Basic, você poderá configurar as credenciais como usuário e senha. Além disso, se o Config Server tiver um caminho de contexto, você poderá definir o configPath.

Vamos alterar novamente o arquivo de configuração de ```livro-service```:

**bootstrap.properties**

```
spring.cloud.config.name=livro-service
spring.profiles.active=default

spring.cloud.config.discovery.serviceId=config-server
spring.cloud.config.fail-fast=true

spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
spring.cloud.consul.discovery.serviceName=${spring.cloud.config.name}

management.endpoints.web.exposure.include=*
```

Em alguns casos, você pode querer falhar a inicialização de um serviço se não puder se conectar ao Config Server. Se esse for o comportamento desejado, defina a propriedade de configuração de inicialização como ```spring.cloud.config.fail-fast=true``` para fazer com que o cliente pare com uma Exceção.

Com tudo configurado, nossa aplicação deve estar funcionando normalmente.


## build info

Um toque final que pode ser adicionado é a exposição das informações de build das aplicações através do Actuator, para isso, altere o `pom.xml` 

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>

            <!-- Novidade aqui -->
            <executions>
                <execution>
                    <goals>
                        <goal>build-info</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

Agora construa e execute novamente o projeto, acessando a url `http://localhost:8080/actuator/info` devem estar disponíveis as informações de build.
