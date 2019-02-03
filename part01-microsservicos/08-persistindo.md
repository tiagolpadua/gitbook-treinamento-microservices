# Persistindo em um Banco de Dados

Nossas funcionalidades do CRUD estão completas, iremos agora ajustar nosso projeto para que faça a persistência em uma base de dados.

## H2

O H2 é um banco de dados Java leve e de código aberto. Pode ser incorporado em aplicativos Java ou executado no modo cliente-servidor. Principalmente, o banco de dados H2 pode ser configurado para ser executado como banco de dados em memória, o que significa que os dados não persistirão no disco. Por causa do banco de dados embutido, ele não é usado em produção, mas é usado principalmente para desenvolvimento e testes.

Este banco de dados pode ser usado no modo incorporado ou no modo de servidor. A seguir estão as principais características do banco de dados H2:
- Extremamente rápido, código aberto, API JDBC
- Disponível nos modos incorporado e servidor; bancos de dados na memória
- Aplicativo de console baseado em navegador
- Pequena pegada - cerca de 1,5 MB de tamanho de arquivo jar

## JPA

Qualquer aplicativo corporativo executa operações em banco de dados, armazenando e recuperando grandes quantidades de dados. Apesar de todas as tecnologias disponíveis para gerenciamento de armazenamento, os desenvolvedores de aplicativos normalmente tem muito trabalho para executar operações de banco de dados com eficiência.

Geralmente, os desenvolvedores Java usam muito código ou usam um framework proprietário para interagir com o banco de dados, enquanto que, usando o JPA, a carga de interação com o banco de dados é reduzida significativamente. Ele forma uma ponte entre modelos de objetos (programa Java) e modelos relacionais (programa de banco de dados).

Java Persistence API é uma coleção de classes e métodos para armazenar persistentemente grandes quantidades de dados em um banco de dados com um mínimo de esforço do desenvolvedor.

## Adicionando Dependências ao ```pom.xml``` de Nossa Aplicação

Vamos incluir as depenências ```spring-boot-starter-data-jpa``` e ```h2``` em nosso ```pom.xml```:

- ```pom.xml```

```xml
  <!-- Código anterior omitido -->
  <dependencies>
    
    <!-- Dependências atuais omitidas -->

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!--  
        Este escopo indica que a dependência não é necessária para compilação, mas para execução.
        Ele está no classpath do runtime de execução e teste, mas não no classpath.
    -->
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <scope>runtime</scope>
    </dependency>

  </dependencies>
  <!-- Código posterior omitido -->
```

## Transformando a classe ```Livro``` em uma Entidade

Agora, vamos transformar a classe ```Livro``` em uma entidade que pode ser persistida em um banco de dados utilizando JPA:

- ```/src/main/java/com/acme/livroservice/Livro.java```

```java
package com.acme.livroservice;

// Novidades aqui
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

// Novidades aqui
@Entity
public class Livro {

    // Novidades aqui
	private @Id @GeneratedValue Long id;

	private String autor;
	private String titulo;
	private Double preco;

	public Livro(String autor, String titulo, Double preco) {
		super();
		this.autor = autor;
		this.titulo = titulo;
		this.preco = preco;
	}

    // Código atual omitido

}
```

- ```@Entity``` é uma anotação JPA para tornar esse objeto pronto para armazenamento em um banco de dados baseado em JPA;
- ```id``` foi marcado com anotações de JPA para indicar que é a chave primária e preenchida automaticamente pelo provedor de JPA;
- Um construtor personalizado é criado quando precisamos criar uma nova instância, mas ainda não temos um id;

Com essa definição de objeto de domínio, agora podemos recorrer ao Spring Data JPA para lidar com as interações tediosas do banco de dados. Os repositórios do Spring Data são interfaces com métodos que suportam leitura, atualização, exclusão e criação de registros em um armazenamento de dados de backend. Alguns repositórios também suportam paginação de dados e ordenação, quando apropriado. O Spring Data sintetiza implementações baseadas em convenções encontradas na nomenclatura dos métodos na interface.

## Um repositório de dados JPA

Vamos então criar o repositório JPA que lidará com as operações do banco de dados:

- ```/src/main/java/com/acme/livroservice/LivroRepository.java```

```java
package com.acme.livroservice;

import org.springframework.data.jpa.repository.JpaRepository;

public interface LivroRepository extends JpaRepository<Livro, Long> {

}
```

