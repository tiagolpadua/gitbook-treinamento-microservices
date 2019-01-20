# Adicionando funcionalidades ao microsserviço

Agora que já temos uma base sólida, podemos começar a criar outras funcionalidades ao nosso microsserviço.

## Recuperando um livro específico

Criaremos um serviço que irá aceitar um request HTTP GET para:

```http://localhost:8080/livros/:id```

E responder com a representação JSON como a seguir:

```json
{
  "id": 1,
  "autor": "Don Quixote",
  "titulo": "Miguel de Cervantes",
  "preco": 44
}
```

## Criar mais um método no controlador

Inicialmente vamos apenas incluir um novo método na classe:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
package com.acme.livroservice;

import java.util.ArrayList;
import java.util.List;

// Novidade aqui
import org.springframework.web.bind.annotation.PathVariable;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LivrosController {

	@RequestMapping("/livros")
	public List<Livro> getLivros() {
		// Código atual omitido
	}
	
  // Novidade aqui
	@RequestMapping("/livros/{livroId}")
	public Livro getLivroPorId(@PathVariable Long livroId) {
		System.out.println("livroId: " + livroId);
		Livro l = new Livro(1l, "Don Quixote", "Miguel de Cervantes", 144.0);
		return l;
	}
}
```

Vamos fazer o ```System.out.println("livroId: " + livroId)``` somente para conferir se realmente o parâmetro está sendo capturado.

Com isso, acessando no navegador o endereço http://localhost:8080/livros/1 obtemos o seguinte JSON:

```json
{
  "id": 1,
  "autor": "Don Quixote",
  "titulo": "Miguel de Cervantes",
  "preco": 144
}
```

Muito bem, mas seria mais interessante que tivessémos uma lista de livros em memória e ela pudesse ser utilizada tanto para listar os livros quanto para pesquisar.

Precisamos deixar uma mesma lista de livros disponível para todos os métodos. Poderíamos pensar em manter uma variável estática, porém, o Spring nos fornece uma maneira mais elegante de fazer isso.

## Beans e Escopos

O escopo de um bean define o ciclo de vida e a visibilidade desse bean nos contextos nos quais ele é usado.

O Spring define seis tipos de escopos:
- ***singleton***: Definir um bean com escopo ***singleton*** significa que o contêiner cria uma única instância desse bean, e todas as solicitações para esse nome de bean retornarão o mesmo objeto, que é armazenado em cache. Quaisquer modificações no objeto serão refletidas em todas as referências ao bean. Este escopo é o valor padrão se nenhum outro escopo for especificado;
- ***prototype***: Um bean com escopo de ***prototype*** retornará uma instância diferente toda vez que for solicitado do contêiner;
- ***request***: O escopo de ***request*** cria uma instância de bean para uma única solicitação HTTP;
- ***session***: O escopo de ***session*** é criado para uma sessão HTTP;
- ***application***: O escopo de ***application*** cria a instância do bean para o ciclo de vida de um ```ServletContext```. Isso é semelhante ao escopo singleton, mas há uma diferença muito importante em relação ao escopo do bean. Quando beans tem escopo ***application***, a mesma instância do bean é compartilhada entre vários aplicativos baseados em servlet em execução no mesmo ```ServletContext```, enquanto os beans com escopo singleton para um único contexto de aplicativo;
- ***websocket***: Os beans do escopo do ```WebSocket``` quando acessados pela primeira vez são armazenados nos atributos da sessão do ```WebSocket```. A mesma instância do bean é então retornada sempre que esse bean é acessado durante toda a sessão do ```WebSocket```. Também podemos dizer que exibe comportamento singleton, mas limitado a uma sessão ```WebSocket``` apenas. 

Os últimos quatro escopos mencionados request, session, application e websocket estão disponíveis apenas para aplicativos web.


## Tornando a lista de livros um ```Singleton```

Agora que já entendemos como funcionam os escopos no Spring, podemos tornar nossa lista de livros um ***singleton*** para que possa ser compartilhada em nosso microsserviço.

Primeiramente devemos criar um método ***fábrica*** que será responsável pela criação do bean quando ele for requisitado. Podemos colocar este método diretamente na classe ```LivroServiceApplication```:

- ```src/main/java/com/acme/livroservice/LivroServiceApplication.java```

```java
package com.acme.livroservice;

import java.util.ArrayList;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class LivroServiceApplication {
	
  // Novidade aqui
	@Bean
	public ArrayList<Livro> listaLivros() {
		
		ArrayList<Livro> livros = new ArrayList<Livro>();
		
		Livro l1 = new Livro(1l, "Don Quixote", "Miguel de Cervantes", 144.0);
		Livro l2 = new Livro(2l, "O Senhor dos Anéis", "J. R. R. Tolkien", 123.0);
		Livro l3 = new Livro(3l, "O Pequeno Príncipe", "Antoine de Saint-Exupéry", 152.0);
		Livro l4 = new Livro(4l, "Um Conto de Duas Cidades", "Charles Dickens", 35.0);
		
		livros.add(l1);
		livros.add(l2);
		livros.add(l3);
		livros.add(l4);
		
		return livros;
	}

	public static void main(String[] args) {
		SpringApplication.run(LivroServiceApplication.class, args);
	}

}
```

Agora vamos ajustar nosso ```controller``` para que utilize este bean:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
package com.acme.livroservice;

// Código atual omitido

import javax.annotation.Resource;

@RestController
public class LivrosController {
	
  // Novidade aqui
	@Resource
	private ArrayList<Livro> listaLivros;

	@RequestMapping("/livros")
	public List<Livro> getLivros() {

    // Novidade aqui
		return listaLivros;
	}
	
	@RequestMapping("/livros/{livroId}")
	public Livro getLivroPorId(@PathVariable Long livroId) {
    // Novidade aqui
		return listaLivros.stream().filter(l -> l.getId().equals(livroId)).findFirst().orElse(null);
	}
}
```
