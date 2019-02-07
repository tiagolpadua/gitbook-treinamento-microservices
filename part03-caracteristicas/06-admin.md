# Admin

O Spring Boot Admin é um aplicativo da Web, usado para gerenciar e monitorar aplicativos Spring Boot. Cada aplicativo é considerado como um cliente e se registra no servidor admin. Nos bastidores, a mágica é feita pelos *end-points* do Spring Boot Actuator.

## Configurações

Podemos utilizar o site do Spring Initializr para realizar a criação de um projeto de admin, para isso, faça as seguintes seleções:

- Group: com.acme
- Artifact: admin
- Dependencies: Spring Boot Admin (Server), Consul Discovery, Actuator

Realizar o download, descopactar o projeto e importá-lo no STS.

O **pom.xml** da aplicação deve estar semelhante ao conteúdo abaixo:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.1.2.RELEASE</version>
		<relativePath /> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.acme</groupId>
	<artifactId>admin</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>admin</name>
	<description>Demo project for Spring Boot</description>

	<properties>
		<java.version>1.8</java.version>
		<spring-boot-admin.version>2.1.1</spring-boot-admin.version>
		<spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>de.codecentric</groupId>
			<artifactId>spring-boot-admin-starter-server</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-config</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-consul-discovery</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-actuator</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
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
			<dependency>
				<groupId>de.codecentric</groupId>
				<artifactId>spring-boot-admin-dependencies</artifactId>
				<version>${spring-boot-admin.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
				<executions>
					<execution>
						<id>build-info</id>
						<goals>
							<goal>build-info</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>

</project>
```

Para o arquivo **AdminApplication.java** devem ser incluídas algumas anotações, conforme abaixo:

```java
package com.acme.admin;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

import de.codecentric.boot.admin.server.config.EnableAdminServer;

@EnableAdminServer
@SpringBootApplication
@EnableDiscoveryClient
public class AdminApplication {

	public static void main(String[] args) {
		SpringApplication.run(AdminApplication.class, args);
	}

}
```

O arquivo **bootstrap.properties** deve ter as configurações padrão das aplicações da cloud:

```
spring.cloud.config.name=admin
spring.profiles.active=default

spring.cloud.config.discovery.serviceId=config-server
spring.cloud.config.fail-fast=true

spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.instanceId=${spring.cloud.config.name}:${random.value}
spring.cloud.consul.discovery.serviceName=${spring.cloud.config.name}

management.endpoints.web.exposure.include=*
```

Por fim, o arquivo **admin.properties** no **config-repo** deve ter as seguintes configurações:

```
server.port=9091
spring.boot.admin.discovery.ignored-services=consul
```

O Consul deve ser ignorado da monitoração uma vez que não conta com os **end-points** do Spring Actuator que são necessários pelo Admin.

Acessando o endereço http://localhost:9091 teremos acesso à administração das instâncias de serviços do Spring Boot em execução.

## Um toque especial em nossas aplicações

Podemos customizar o visual da inicialização de nossa aplicação utilizando um banner customizado, para isso, baixe o arquivo a seguir e coloque-o na pasta `src/main/resources` de suas aplicações https://raw.githubusercontent.com/tiagolpadua/msc-files/master/banner.txt
