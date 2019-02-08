# Testes

Uma confusão bastante comum na comunidade de desenvolvimento é justamente sobre qual nome dar para o tipo de teste. **Esse é um teste de unidade, integração ou sistema?** Apesar de parecer uma discussão boba, é importante que desenvolvedores usem os mesmos termos para se comunicar; isso facilita e acelera o entendimento.

Um **teste de unidade** é aquele que testa uma única unidade do sistema. Ele a testa de maneira isolada, geralmente simulando as prováveis dependências que aquela unidade tem. Em sistemas orientados a objetos, é comum que a unidade seja uma classe. Ou seja, quando queremos escrever testes de unidade para a classe Pedido, essa bateria de testes testará o funcionamento da classe Pedido, isolada, sem interações com outras classes.

Um **teste de integração** é aquele que testa a integração entre duas partes do seu sistema. Os testes que você escreve para a sua classe *PedidoDao*, por exemplo, onde seu teste vai até o banco de dados, é um teste de integração. Afinal, você está testando a integração do seu sistema com o sistema externo, que é o banco de dados. Testes que garantem que suas classes comunicam-se bem com serviços web, escrevem arquivos texto, ou mesmo mandam mensagens via socket são considerados testes de integração.

Já um **teste de sistema** garante que o sistema funciona como um todo. Este nível de teste está interessado se o sistema funciona como um todo, com todas as unidades trabalhando juntas. Ele é comumente chamado de teste de caixa preta, já que o sistema é testado “com tudo ligado”: banco de dados, serviços web, batch jobs, e etc. Os **testes de aceitação**, famosos com a onda ágil, são, no fim, testes de sistema. Testes de aceitação são aqueles onde as equipes ágeis dizem se uma determinada funcionalidade está “aceita” ou não.

Independente do nível do teste, todos eles tem vantagens e desvantagens. Um teste de unidade, por exemplo, é bastante fácil de ser e roda muito fácil; mas não é um teste que simula bem o mundo real. Por outro lado, um teste de sistema faz uma simulação bastante real, mas é muito mais difícil de ser escrito, dá mais trabalho de manutenção e leva mais tempo para executar.

Mas qual nível de teste usar então? A ideia é que você escolha o nível de teste certo para aquele problema. Uma classe de negócio pode ser testada de maneira isolada; já um DAO precisa ser testado junto a um banco de dados. Lembre-se: o teste deve dar feedback rico; um teste que nunca quebra não serve de nada.

## Introdução

Abordaremos aqui o suporte do Spring para testes de integração e práticas recomendadas para testes de unidade. O time do Spring defende o desenvolvimento orientado a testes (TDD). A equipe do Spring descobriu que o uso correto da inversão de controle (IoC) certamente torna os testes de unidade e integração mais fáceis (na medida em que a presença de métodos setter e construtores apropriados em classes facilita a conexão em um teste sem ter que configurar registros de localizadores de serviço e estruturas semelhantes).

O teste é uma parte integrante do desenvolvimento de software corporativo. Iremos enfocar o valor agregado pelo princípio IoC ao teste de unidade e aos benefícios do suporte do Spring Framework para testes de integração.

## Testes Unitários no Spring

A injeção de dependência deve tornar seu código menos dependente do contêiner do que seria com o desenvolvimento tradicional do Java EE. Os POJOs que compõem seu aplicativo devem ser testáveis ​​nos testes JUnit ou TestNG, com objetos instanciados usando o novo operador, sem o Spring ou qualquer outro contêiner. Você pode usar objetos simulados (em conjunto com outras valiosas técnicas de teste) para testar seu código isoladamente. Se você seguir as recomendações de arquitetura do Spring, a estratificação e a componentização limpas resultantes da base de código facilitarão o teste da unidade. Por exemplo, você pode testar objetos da camada de serviço por meio do stub ou do escaneamento de interfaces DAO ou de repositório, sem precisar acessar dados persistentes durante a execução de testes de unidade.

Os testes unitários verdadeiros geralmente são executados com extrema rapidez, pois não há infraestrutura de tempo de execução para serem configurados. Enfatizar os verdadeiros testes unitários como parte de sua metodologia de desenvolvimento pode aumentar sua produtividade.

<!-- 

2.1. Mock Objects
Spring includes a number of packages dedicated to mocking:

Environment

JNDI

Servlet API

