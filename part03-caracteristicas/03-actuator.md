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

