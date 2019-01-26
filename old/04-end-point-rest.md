# Criando um end-point REST

<!-- https://spring.io/guides/gs/rest-service/ -->

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
    "autor": "Miguel de Cervantes",
    "titulo": "Don Quixote",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "J. R. R. Tolkien",
    "titulo": "O Senhor dos Anéis",
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

  // Dica: O método abaixo pode ser gerado automaticamente clicando com o botão direito na classe
  // e em Source -> Generate toString()
  @Override
	public String toString() {
		return "Livro [id=" + id + ", autor=" + autor + ", titulo=" + titulo + ", preco=" + preco + "]";
	}

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
		
		Livro l1 = new Livro(1l, "Miguel de Cervantes", "Don Quixote", 144.0);
		Livro l2 = new Livro(2l, "J. R. R. Tolkien", "O Senhor dos Anéis", 123.0);
		
		livros.add(l1);
		livros.add(l2);
		
		return livros;
	}
}
```

Este controlador é conciso e simples, mas há muita coisa acontecendo embaixo do capô. Vamos dividi-lo passo a passo.

A anotação ```@RequestMapping``` garante que as solicitações HTTP ```/livros``` sejam mapeadas para o método ```getLivros()```.

O código não especifica ```GET```, ```PUT``` ou ```POST``` pois ```@RequestMapping``` mapeia todas as operações HTTP por padrão. Utiliza-se ```@RequestMapping(method=GET)``` para restringir esse mapeamento.


A implementação do corpo do método cria e retorna um novo objeto ```ArrayList<Livro>``` com uma lista de livros que é populada.

Uma diferença fundamental entre um controlador de páginas tradicional e o controlador de serviço da web RESTful é a maneira como o corpo de resposta HTTP é criado. Em vez de depender de uma tecnologia de visualização para executar a renderização do lado do servidor dos dados dos livros para HTML, esse controlador de serviço da Web RESTful simplesmente preenche e retorna um objeto ```ArrayList<Livro>```. Os dados do objeto serão gravados diretamente na resposta HTTP como JSON.

Esse código usa a anotação ```@RestController``` que marca a classe como um controlador em que cada método retorna um objeto de domínio em vez de um modo de exibição. É uma abreviação de ```@Controller``` e ```@ResponseBody``` reunidos.

O objeto ```ArrayList<Livro>``` deve ser convertido em JSON. Graças ao suporte ao conversor de mensagens HTTP do Spring, nãoé necessário fazer essa conversão manualmente. Como ```Jackson 2``` está no classpath, o conversor ```MappingJackson2HttpMessageConverter``` do Spring é automaticamente escolhido para converter a lsita de livros em JSON.

Agora já podemos compilar e executar nossa aplicação, acessando o endereço http://localhost:8080/livros, devemos ter uma resposta como a seguinte:

```json
[
  {
    "id": 1,
    "autor": "Miguel de Cervantes",
    "titulo": "Don Quixote",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "J. R. R. Tolkien",
    "titulo": "O Senhor dos Anéis",
    "preco": 23
  }
]
```

Mas e agora, se quisermos adicionar mais um livro? Devemos então alterar o código da aplicação:

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
		
		Livro l1 = new Livro(1l, "Miguel de Cervantes", "Don Quixote", 144.0);
		Livro l2 = new Livro(2l, "J. R. R. Tolkien", "O Senhor dos Anéis", 123.0);
		Livro l3 = new Livro(3l, "Antoine de Saint-Exupéry", "O Pequeno Príncipe", 152.0);
		
		livros.add(l1);
		livros.add(l2);
		livros.add(l3);
		
		return livros;
	}
}
```

Após compilar e executar nossa aplicação, acessando o endereço http://localhost:8080/livros, devemos ter uma resposta como a seguinte:

```json
[
  {
    "id": 1,
    "autor": "Miguel de Cervantes",
    "titulo": "Don Quixote",
    "preco": 44
  },
  {
    "id": 2,
    "autor": "J. R. R. Tolkien",
    "titulo": "O Senhor dos Anéis",
    "preco": 23
  },
  {
    "id": 3,
    "autor": "Antoine de Saint-Exupéry",
    "titulo": "O Pequeno Príncipe",
    "preco": 52
  }
]
```

Mas para isso, tivemos que parar o servidor, alterar o código, e executar o servidor novamente...

A boa notícia é que podemos deixar este processo mais ágil!

## Developer Tools

O Spring Boot inclui um conjunto adicional de ferramentas que podem tornar a experiência de desenvolvimento de aplicativos um pouco mais agradável. O módulo ```spring-boot-devtools``` pode ser incluído em qualquer projeto para fornecer recursos adicionais de tempo de desenvolvimento. Para incluir suporte a devtools, adicione a dependência do módulo à sua compilação, conforme mostrado na listagem a seguir para Maven:

- ```pom.xml```

```xml
  <!-- Código anterior omitido -->
  <dependencies>
    
    <!-- Dependências atuais omitidas -->

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-devtools</artifactId>
      <optional>true</optional>
    </dependency>

  </dependencies>
  <!-- Código posterior omitido -->
```

### Restart automático

Aplicativos que usam ```spring-boot-devtools``` são reiniciados automaticamente sempre que os arquivos no caminho de classe são alterados. Isso pode ser um recurso útil ao trabalhar em um IDE, pois fornece um loop de feedback muito rápido para alterações de código. Por padrão, qualquer entrada no caminho de classe que aponta para uma pasta é monitorada quanto a alterações. Observe que determinados recursos, como ativos estáticos e templates de visualização, não precisam reiniciar o aplicativo para que as alterações sejam percebidas.

### Testando o restart automático

Inclua a dependência do ```spring-boot-devtools``` no ```pom.xml``` do projeto, execute novamente o projeto, altere o valor dos livros e verifique que, mesmo sem reiniciar manualmente a aplicação, as alterações são percebidas ao acessar http://localhost:8080/livros