Spring Web Reactive

2.1.1. Environment
The org.springframework.mock.env package contains mock implementations of the Environment and PropertySource abstractions (see Bean Definition Profiles and PropertySource Abstraction). MockEnvironment and MockPropertySource are useful for developing out-of-container tests for code that depends on environment-specific properties.

2.1.2. JNDI
The org.springframework.mock.jndi package contains an implementation of the JNDI SPI, which you can use to set up a simple JNDI environment for test suites or stand-alone applications. If, for example, JDBC DataSource instances get bound to the same JNDI names in test code as they do in a Java EE container, you can reuse both application code and configuration in testing scenarios without modification.

2.1.3. Servlet API
The org.springframework.mock.web package contains a comprehensive set of Servlet API mock objects that are useful for testing web contexts, controllers, and filters. These mock objects are targeted at usage with Spring’s Web MVC framework and are generally more convenient to use than dynamic mock objects (such as EasyMock) or alternative Servlet API mock objects (such as MockObjects).

Since Spring Framework 5.0, the mock objects in org.springframework.mock.web are based on the Servlet 4.0 API.
The Spring MVC Test framework builds on the mock Servlet API objects to provide an integration testing framework for Spring MVC. See Spring MVC Test Framework.

2.1.4. Spring Web Reactive
The org.springframework.mock.http.server.reactive package contains mock implementations of ServerHttpRequest and ServerHttpResponse for use in WebFlux applications. The org.springframework.mock.web.server package contains a mock ServerWebExchange that depends on those mock request and response objects.

Both MockServerHttpRequest and MockServerHttpResponse extend from the same abstract base classes as server-specific implementations and share behavior with them. For example, a mock request is immutable once created, but you can use the mutate() method from ServerHttpRequest to create a modified instance.

In order for the mock response to properly implement the write contract and return a write completion handle (that is, Mono<Void>), it by default uses a Flux with cache().then(), which buffers the data and makes it available for assertions in tests. Applications can set a custom write function (for example, to test an infinite stream).

The WebTestClient builds on the mock request and response to provide support for testing WebFlux applications without an HTTP server. The client can also be used for end-to-end tests with a running server.

2.2. Unit Testing Support Classes
Spring includes a number of classes that can help with unit testing. They fall into two categories:

General Testing Utilities

Spring MVC Testing Utilities

2.2.1. General Testing Utilities
The org.springframework.test.util package contains several general purpose utilities for use in unit and integration testing.

ReflectionTestUtils is a collection of reflection-based utility methods. You can use these methods in testing scenarios where you need to change the value of a constant, set a non-public field, invoke a non-public setter method, or invoke a non-public configuration or lifecycle callback method when testing application code for use cases such as the following:

ORM frameworks (such as JPA and Hibernate) that condone private or protected field access as opposed to public setter methods for properties in a domain entity.

Spring’s support for annotations (such as @Autowired, @Inject, and @Resource), that provide dependency injection for private or protected fields, setter methods, and configuration methods.

Use of annotations such as @PostConstruct and @PreDestroy for lifecycle callback methods.

AopTestUtils is a collection of AOP-related utility methods. You can use these methods to obtain a reference to the underlying target object hidden behind one or more Spring proxies. For example, if you have configured a bean as a dynamic mock by using a library such as EasyMock or Mockito, and the mock is wrapped in a Spring proxy, you may need direct access to the underlying mock to configure expectations on it and perform verifications. For Spring’s core AOP utilities, see AopUtils and AopProxyUtils.

2.2.2. Spring MVC Testing Utilities
The org.springframework.test.web package contains ModelAndViewAssert, which you can use in combination with JUnit, TestNG, or any other testing framework for unit tests that deal with Spring MVC ModelAndView objects.

Unit testing Spring MVC Controllers
To unit test your Spring MVC Controller classes as POJOs, use ModelAndViewAssert combined with MockHttpServletRequest, MockHttpSession, and so on from Spring’s Servlet API mocks. For thorough integration testing of your Spring MVC and REST Controller classes in conjunction with your WebApplicationContext configuration for Spring MVC, use the Spring MVC Test Framework instead.

-->

## Teste de integração no Spring

É importante poder realizar alguns testes de integração sem exigir a implantação no servidor de aplicativos ou a conexão com outra infraestrutura corporativa. Isso permite testar coisas como:

- A ligação correta dos contextos de contêiner do Spring IoC.
- Acesso de dados usando JDBC ou uma ferramenta ORM. Isso pode incluir coisas como a correção de instruções SQL, consultas Hibernate, mapeamentos de entidades JPA e assim por diante.

O Spring Framework fornece suporte de primeira classe para testes de integração no módulo `spring-test`. O nome do arquivo JAR real pode incluir a versão de liberação e também pode estar no formato longo `org.springframework.test`. Essa biblioteca inclui o pacote `org.springframework.test`, que contém classes valiosas para teste de integração com um contêiner Spring. Esse teste não depende de um servidor de aplicativos ou outro ambiente de implementação. Esses testes são mais lentos para serem executados do que os testes de unidade, mas muito mais rápidos que os testes Selenium equivalentes ou testes remotos que dependem da implantação em um servidor de aplicativos.

O suporte a testes de unidade e integração é fornecido na forma de Spring TestContext Framework orientada por anotações. O framework TestContext é agnóstico da estrutura de teste em uso, que permite a instrumentação de testes em vários ambientes, incluindo JUnit, TestNG e outros.

### Objetivos do Teste de Integração

O suporte de testes de integração do Spring tem os seguintes objetivos principais:

- Gerenciar o armazenamento em cache do contêiner do Spring IoC entre os testes;
- Fornecer Injeção de Dependência de instâncias de fixtures de teste;
- Fornecer gerenciamento de transações apropriado para testes de integração;
- Fornecer classes base específicas de Spring que auxiliem os desenvolvedores a escrever testes de integração;

<!-- 

3.2.1. Context Management and Caching
The Spring TestContext Framework provides consistent loading of Spring ApplicationContext instances and WebApplicationContext instances as well as caching of those contexts. Support for the caching of loaded contexts is important, because startup time can become an issue — not because of the overhead of Spring itself, but because the objects instantiated by the Spring container take time to instantiate. For example, a project with 50 to 100 Hibernate mapping files might take 10 to 20 seconds to load the mapping files, and incurring that cost before running every test in every test fixture leads to slower overall test runs that reduce developer productivity.

Test classes typically declare either an array of resource locations for XML or Groovy configuration metadata — often in the classpath — or an array of annotated classes that is used to configure the application. These locations or classes are the same as or similar to those specified in web.xml or other configuration files for production deployments.

By default, once loaded, the configured ApplicationContext is reused for each test. Thus, the setup cost is incurred only once per test suite, and subsequent test execution is much faster. In this context, the term “test suite” means all tests run in the same JVM — for example, all tests run from an Ant, Maven, or Gradle build for a given project or module. In the unlikely case that a test corrupts the application context and requires reloading (for example, by modifying a bean definition or the state of an application object) the TestContext framework can be configured to reload the configuration and rebuild the application context before executing the next test.

See Context Management and Context Caching with the TestContext framework.

3.2.2. Dependency Injection of Test Fixtures
When the TestContext framework loads your application context, it can optionally configure instances of your test classes by using Dependency Injection. This provides a convenient mechanism for setting up test fixtures by using preconfigured beans from your application context. A strong benefit here is that you can reuse application contexts across various testing scenarios (for example, for configuring Spring-managed object graphs, transactional proxies, DataSource instances, and others), thus avoiding the need to duplicate complex test fixture setup for individual test cases.

As an example, consider a scenario where we have a class (HibernateTitleRepository) that implements data access logic for a Title domain entity. We want to write integration tests that test the following areas:

The Spring configuration: Basically, is everything related to the configuration of the HibernateTitleRepository bean correct and present?

The Hibernate mapping file configuration: Is everything mapped correctly and are the correct lazy-loading settings in place?

The logic of the HibernateTitleRepository: Does the configured instance of this class perform as anticipated?

See dependency injection of test fixtures with the TestContext framework.

3.2.3. Transaction Management
One common issue in tests that access a real database is their effect on the state of the persistence store. Even when you use a development database, changes to the state may affect future tests. Also, many operations — such as inserting or modifying persistent data — cannot be performed (or verified) outside of a transaction.

The TestContext framework addresses this issue. By default, the framework creates and rolls back a transaction for each test. You can write code that can assume the existence of a transaction. If you call transactionally proxied objects in your tests, they behave correctly, according to their configured transactional semantics. In addition, if a test method deletes the contents of selected tables while running within the transaction managed for the test, the transaction rolls back by default, and the database returns to its state prior to execution of the test. Transactional support is provided to a test by using a PlatformTransactionManager bean defined in the test’s application context.

