# Construindo uma aplicação com Spring Boot

<!-- https://spring.io/guides/gs/spring-boot/ -->

Começaremos criando o esqueleto e nosso primeiro microsserviço, o microsserviço de livros:

![](../assets/02-livro-service.png)

Fazer o download do arquivo gerado

Extrair em:

```
C:\MSC-DevKit\workspace-spring-tool-suite-4-4.1.0.RELEASE
```

Importar o projeto:

![](../assets/02-file-import.jpg)
![](../assets/02-file-import2.jpg)

Executar o projeto:

![](../assets/02-run-as.jpg)

Acompanhar o log:

![](../assets/02-log.jpg)

Ver se a aplicação foi inicializada em http://localhost:8080 :

![](../assets/02-localhost.png)

## Adicionando um conteúdo estático

Clicar com o botão direiro em src/main/resources/static -> New -> Other... -> HTML File -> index.html

Adicionar o seguinte conteúdo:

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Microsserviço Livros</title>
</head>
<body>
	<h1>Microsserviço de Livros</h1>
</body>
</html>
```

Agora poderemos acessar novamente http://localhost:8080 e ver a página que criamos:

![](../assets/02-livros.png)

## Executando via linha de comandos

Run as -> Maven Install

Via ```cmd``` iniciar o jar com o comando ```java -jar```:

![](../assets/02-java-jar.jpg)

## Construindo um JAR executável

Você pode executar o aplicativo a partir da linha de comando com Gradle ou Maven. Ou você pode criar um único arquivo JAR executável que contém todas as dependências, classes e recursos necessários e executá-lo. Isso facilita o envio, a versão e a implantação do serviço como um aplicativo durante todo o ciclo de vida de desenvolvimento, em diferentes ambientes e assim por diante.

Se você estiver usando o Maven, poderá executar o aplicativo usando ```./mvnw spring-boot:run```. Ou você pode construir o arquivo JAR com o pacote ```./mvnw clean```.

O procedimento irá criar um JAR executável. Você também pode optar por criar um arquivo WAR clássico.

A saída de log é exibida. O serviço deve ficar funcional dentro de alguns segundos.

## Entendendo o projeto base

- ```pom.xml```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

    <!-- Diz ao Maven para incluir as dependências do Spring Boot Starter Kit -->
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.1.2.RELEASE</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>

	<groupId>com.acme</groupId>
	<artifactId>livro-service</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>livro-service</name>
	<description>Demo project for Spring Boot</description>

	<properties>
		<java.version>1.8</java.version>
	</properties>

	<dependencies>

        <!-- Diz ao Maven para incluir as dependências da Web do Spring Boot -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

        <!-- Diz ao Maven para incluir as dependências de testes do Spring Boot -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

    <!-- Diz ao Maven para incluir plugins de maven específicos do Spring para construir e implementar aplicações Spring Boot -->
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

O plugin Spring Boot Maven fornece muitos recursos convenientes:
- Ele coleta todos os jars classpath e cria um jar único e executável, o que torna mais conveniente executar e transportar seu serviço;
- Ele procura o método ```public static void main()``` para sinalizar como uma classe executável;
- Ele fornece um resolvedor de dependência integrado que define o número da versão para corresponder às dependências do Spring Boot. Você pode substituir qualquer versão que desejar, mas será o padrão para o conjunto de versões escolhido do Boot;

- ```src/main/java/com/acme/livroservice/LivroServiceApplication.java```

```java
package com.acme.livroservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/* @SpringBootApplication diz ao framework Spring Boot que esta é a classe de bootstrap para o projeto */
@SpringBootApplication
public class LivroServiceApplication {

	public static void main(String[] args) {

        /* Chamada para iniciar todo o serviço de inicialização do Spring */
		SpringApplication.run(LivroServiceApplication.class, args);
	}

}
```

```@SpringBootApplication``` é uma anotação de conveniência que inclui todos os itens a seguir:
- ```@Configuration``` marca a classe como uma fonte de definições de bean para o contexto do aplicativo;
- ```@EnableAutoConfiguration``` informa ao Spring Boot para começar a adicionar beans com base nas configurações do caminho de classe, outros beans e várias configurações de propriedade;
- Normalmente você adicionaria o ```@EnableWebMvc``` para um aplicativo Spring MVC, mas o Spring Boot o adiciona automaticamente quando vê o ***spring-webmvc*** no classpath. Isso sinaliza o aplicativo como um aplicativo da Web e ativa comportamentos-chave, como a configuração de um ```DispatcherServlet```.
- O ```@ComponentScan``` diz ao Spring para procurar outros componentes, configurações e serviços no pacote livroservice, permitindo que ele encontre os controladores;

O método ```main()``` usa o método ```SpringApplication.run()``` do Spring Boot para iniciar um aplicativo. Você percebeu que não havia uma única linha de XML? Nenhum arquivo ***web.xml*** também. Este aplicativo da web é 100% puro e você não precisa lidar com a configuração de qualquer canal ou infraestrutura.

## Saiba o que você pode fazer com o Spring Boot

O Spring Boot oferece uma maneira rápida de construir aplicativos. Ele analisa seu caminho de classe e os beans que você configurou, faz suposições razoáveis ​​sobre o que está faltando e adiciona-o. Com o Spring Boot, você pode se concentrar mais nos recursos de negócios e menos na infraestrutura.

Por exemplo, no caso do Spring MVC existem vários beans específicos que quase sempre se precisa, e o Spring Boot os adiciona automaticamente. Um aplicativo Spring MVC também precisa de um contêiner de servlet, portanto, o Spring Boot configura automaticamente o Tomcat incorporado.

Este é apenas um exemplo da configuração automática que o Spring Boot fornece. Ao mesmo tempo, o Spring Boot não atrapalha. Isso deixa você no controle com pouco esforço da sua parte.

O Spring Boot não gera código nem faz edições nos seus arquivos. Em vez disso, quando você inicia o aplicativo, o Spring Boot liga dinamicamente os beans e as configurações e os aplica ao contexto do seu aplicativo.

## Inicializando o git na pasta do projeto

```bash
> git init
Initialized empty Git repository in E:/MSC-DevKit/workspace-spring-tool-suite-4-4.1.0.RELEASE/livro-service/.git/
```

Para comitar determinado estado do projeto, faça:

```bash
> git add .
> git commit -am "Mensagem de commit"
```

## Fontes
- https://spring.io/guides/gs/spring-boot/