Essa interface estende o ```JpaRepository``` do Spring Data JPA, especificando o tipo de domínio como ```Livro``` e o tipo de id como Long. Esta interface, embora vazia na superfície, embute vários recursos:
- Criação de novas instâncias;
- Atualização das existentes;
- Exclusão;
- Pesquisa (um, todos, por propriedades simples ou complexas);

A solução de repositório do Spring Data possibilita contornar os detalhes do armazenamento de dados e, em vez disso, soluciona a maioria dos problemas usando a terminologia específica do domínio.

## Pré-carregando com dados fictícios

Atualmente estamos criando um bean e o carregando com dados fictícios, vamos fazer a mesma coisa com o banco de dados H2, no entanto, o Spring fornece um mecanismo adequado para esta finalidade.

Para isso vamos criar a classe ```LoadDatabase```:

- ```/src/main/java/com/acme/livroservice/LoadDatabase.java```

```java
package com.acme.livroservice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
class LoadDatabase {

	Logger logger = LoggerFactory.getLogger(LivrosController.class);

	@Bean
	public CommandLineRunner initDatabase(LivroRepository repository) {
		return args -> {
			logger.info("Preloading " + repository.save(new Livro("Miguel de Cervantes", "Don Quixote", 144.0)));
			logger.info("Preloading " + repository.save(new Livro("J. R. R. Tolkien", "O Senhor dos Anéis", 123.0)));
			logger.info("Preloading "
					+ repository.save(new Livro("Antoine de Saint-Exupéry", "O Pequeno Príncipe", 152.0)));
			logger.info(
					"Preloading " + repository.save(new Livro("Charles Dickens", "Um Conto de Duas Cidades", 35.0)));
		};
	}
}
```

O que acontece quando o projeto é executado?

O Spring Boot executará todos os beans ```CommandLineRunner``` quando o contexto do aplicativo for carregado.

Este runner solicitará uma cópia do EmployeeRepository que você acabou de criar.

Ao usá-lo, ele criará duas entidades e as armazenará.

Ao consultar o log, você verá algo como:

```
...
2019-01-20 19:58:12.681  INFO 24752 --- [  restartedMain] com.acme.livroservice.LivrosController   : Preloading Livro [id=1, autor=Miguel de Cervantes, titulo=Don Quixote, preco=144.0]
2019-01-20 19:58:12.684  INFO 24752 --- [  restartedMain] com.acme.livroservice.LivrosController   : Preloading Livro [id=2, autor=J. R. R. Tolkien, titulo=O Senhor dos Anéis, preco=123.0]
2019-01-20 19:58:12.688  INFO 24752 --- [  restartedMain] com.acme.livroservice.LivrosController   : Preloading Livro [id=3, autor=Antoine de Saint-Exupéry, titulo=O Pequeno Príncipe, preco=152.0]
2019-01-20 19:58:12.693  INFO 24752 --- [  restartedMain] com.acme.livroservice.LivrosController   : Preloading Livro [id=4, autor=Charles Dickens, titulo=Um Conto de Duas Cidades, preco=35.0]
...
```

## Ajustando o Controller para que use o Repositório

Agora que temos um repositório funcional, devemos apagar o bean ```listaLivros``` que criamos na classe ```LivroServiceApplication```:

- ```src/main/java/com/acme/livroservice/LivroServiceApplication.java```

```java
package com.acme.livroservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LivroServiceApplication {

    // O código que fabricava o bean foi removido
	
	public static void main(String[] args) {
		SpringApplication.run(LivroServiceApplication.class, args);
	}
}
```

Agora vamos ajustar o controller de fato:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
package com.acme.livroservice;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/livros")
public class LivrosController {

	Logger logger = LoggerFactory.getLogger(LivrosController.class);

	private final LivroRepository repository;
	
	LivrosController(LivroRepository repository) {
		this.repository = repository;
	}

	@GetMapping
	public List<Livro> getLivros(@RequestParam("autor") Optional<String> autor,
			@RequestParam("titulo") Optional<String> titulo) {
		logger.info("getLivros - autor: " + autor.orElse("Não informado") + " titulo: " + titulo.orElse("Não informado"));

		return repository.findAll();
	}

	@GetMapping("/{id}")
	public Livro getLivroPorId(@PathVariable Long id) {
		logger.info("getLivroPorId: " + id);
		return repository.findById(id).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
	}

	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivro(@RequestBody Livro livro) {
		logger.info("adicionarLivro: " + livro);
		return repository.save(livro);		
	}