If you want a transaction to commit (unusual, but occasionally useful when you want a particular test to populate or modify the database), you can tell the TestContext framework to cause the transaction to commit instead of roll back by using the @Commit annotation.

See transaction management with the TestContext framework.

3.2.4. Support Classes for Integration Testing
The Spring TestContext Framework provides several abstract support classes that simplify the writing of integration tests. These base test classes provide well-defined hooks into the testing framework as well as convenient instance variables and methods, which let you access:

The ApplicationContext, for performing explicit bean lookups or testing the state of the context as a whole.

A JdbcTemplate, for executing SQL statements to query the database. You can use such queries to confirm database state both before and after execution of database-related application code, and Spring ensures that such queries run in the scope of the same transaction as the application code. When used in conjunction with an ORM tool, be sure to avoid false positives.

In addition, you may want to create your own custom, application-wide superclass with instance variables and methods specific to your project.

See support classes for the TestContext framework.

-->

## Preparando nosso projeto para testes unitários

Primeiramente, vamos adequear nosso projeto, criando uma classe de serviços 

**LivrosController**
```java
package com.acme.livroservice;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/livros")
public class LivrosController {

	Logger logger = LoggerFactory.getLogger(LivrosController.class);

	private final RabbitTemplate rabbitTemplate;
	
	private final LivroService livroService;

	LivrosController(RabbitTemplate rabbitTemplate, LivroService livroService) {
		this.rabbitTemplate = rabbitTemplate;
		this.livroService = livroService;
	}

	@GetMapping
	public List<Livro> getLivros(@RequestParam("autor") Optional<String> autor,
			@RequestParam("titulo") Optional<String> titulo) {
		logger.info(
				"getLivros - autor: " + autor.orElse("Não informado") + " titulo: " + titulo.orElse("Não informado"));

		return livroService.getLivros(autor, titulo);
	}

	@GetMapping("/{id}")
	@Cacheable(value = "livros", key = "#id")
	public Livro getLivroPorId(@PathVariable Long id) {
		logger.info("getLivroPorId: " + id);
		return livroService.getLivroPorId(id);
	}

	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivro(@RequestBody Livro livro) {
		logger.info("adicionarLivro: " + livro);
		return livroService.adicionarLivro(livro);
	}

	@PostMapping("/demorado")
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivroDemorado(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroDemorado iniciou: " + livro);
		TimeUnit.SECONDS.sleep(3);
		Livro livroSalvo = livroService.adicionarLivro(livro);
		logger.info("adicionarLivroDemorado terminou: " + livroSalvo);
		return livroSalvo;
	}

	@PostMapping("/assincrono")
	@ResponseStatus(HttpStatus.CREATED)
	public void adicionarLivroAssincrono(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroAssincrono iniciou: " + livro);
		rabbitTemplate.convertAndSend(LivroServiceApplication.TOPIC_EXCHANGE_NAME, LivroServiceApplication.ROUTING_KEY,
				livro);
	}

	@PutMapping("/{id}")
	@CachePut(value = "livros", key = "#id")
	public Livro atualizarLivro(@RequestBody Livro livro, @PathVariable Long id) {
		logger.info("atualizarLivro: " + livro + " id: " + id);
		return livroService.atualizarLivro(livro, id);
	}

	@DeleteMapping("/{id}")
	@CacheEvict(value = "livros", allEntries = true)
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void excluirLivro(@PathVariable Long id) {
		logger.info("excluirLivro: " + id);
		livroService.excluirLivro(id);
	}
}
```

