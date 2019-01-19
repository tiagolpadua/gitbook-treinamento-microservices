# Criando um end-point REST

Agora, iremos criar nosso primeiro web service RESTful com Spring.

## O que será criado

Criaremos um serviço que irá aceitar um request HTTP GET para:

```
http://localhost:8080/livros
```

E responder com a representação JSON a seguir:

```json
[
  {
    "id": 1,
    "autor": "Don Quixote",
    "titulo": "Miguel de Cervantes",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "O Senhor dos Anéis",
    "titulo": "J. R. R. Tolkien",
    "preco": 23
  }
]
```

## Crie uma classe de representação de recurso

Com o projeto que já criamos anteriormente, agora é possível criar um web service.

Começamos o processo pensando em interações de serviço.

O serviço responderá solicitações GET para /livros. A solicitação GET deve retornar uma resposta 200 OK com JSON no corpo que representa uma lista de livros.

Para modelar a representação do livro, cria-se uma classe de representação de recurso. Forneça um objeto java simples com campos, construtores e acessadores para os dados de id, autor, titulo e preço:

- ```/src/main/java/com/acme/livroservice/Livro.java```

```java
package com.acme.livroservice;

public class Livro {
	private Long id;
	private String autor;
	private String titulo;
	private Double preco;
	
	public Livro() {
		super();
	}
	
	public Livro(Long id, String autor, String titulo, Double preco) {
		super();
		this.id = id;
		this.autor = autor;
		this.titulo = titulo;
		this.preco = preco;
	}

	/* Getters e Setters */
}
```

## Criar um controlador de recursos

Na abordagem do Spring para a criação de serviços Web RESTful, as solicitações HTTP são tratadas por um controlador. Esses componentes são facilmente identificados pela anotação ```@RestController```, e a classe ```LivrosController``` abaixo lida com solicitações ```GET``` para ```/livros``` retornando uma lista de livros:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
package com.acme.livroservice;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LivrosController {

	@RequestMapping("/livros")
	public List<Livro> getLivros() {
		ArrayList<Livro> livros = new ArrayList<Livro>();
		
		Livro l1 = new Livro(1l, "Don Quixote", "Miguel de Cervantes", 144.0);
		Livro l2 = new Livro(2l, "O Senhor dos Anéis", "J. R. R. Tolkien", 123.0);
		
		livros.add(l1);
		livros.add(l2);
		
		return livros;
	}
}
```

```json
[
  {
    "id": 1,
    "autor": "Don Quixote",
    "titulo": "Miguel de Cervantes",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "O Senhor dos Anéis",
    "titulo": "J. R. R. Tolkien",
    "preco": 23
  }
]
```

Mas e agora, se quisermos adicionar mais um livro:

```java
package com.acme.livroservice;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LivrosController {

	@RequestMapping("/livros")
	public List<Livro> getLivros() {
		ArrayList<Livro> livros = new ArrayList<Livro>();
		
		Livro l1 = new Livro(1l, "Don Quixote", "Miguel de Cervantes", 144.0);
		Livro l2 = new Livro(2l, "O Senhor dos Anéis", "J. R. R. Tolkien", 123.0);
		Livro l3 = new Livro(3l, "O Pequeno Príncipe", "Antoine de Saint-Exupéry", 152.0);
		
		livros.add(l1);
		livros.add(l2);
		livros.add(l3);
		
		return livros;
	}
}
```

```json
[
  {
    "id": 1,
    "autor": "Don Quixote",
    "titulo": "Miguel de Cervantes",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "O Senhor dos Anéis",
    "titulo": "J. R. R. Tolkien",
    "preco": 23
  },
  {
    "id": 3,
    "autor": "O Pequeno Príncipe",
    "titulo": "Antoine de Saint-Exupéry",
    "preco": 52
  }
]
```

Temos que parar o servidor, alterar o código, e executar o servidor novamente...

Mas podemos deixar este processo mais ágil.

## Developer Tools

O Spring Boot inclui um conjunto adicional de ferramentas que podem tornar a experiência de desenvolvimento de aplicativos um pouco mais agradável. O módulo spring-boot-devtools pode ser incluído em qualquer projeto para fornecer recursos adicionais de tempo de desenvolvimento. Para incluir suporte a devtools, adicione a dependência do módulo à sua compilação, conforme mostrado na listagem a seguir para Maven:

```xml
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-devtools</artifactId>
		<optional>true</optional>
	</dependency>
</dependencies>
```

### Restart automático

Aplicativos que usam ```spring-boot-devtools``` são reiniciados automaticamente sempre que os arquivos no caminho de classe são alterados. Isso pode ser um recurso útil ao trabalhar em um IDE, pois fornece um loop de feedback muito rápido para alterações de código. Por padrão, qualquer entrada no caminho de classe que aponta para uma pasta é monitorada quanto a alterações. Observe que determinados recursos, como ativos estáticos e templates de visualização, não precisam reiniciar o aplicativo para que as alterações sejam percebidas.

Inclua a dependência do ```spring-boot-devtools``` no ```pom.xml``` do projeto, execute novamente o projeto, altere o valor dos livros e verifique que mesmo sem reiniciar manualmente a aplicação as alterações são percebidas.
