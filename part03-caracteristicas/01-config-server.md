# Config Server

Ao desenvolver um aplicativo em nuvem, um problema é manter e distribuir a configuração para nossos serviços. Nós realmente não queremos perder tempo configurando cada ambiente antes de dimensionar nosso serviço horizontalmente ou arriscar violações de segurança embutindo a configuração em nosso aplicativo.

Para resolver isso, vamos consolidar toda a nossa configuração em um único repositório Git e conectá-lo a um aplicativo que gerencia uma configuração para todos os nossos aplicativos.

O Spring Cloud Config Server fornece uma API baseada em recursos HTTP para configuração externa (pares nome-valor ou conteúdo YAML equivalente). O servidor pode ser incorporado em um aplicativo Spring Boot, usando a anotação ```@EnableConfigServer```. Consequentemente, a seguinte aplicação é um servidor de configuração:

**ConfigServer.java**

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServer {
  public static void main(String[] args) {
    SpringApplication.run(ConfigServer.class, args);
  }
}
```

Como todos os aplicativos Spring Boot, ele é executado na porta 8080 por padrão, mas você pode alterná-lo para a porta 8888 mais convencional de várias maneiras. O mais fácil, que também define um repositório de configuração padrão, é executá-lo com ```spring.config.name=configserver``` (há um configserver.yml no jar do Config Server). 
Outra forma é usar seu próprio ```application.properties```, conforme mostrado no exemplo a seguir:

**application.properties**
```
server.port: 8888
spring.cloud.config.server.git.uri: file://${user.home}/config-repo
```

Onde ```${user.home}/config-repo``` é um repositório git contendo arquivos YAML e de propriedades.

A listagem a seguir mostra uma receita para criar o repositório git no exemplo anterior:

```sh
$ cd $HOME
$ mkdir config-repo
$ cd config-repo
$ git init .
$ echo info.foo: bar > application.properties
$ git add -A .
$ git commit -m "Add application.properties"
```

> Usar o sistema de arquivos local para o seu repositório git é destinado apenas para teste. Você deve usar um servidor para hospedar seus repositórios de configuração em produção.

> O clone inicial do seu repositório de configuração pode ser rápido e eficiente se você mantiver apenas arquivos de texto nele. Se você armazenar arquivos binários, especialmente os grandes, poderá ocorrer atrasos na primeira solicitação de configuração ou encontrar erros de falta de memória no servidor.

## Repositório de Ambiente

Onde você deve armazenar os dados de configuração para o Config Server? A estratégia que rege esse comportamento é o ```EnvironmentRepository```, servindo objetos ```Environment```. Este ambiente é uma cópia superficial do domínio do Spring Environment (incluindo *propertySources* como o recurso principal). Os recursos do ambiente são parametrizados por três variáveis:

- ```{application}```, que mapeia para ```spring.application.name``` no lado do cliente;
- ```{profile}```, que mapeia para ```spring.profiles.active``` no cliente (lista separada por vírgulas);
- ```{label}```, que é um recurso do lado do servidor que rotula um conjunto "versionado" de arquivos de configuração;

As implementações de repositório geralmente se comportam como um aplicativo Spring Boot, carregando arquivos de configuração de um ```spring.config.name``` igual ao parâmetro ```{application}``` e ```spring.profiles.active``` igual ao parâmetro ```{profiles}```. As regras de precedência para perfis também são as mesmas de um aplicativo Spring Boot regular: Perfis ativos têm precedência sobre padrões e, se houver vários perfis, o último ganha (semelhante à inclusão de entradas em um Mapa).

O seguinte aplicativo cliente de amostra possui esta configuração de autoinicialização:

**bootstrap.yml**

```yml
spring:
  application:
    name: foo
  profiles:
    active: dev,mysql