**LivroService**
```java
package com.acme.livroservice;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.server.ResponseStatusException;

@Service
public class LivroService {
	Logger logger = LoggerFactory.getLogger(LivroService.class);

	private final LivroRepository repository;
	
	private final AvaliacaoService avaliacaoService;

	LivroService(LivroRepository repository, AvaliacaoService avaliacaoService) {
		this.repository = repository;
		this.avaliacaoService = avaliacaoService;
	}

	public List<Livro> getLivros(Optional<String> autor, Optional<String> titulo) {
		logger.info("getLivros - autor: " + autor.orElse("Não informado") + " titulo: " + titulo.orElse("Não informado"));

		if (autor.isPresent()) {
			return repository.findAll(LivroRepository.autorContem(autor.get()));
		} else if (titulo.isPresent()) {
			return repository.findAll(LivroRepository.tituloContem(titulo.get()));
		} else if (autor.isPresent() && titulo.isPresent()) {
			return repository.findAll(Specification.where(LivroRepository.autorContem(autor.get()))
					.and(LivroRepository.tituloContem(titulo.get())));
		} else {
			return repository.findAll();
		}
	}

	public Livro getLivroPorId(Long id) {
		logger.info("getLivroPorId: " + id);
		return repository.findById(id)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
	}

	public Livro adicionarLivro(@RequestBody Livro livro) {
		logger.info("adicionarLivro: " + livro);
		return repository.save(livro);
	}

	public Livro atualizarLivro(Livro livro, Long id) {
		logger.info("atualizarLivro: " + livro + " id: " + id);
		return repository.findById(id).map(livroSalvo -> {
			livroSalvo.setAutor(livro.getAutor());
			livroSalvo.setTitulo(livro.getTitulo());
			livroSalvo.setPreco(livro.getPreco());
			return repository.save(livroSalvo);
		}).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
	}

	public void excluirLivro(Long livroId) {
		logger.info("excluirLivro: " + livroId);
		
		try {
			this.avaliacaoService.apagarAvaliacoesPorLivroId(livroId);
			logger.info("Avaliações vinculadas excluídas com sucesso");
		} catch (ResourceAccessException | HttpClientErrorException ex) {
			logger.error("Ocorreu um erro na comunicação com o serviço de avaliações", ex);
			throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
					"Ocorreu um erro não esperado na comunicação com o serviço de livros: " + ex.getMessage());
		}

		repository.deleteById(livroId);
	}
}
```

**AvaliacaoService**
```java
package com.acme.livroservice;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class AvaliacaoService {
	
	private final RestTemplate restTemplate;
	
	public AvaliacaoService(RestTemplateBuilder restTemplateBuilder) {
		restTemplate = restTemplateBuilder.build();
	}
	
	public void apagarAvaliacoesPorLivroId(Long livroId) {
		String avaliacaoResourceUrl = "http://localhost:8081/avaliacoes/livro/";
		restTemplate.delete(avaliacaoResourceUrl + livroId);
	}
}
```

Outra alteração importante é implementar um método `equals` na classe `Livro`:

```java
@Override
public boolean equals(Object obj) {
    if (this == obj)
        return true;
    if (obj == null)
        return false;
    if (getClass() != obj.getClass())
        return false;
    Livro other = (Livro) obj;
    if (autor == null) {
        if (other.autor != null)
            return false;
    } else if (!autor.equals(other.autor))
        return false;
    if (id == null) {
        if (other.id != null)
            return false;
    } else if (!id.equals(other.id))
        return false;
    if (preco == null) {
        if (other.preco != null)
            return false;
    } else if (!preco.equals(other.preco))
        return false;
    if (titulo == null) {
        if (other.titulo != null)
            return false;
    } else if (!titulo.equals(other.titulo))
        return false;
    return true;
}
```

<!-- 

## Introdução ao JUnit

-->

## Testes Unitários com Spring Boot

O boot Spring oferece uma ótima classe para facilitar o teste: anotação `@SpringBootTest`.

Esta anotação pode ser especificada em uma classe de teste que executa testes baseados no Spring Boot.
Fornece os seguintes recursos além do Spring TestContext Framework regular:

- Usa `SpringBootContextLoader` como o `ContextLoader` padrão quando nenhum `@ContextConfiguration(loader=...)` específico é definido;
- Procura automaticamente por um `@SpringBootConfiguration` quando `@Configuration` aninhado não é usado, e nenhuma classe explícita é especificada;
- Permite que propriedades de ambiente personalizadas sejam definidas usando o atributo properties;
- Fornece suporte para diferentes modos de ambiente da Web, incluindo a capacidade de iniciar um servidor da Web totalmente em execução, ouvindo em uma porta definida ou aleatória;
- Registra um bean `TestRestTemplate` e/ou `WebTestClient` para uso em testes da web que estão usando um servidor da Web totalmente em execução;