	@PutMapping("/{id}")
	public Livro atualizarLivro(@RequestBody Livro livro, @PathVariable Long id) {
		logger.info("atualizarLivro: " + livro + " id: " + id);
		return repository.findById(id)
				.map(livroSalvo -> {
					livroSalvo.setAutor(livro.getAutor());
					livroSalvo.setTitulo(livro.getTitulo());
					livroSalvo.setPreco(livro.getPreco());
					return repository.save(livroSalvo);
				})
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));		
	}

	@DeleteMapping("/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void excluirLivro(@PathVariable Long id) {
		logger.info("excluirLivro: " + id);		
		repository.deleteById(id);
	}
}
```

Note que ```LivroRepository``` é injetado pelo construtor no controlador.

Tudo deve funcionar normalmente, porém, irá perceber que não conseguimos mais buscar livros pelo autor e título, iremos providenciar este último ajuste agora.

## Criteria Queries

<!-- https://www.baeldung.com/spring-data-criteria-queries -->

O Spring Data JPA fornece várias maneiras de lidar com entidades, incluindo métodos de consulta e consultas personalizadas de JPQL. No entanto, às vezes precisamos de uma abordagem mais programática: por exemplo, Criteria API ou QueryDSL.

A Criteria API oferece uma maneira programática de criar consultas digitadas, o que nos ajuda a evitar erros de sintaxe. Ainda mais, quando o usamos com a API Metamodel, ele faz verificações em tempo de compilação se usamos os nomes e tipos de campos corretos.

No entanto, tem suas desvantagens: temos que escrever uma lógica detalhada com código verboso.

### Usando JPA Specifications

O Spring Data introduziu a interface org.springframework.data.jpa.domain.Specification para encapsular um único predicado, podemos fornecer métodos para criar instâncias de especificação e então usá-los. Para isso, precisamos que o nosso repositório estenda org.springframework.data.jpa.repository.JpaSpecificationExecutor<T>. Essa interface declara métodos úteis para trabalhar com especificações.

Infelizmente, não há nenhum método, ao qual podemos passar várias especificações como argumentos. Em vez disso, obtemos métodos de utilitário na interface org.springframework.data.jpa.domain.Specification. Por exemplo, combinando duas instâncias de especificação com lógica ```and``` e ```where```.

Vamos então preparar nosso repositório para trabalhar com ```Specifications```:

- ```/src/main/java/com/acme/livroservice/LivroRepository.java```

```java
package com.acme.livroservice;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface LivroRepository extends JpaRepository<Livro, Long>, JpaSpecificationExecutor<Livro> {

	static Specification<Livro> autorContem(String autor) {
		return (livro, cq, cb) -> cb.like(cb.lower(livro.get("autor")), "%" + autor.toLowerCase() + "%");
	}

	static Specification<Livro> tituloContem(String titulo) {
		return (livro, cq, cb) -> cb.like(cb.lower(livro.get("titulo")), "%" + titulo.toLowerCase() + "%");
	}
}
```

Em seguida, vamos alterar nosso controller para que utilize as ```Specifications```:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
package com.acme.livroservice;

// Código atual omitido

// Novidade aqui
import org.springframework.data.jpa.domain.Specification;

@RestController
@RequestMapping("/livros")
public class LivrosController {

	// Código atual omitido

	@GetMapping
	public List<Livro> getLivros(@RequestParam("autor") Optional<String> autor,
			@RequestParam("titulo") Optional<String> titulo) {
		logger.info(
				"getLivros - autor: " + autor.orElse("Não informado") + " titulo: " + titulo.orElse("Não informado"));

        // Novidades aqui
		if (autor.isPresent()) {
			return repository.findAll(LivroRepository.autorContem(autor.get()));
		} else if (titulo.isPresent()) {
			return repository.findAll(LivroRepository.tituloContem(titulo.get()));
		} else if (autor.isPresent() && titulo.isPresent()) {
			return repository.findAll(
					Specification.where(LivroRepository.autorContem(autor.get())).and(LivroRepository.tituloContem(titulo.get())));
		} else {
			return repository.findAll();			
		}
	}

	// Código atual omitido
}
```

## Console Web do H2

O banco de dados H2 fornece um console baseado em navegador que o Spring Boot pode configurar automaticamente para você.

Para acessá-lo, utilize o end-point `/h2-console`, os parâmetro de conexão são os seguintes:

- JDBC URL: `jdbc:h2:mem:testdb`
- User Name: `sa`
- Password: ``
