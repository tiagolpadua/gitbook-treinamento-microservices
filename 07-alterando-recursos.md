# Alterando Recursos

Ótimo, agora os usuários de nosso microsserviço já podem listar, recuperar e incluir recursos. Chegou a hora de permitirmos a alteração e a exclusão de recursos.

## Alterando um Recurso

A alteração de recursos é muito semelhante a criação, no entanto, utilizamos o método PUT. Outra diferença é que a URL do recurso deve conter o id do livro a ser alterado, por exemplo http://localhost:8080/livros/4 a seguir temos o código proposto:

- ```src/main/java/com/acme/livroservice/LivrosController.java```

```java
// Código atual omitido

// Novidade aqui
import org.springframework.web.bind.annotation.PutMapping;

@RestController
@RequestMapping("/livros")
public class LivrosController {
	
    // Código atual omitido

    // Novidade aqui
    @PutMapping("/{id}")
	public Livro atualizarLivro(@RequestBody Livro livro, @PathVariable Long id) {
		logger.info("atualizarLivro: " + livro + " id: " + id);
		Livro livroSalvo = listaLivros.stream().filter(l -> l.getId().equals(id)).findFirst()
			.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
		
		livroSalvo.setAutor(livro.getAutor());
		livroSalvo.setPreco(livro.getPreco());
		livroSalvo.setTitulo(livro.getTitulo());

		return livroSalvo;
	}
}
```

Teste a funcionalidade utilizando o RESTClient, pra isso, altere um recurso existente e em seguida o recupere para verificar se as alterações foram realmente persistidas, em seguida, tente alterar um recurso inexistente e veja se o microsserviço está devolvendo um erro correspondente adequado.

## Excluindo um recurso

Falta pouco para completarmos as funcionalidades do CRUD (Create Retrieve Update Delete) de nosso microsserviço, mas ainda precisamos ser capazes de excluir livros, faremos isso agora, é uma funcionalidade simples dado o que já fizemos anteriormente.

O método HTTP utilizado para se apagar um recurso é o DELETE, vejamos como ficará nosso código:

```java
// Código atual omitido

// Novidade aqui
import org.springframework.web.bind.annotation.DeleteMapping;

@RestController
@RequestMapping("/livros")
public class LivrosController {
	
    // Código atual omitido

    // Novidade aqui
	@DeleteMapping("/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void excluirLivro(@PathVariable Long id) {
		logger.info("excluirLivro: " + id);
		
		Livro livro = listaLivros.stream().filter(l -> l.getId().equals(id)).findFirst()
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
		
		listaLivros.remove(livro);
	}
}
```