O primeiro passo é nos certificarmos que a dependência `spring-boot-starter-test` está presente no `pom.xml` de nosso projeto.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```

Nós basicamente temos dois componentes para testar aqui: `LivroService` e `LivrosController`.

### Testes Unitários de `LivroService`

**LivroServiceUnitTest**

```java
package com.acme.livroservice;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class LivroServiceUnitTest {
	@Autowired
	private LivroService livroService;

	@MockBean
	private LivroRepository repository;
	
	@MockBean
	private AvaliacaoService avaliacaoService;

	public void criaListaLivrosVazia() {
		when(repository.findAll()).thenReturn(new ArrayList<Livro>());
	}

	public void criaListaLivrosDefault() {
		List<Livro> livros = new ArrayList<Livro>();
		livros.add(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
		livros.add(new Livro(2L, "J. R. R. Tolkien", "O Senhor dos Anéis", 123.0));
		livros.add(new Livro(3L, "Antoine de Saint-Exupéry", "O Pequeno Príncipe", 152.0));
		livros.add(new Livro(4L, "Charles Dickens", "Um Conto de Duas Cidades", 35.0));

		when(repository.findAll()).thenReturn(livros);
	}

	@Test
	public void getLivrosVazio() {
		criaListaLivrosVazia();
		List<Livro> livros = livroService.getLivros(Optional.empty(), Optional.empty());
		assertThat(livros).isEmpty();
	}

	@Test
	public void getLivrosComLivros() {
		criaListaLivrosDefault();
		List<Livro> livros = livroService.getLivros(Optional.empty(), Optional.empty());
		assertThat(livros.size()).isEqualTo(4);
	}

	@Test
	public void getLivroPorId() {
		when(repository.findById(1L))
				.thenReturn(Optional.of(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0)));
		Livro livro = livroService.getLivroPorId(1L);
		assertThat(livro).isEqualTo(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
	}

	@Test
	public void adicionarLivro() {
		when(repository.save(new Livro("Miguel de Cervantes", "Don Quixote", 144.0)))
				.thenReturn(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
		Livro livro = livroService.adicionarLivro(new Livro("Miguel de Cervantes", "Don Quixote", 144.0));
		assertThat(livro).isEqualTo(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
	}

	@Test
	public void atualizarLivro() {
		when(repository.findById(1L))
				.thenReturn(Optional.of(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0)));
		when(repository.save(new Livro(1L, "Foo Bar", "Don Quixote", 144.0)))
				.thenReturn(new Livro(1L, "Foo Bar", "Don Quixote", 144.0));
		Livro livro = livroService.atualizarLivro(new Livro(1L, "Foo Bar", "Don Quixote", 144.0), 1L);
		assertThat(livro).isEqualTo(new Livro(1L, "Foo Bar", "Don Quixote", 144.0));
	}

	// É correto testar o funcionamento interno da função?
	@Test
	public void excluirLivro() {
		livroService.excluirLivro(1L);
		verify(avaliacaoService, times(1)).apagarAvaliacoesPorLivroId(1L);
		verify(repository, times(1)).deleteById(1L);
	}
}
```

### Testes Unitários de `LivrosController`

**LivrosControllerUnitTest**

```java
package com.acme.livroservice;

import static org.hamcrest.Matchers.is;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

import com.fasterxml.jackson.databind.ObjectMapper;

@RunWith(SpringRunner.class)
@SpringBootTest
public class LivrosControllerUnitTest {

	MockMvc mockMvc;

	@Autowired
	private LivrosController livrosController;

	@MockBean
	private RabbitTemplate rabbitTemplate;

	@MockBean
	private LivroService livroService;

	private List<Livro> livros;

	@Before
	public void setup() throws Exception {
		this.mockMvc = standaloneSetup(this.livrosController).build();

		livros = new ArrayList<Livro>();
		livros.add(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
		livros.add(new Livro(2L, "J. R. R. Tolkien", "O Senhor dos Anéis", 123.0));
		livros.add(new Livro(3L, "Antoine de Saint-Exupéry", "O Pequeno Príncipe", 152.0));
		livros.add(new Livro(4L, "Charles Dickens", "Um Conto de Duas Cidades", 35.0));
	}

	@Test
	public void getLivros() throws Exception {
		when(livroService.getLivros(Optional.empty(), Optional.empty())).thenReturn(livros);
		mockMvc.perform(get("/livros").contentType(MediaType.APPLICATION_JSON)).andExpect(status().isOk())
				.andExpect(jsonPath("$[0].titulo", is("Don Quixote")))
				.andExpect(jsonPath("$[1].titulo", is("O Senhor dos Anéis")))
				.andExpect(jsonPath("$[2].titulo", is("O Pequeno Príncipe")))
				.andExpect(jsonPath("$[3].titulo", is("Um Conto de Duas Cidades")));
	}

	@Test
	public void getLivro() throws Exception {
		when(livroService.getLivroPorId(1L)).thenReturn(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
		mockMvc.perform(get("/livros/1").contentType(MediaType.APPLICATION_JSON)).andExpect(status().isOk())
				.andExpect(jsonPath("$.titulo", is("Don Quixote")));
	}

	@Test
	public void adicionarLivro() throws Exception {
		when(livroService.adicionarLivro(new Livro("Miguel de Cervantes", "Don Quixote", 144.0)))
				.thenReturn(new Livro(1L, "Miguel de Cervantes", "Don Quixote", 144.0));
		mockMvc.perform(post("/livros").contentType(MediaType.APPLICATION_JSON)
				.content(asJsonString(new Livro("Miguel de Cervantes", "Don Quixote", 144.0)))
				.accept(MediaType.APPLICATION_JSON)).andExpect(status().isCreated())
				.andExpect(jsonPath("$.titulo", is("Don Quixote")));
	}

	public static String asJsonString(final Object obj) {
		try {
			final ObjectMapper mapper = new ObjectMapper();
			final String jsonContent = mapper.writeValueAsString(obj);
			return jsonContent;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	@Test
	public void atualizarLivro() throws Exception {
		when(livroService.atualizarLivro(new Livro(1L, "Foo Bar", "Don Quixote", 144.0), 1L))
				.thenReturn(new Livro(1L, "Foo Bar", "Don Quixote", 144.0));
		mockMvc.perform(put("/livros/1").contentType(MediaType.APPLICATION_JSON)
				.content(asJsonString(new Livro(1L, "Foo Bar", "Don Quixote", 144.0)))
				.accept(MediaType.APPLICATION_JSON)).andExpect(status().isOk())
				.andExpect(jsonPath("$.autor", is("Foo Bar")));
	}
	
	@Test
	public void excluirLivro() throws Exception {
		mockMvc.perform(delete("/livros/1")).andExpect(status().isNoContent());
	}
}
```

## Testes de Integração com Spring Boot

Para os testes de integração, queremos verificar nossos principais componentes com a comunicação downstream.

### Testes Unitários de `LivroService`

Este teste é muito simples. Não precisamos mocar nada.

**LivroServiceIntegrationTest**

```java
package com.acme.livroservice;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import java.util.Optional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class LivroServiceIntegrationTest {
	@Autowired
	private LivroService livroService;

	@Test
	public void getLivros() {
		List<Livro> livros = livroService.getLivros(Optional.empty(), Optional.empty());
		assertThat(livros).isNotEmpty();
	}
}
```

### Testes Unitários de `LivrosController`

**LivrosControllerIntegrationTest**

```java
package com.acme.livroservice;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

@RunWith(SpringRunner.class)
@SpringBootTest
public class LivrosControllerIntegrationTest {

	MockMvc mockMvc;

	@Autowired
	private LivrosController livrosController;

	@Before
	public void setup() throws Exception {
		this.mockMvc = standaloneSetup(this.livrosController).build();
	}

	@Test
	public void getLivros() throws Exception {
		mockMvc.perform(get("/livros").contentType(MediaType.APPLICATION_JSON)).andExpect(status().isOk())
				.andExpect(jsonPath("$[0].titulo", is("Don Quixote")))
				.andExpect(jsonPath("$[1].titulo", is("O Senhor dos Anéis")))
				.andExpect(jsonPath("$[2].titulo", is("O Pequeno Príncipe")))
				.andExpect(jsonPath("$[3].titulo", is("Um Conto de Duas Cidades")));
	}

}
```

## Fontes
- http://blog.caelum.com.br/unidade-integracao-ou-sistema-qual-teste-fazer/
- https://www.baeldung.com/spring-boot-testing
- https://dzone.com/articles/unit-and-integration-tests-in-spring-boot-2
- https://thepracticaldeveloper.com/2017/07/31/guide-spring-boot-controller-tests/