```

> Como de costume com um aplicativo Spring Boot, essas propriedades também podem ser definidas por variáveis ​​de ambiente ou argumentos de linha de comando.

Se o repositório for baseado em arquivo, o servidor criará um ```Environment``` a partir de ```application.yml``` (compartilhado entre todos os clientes) e ```foo.yml``` (com ```foo.yml``` tomando precedência). Se os arquivos YAML tiverem documentos dentro deles que apontam para perfis Spring, eles serão aplicados com precedência mais alta (na ordem dos perfis listados). Se houver arquivos YAML (ou propriedades) específicos do perfil, eles também serão aplicados com maior precedência do que os padrões. Uma precedência mais alta se traduz em um ```PropertySource``` listado anteriormente no ambiente. (Essas mesmas regras se aplicam em um aplicativo de inicialização Spring Boot standalone).

Você pode definir spring.cloud.config.server.accept-empty como false para que o servidor retorne um status HTTP 404, se o aplicativo não for encontrado. Por padrão, esse sinalizador é definido como true.

## Git Backend

A implementação padrão do ```EnvironmentRepository``` usa um backend do Git, que é muito conveniente para gerenciar upgrades e ambientes físicos e para alterações de auditoria. Para alterar a localização do repositório, você pode definir a propriedade de configuração ```spring.cloud.config.server.git.uri``` no Config Server (por exemplo, ```application.yml```). Se você configurá-lo com um prefixo ```file```, ele deverá funcionar em um repositório local para que você possa começar de forma rápida e fácil sem um servidor. No entanto, nesse caso, o servidor opera diretamente no repositório local sem cloná-lo. Para escalar o Config Server e torná-lo altamente disponível, você precisa ter todas as instâncias do servidor apontando para o mesmo repositório, portanto, apenas um sistema de arquivos compartilhado funcionaria. Mesmo nesse caso, é melhor usar o protocolo ssh: para um repositório de sistema de arquivos compartilhado, para que o servidor possa cloná-lo e usar uma cópia de trabalho local como um cache.

Essa implementação do repositório mapeia o parâmetro ```{label}``` do recurso HTTP para um rótulo git (ID de commit, nome de branch ou tag).

Para mais opções de backend, consulte https://cloud.spring.io/spring-cloud-config/multi/multi__spring_cloud_config_server.html.

## Montando o Servidor

Primeiramente vamos criar na unidade c: o repositório GIT que conterá as configurações.

```sh
c:\Users\foo>c:
c:\>mkdir config-repo
c:\>cd config-repo
c:\config-repo>git init .
Initialized empty Git repository in c:/config-repo/.git/
```

Agora, importe a pasta criada no Spring Tools para facilitar nosso trabalho: File -> Import -> General -> Projects from Folder or Archive e selecione a pasta que acabou de criar.

Para montar o servidor de fato, acesse https://start.spring.io/ , em Group altere para ```com.acme```, em Artifact digite ```config-server``` e nas dependências busque por "Config Server", gere o projeto, faça o download e importe no Spring Tools.

Ajuste o arquivo **application.properties** com os seguintes valores:

**application.properties**

```
server.port=8888
spring.cloud.config.server.git.uri=file:///c:/config-repo
```

Ajuste o arquivo **ConfigServerApplication.java** incluindo a anotação ```@EnableConfigServer```:

**ConfigServerApplication.java**

```java
package com.acme.configserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(ConfigServerApplication.class, args);
	}
}
```

Como este servidor não tem nenhuma página é interessante adicionar um arquivo de ```index.html``` em ```/src/main/resources/static/index.html``` para que possamos identificar se está ele está "no ar":

**index.html**

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Config Server</title>
</head>
<body>
	<h1>Config Server</h1>
</body>
</html>
```

Inicie o servidor e acesse o endereço http://localhost:8888, a página criada deve ser exibida.

## Copiando as configurações de livro-service para o repositório de configurações

Mova o arquivo ```application.properties``` do projeto **livro-service** para a pasta do repositório de configurações - ```config-repo``` e renomeie para ```livro-service.properties```.

Não se esqueça de comitar as alterações no repositório:

```sh
c:\config-repo>git add .
c:\config-repo>git commit -m "configurações"
```

Agora, acesse a URL http://localhost:8888/livro-service/default e verifique que as configurações da aplicação estão disponíveis para consulta.

## Spring Cloud Config Client

Um aplicativo Spring Boot pode aproveitar imediatamente o Spring Config Server (ou outras fontes de propriedades externas fornecidas pelo desenvolvedor do aplicativo). Ele também ganha alguns recursos úteis adicionais relacionados a eventos de mudança do ambiente.

O comportamento padrão de qualquer aplicativo que tenha o Spring Cloud Config Client no classpath é o seguinte: Quando um Config Client é iniciado, ele se conecta ao Config Server (por meio da propriedade de configuração bootstrap ```spring.cloud.config.uri```) e inicializa o Spring Environment com fontes de propriedades remotas.

O resultado é que todos os aplicativos clientes que desejam consumir o Config Server precisam de um bootstrap.properties (ou uma variável de ambiente) com o endereço do servidor definido em ```spring.cloud.config.uri``` (o padrão é "http://localhost:8888").

## Adicionando Dependências ao ```pom.xml``` de Nossa Aplicação

Vamos incluir as depenências ```spring-cloud-starter-config``` em nosso ```pom.xml```, também será necessário incluir o gerenciador de dependências ```spring-cloud-dependencies``` e a propriedade ```spring-cloud.version```:

- ```pom.xml```

```xml
  <!-- Código anterior omitido -->

    <properties>
        <java.version>1.8</java.version>
        <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
    </properties>

    <dependencies>
        
        <!-- Dependências atuais omitidas -->

        <dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-config</artifactId>
		</dependency>
    </dependencies>

	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>
  <!-- Código posterior omitido -->
```

Precisamos também criar o arquivo ```/src/main/resources/bootstrap.properties``` que conterá o endereço do servidor de configuração utilizado, o profile atual e o nome da aplicação:

**bootstrap.properties**
```
spring.cloud.config.name=livro-service
spring.cloud.config.uri=http://localhost:8888
spring.profiles.active=default
```

Para temos certeza de que nossa configuração está sendo corretamente lida do Config Server, crie uma cópia arquivo **livro-service.properties** na pasta **config-repo** com o nome **livro-service-qa.properties** e, neste arquivo, inclua uma configuração de porta diferente para nossa aplicação: ```server.port=9090```

Por fim, altere o arquivo de bootstrap de livro-servide para o profile ```qa``` e veja se a aplicação subirá agora com a porta 9090:

**bootstrap.properties**
```
spring.cloud.config.name=livro-service
spring.cloud.config.uri=http://localhost:8888
spring.profiles.active=qa
```

## Fontes

- https://www.baeldung.com/spring-cloud-bootstrapping
- https://cloud.spring.io/spring-cloud-config/multi/multi__spring_cloud_config_server.html

<!-- 

https://docs.pivotal.io/spring-cloud-services/1-5/common/client-dependencies.html

-->
