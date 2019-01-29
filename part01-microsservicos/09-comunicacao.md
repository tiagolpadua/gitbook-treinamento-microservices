# Comunicação entre Microsserviços

## RestTemplate

Nosso serviço de livros já está funcionando e podemos consumir seus dados utilizando um navegador por exemplo, porém uma outra maneira útil de consumir um serviço da web REST é programaticamente. Para ajudá-lo com essa tarefa, o Spring fornece uma classe conveniente chamada `RestTemplate`. O `RestTemplate` torna a interação com a maioria dos serviços RESTful um comando de uma linha. E pode até vincular esses dados a tipos de domínio personalizados.

## Importando o Projeto de Avaliações

Para exemplificar a comunicação entre microsserviços, devemos primeiro importar o projeto `avaliacao-service`, este projeto já está configurado com um microsserviço com funcionalidades de CRUD de avaliações de livros: https://github.com/tiagolpadua/msc-avaliacao-service/archive/inicial.zip

Importe o projeto no Spring Tools Suite, compile e execute. Teste seu funcionamento acessando: http://localhost:8081/avaliacoes

## Obtendo um livro a partir do microsserviço de avaliações

Podemos agora testar a inclusão de uma avaliação utilizando o RESTClient, para isso, realize operações do tipo POST contra o end-point http://localhost:8081/avaliacoes passando no corpo da requisição o seguinte JSON:

```json
{
    "livroId": 2,
    "nota": 1
}
```

Em seguida, liste as avaliações pela URL http://localhost:8081/avaliacoes e verifique que a avaliação foi corretamente inserida.

Agora, tente inserir uma nova avaliação, no entanto, informando um ID de um livro inexistente:

```json
{
    "livroId": 999,
    "nota": 1
}
```

A inclusão da avaliação deverá ser bem sucedida, mas isto é um problema, pois não existe livro com o ID especificado. Nossa demanda agora é ajustar o serviço de inclusão de avaliações para que verifique se o livro realmente existe antes de proceder a inclusão da avaliação.

## Obtendo um JSON simples

Vamos começar de forma simples e realizar uma solicitação GET com um exemplo rápido usando a API `getForEntity()`:

**AvalicacoesController**

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Avaliacao adicionarAvaliacao(@RequestBody Avaliacao avalicacao) {
    logger.info("adicionarAvaliacao: " + avalicacao);

    RestTemplate restTemplate = new RestTemplate();
    String livroResourceUrl = "http://localhost:8080/livros/";
    ResponseEntity<String> response = restTemplate.getForEntity(livroResourceUrl + avalicacao.getLivroId(), String.class);
    
    logger.info("response.getBody(): " + response.getBody());
    
    return repository.save(avalicacao);
}
```

Se observarmos o Log, devemos ver algo como:

```
2019-01-29 16:28:07.187  INFO 2252 --- [nio-8081-exec-1] o.a.c.c.C.[Tomcat-3].[localhost].[/]     : Initializing Spring DispatcherServlet 'dispatcherServlet'
2019-01-29 16:28:07.188  INFO 2252 --- [nio-8081-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2019-01-29 16:28:07.192  INFO 2252 --- [nio-8081-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 4 ms
2019-01-29 16:28:07.195  INFO 2252 --- [nio-8081-exec-1] c.a.a.AvalicacoesController              : adicionarAvaliacao: Avaliacao [id=null, livroId=1, nota=1]
2019-01-29 16:28:07.216  INFO 2252 --- [nio-8081-exec-1] c.a.a.AvalicacoesController              : response.getBody(): {"id":1,"autor":"Miguel de Cervantes","titulo":"Don Quixote","preco":144.0}
Hibernate: 
    call next value for hibernate_sequence
Hibernate: 
    insert 
    into
        avaliacao
        (livro_id, nota, id) 
    values
        (?, ?, ?)
```

Note que os dados do autor do livro foram retornados na forma de uma string JSON.

Observe que temos acesso total à resposta HTTP - para que possamos fazer coisas como verificar o código de status para garantir que a operação seja realmente bem-sucedida ou trabalhar com o corpo real da resposta:

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Avaliacao adicionarAvaliacao(@RequestBody Avaliacao avalicacao) {
    logger.info("adicionarAvaliacao: " + avalicacao);

    RestTemplate restTemplate = new RestTemplate();
    String livroResourceUrl = "http://localhost:8080/livros/";
    ResponseEntity<String> response = restTemplate.getForEntity(livroResourceUrl + avalicacao.getLivroId(), String.class);
    
    logger.info("response.getBody(): " + response.getBody());
    
    // Novidade aqui
    ObjectMapper mapper = new ObjectMapper();
    JsonNode root = mapper.readTree(response.getBody());
    JsonNode autor = root.path("autor");
    
    logger.info("autor: " + autor);

    return repository.save(avalicacao);
}
```

O log deverá conter uma saída como:

```
2019-01-29 16:33:35.485  INFO 2252 --- [io-8081-exec-10] c.a.a.AvalicacoesController              : autor: "Miguel de Cervantes"
```

Estamos trabalhando com o corpo da resposta como uma String padrão aqui - e usando Jackson (e a estrutura de nó JSON que Jackson fornece) para verificar alguns detalhes.

## Recuperando POJO em vez de JSON

Também podemos mapear a resposta diretamente para um Resource DTO, para fazer isso, primeiro (por simplicidade) vamos copiar a classe `Livro` para o projeto de avaliação, e em seguida:

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Avaliacao adicionarAvaliacao(@RequestBody Avaliacao avalicacao) throws IOException {
    logger.info("adicionarAvaliacao: " + avalicacao);

    RestTemplate restTemplate = new RestTemplate();
    String livroResourceUrl = "http://localhost:8080/livros/";
    
    ResponseEntity<Livro> responseLivro = restTemplate.getForEntity(livroResourceUrl + avalicacao.getLivroId(), Livro.class); 
            
    logger.info("responseLivro.getBody(): " + responseLivro.getBody());
    
    return repository.save(avalicacao);
}
```

## Validando se o livro existe

Vamos testar o que ocorrem em dois cenários:

1. O ID livro não existe;
1. O serviço de livros está indisponível;

Para validarmos se o livro de fato existe podemos simplesmente acionar o método e ver se ocorre uma exception:

```java
@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Avaliacao adicionarAvaliacao(@RequestBody Avaliacao avaliacao) throws IOException {
    logger.info("adicionarAvaliacao: " + avaliacao);

    RestTemplate restTemplate = new RestTemplate();
    String livroResourceUrl = "http://localhost:8080/livros/";

    // Novidades aqui
    try {
        restTemplate.getForEntity(livroResourceUrl + avaliacao.getLivroId(), Livro.class);
        logger.error("Livro " + avaliacao.getLivroId() + " localizado");
    } catch (HttpClientErrorException ex) {
        logger.error("Ocorreu um erro na comunicação com o serviço de livros", ex);
        if (ex.getRawStatusCode() == HttpStatus.NOT_FOUND.value()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Livro vinculado a avaliação não foi encontrado.");
        } else {
            throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                    "Ocorreu um erro não esperado na comunicação com o serviço de livros: " + ex.getMessage());
        }
    } catch (ResourceAccessException ex) {
        logger.error("Ocorreu um erro na comunicação com o serviço de livros", ex);
        throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                "Ocorreu um erro não esperado na comunicação com o serviço de livros: " + ex.getMessage());
    }

    return repository.save(avaliacao);
}
```

## Adicionando um timeout

Podemos configurar o RestTemplate para o tempo limite usando ClientHttpRequestFactory, observe que existem vários tipos de timeout a serem configurados:

```java
private ClientHttpRequestFactory getClientHttpRequestFactory() {
    int timeout = 10000;
    HttpComponentsClientHttpRequestFactory clientHttpRequestFactory
        = new HttpComponentsClientHttpRequestFactory();
    clientHttpRequestFactory.setConnectTimeout(timeout);
    clientHttpRequestFactory.setConnectionRequestTimeout(timeout);
    clientHttpRequestFactory.setReadTimeout(timeout);
    return clientHttpRequestFactory;
}

@PostMapping
@ResponseStatus(HttpStatus.CREATED)
public Avaliacao adicionarAvaliacao(@RequestBody Avaliacao avaliacao) throws IOException {
    logger.info("adicionarAvaliacao: " + avaliacao);

    // Novidade aqui
    RestTemplate restTemplate = new RestTemplate(getClientHttpRequestFactory());

    // Código atual omitido
}
```

É necessário também incluir uma nova dependência:

**pom.xml**

```xml
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
</dependency>
```

Para testarmos esta funcionalidade, vamos ajustar `LivrosController` para que atrase a resposta:

**LivrosController**

```java
@GetMapping("/{id}")
public Livro getLivroPorId(@PathVariable Long id) {
    logger.info("getLivroPorId: " + id);

    // Novidade aqui
    try {
        Thread.sleep(5000);
    } catch (InterruptedException ex) {
        Thread.currentThread().interrupt();
    }

    return repository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
}
```

Já temos o serviço de avaliações corretamente configurado para validar a existência dos livros antes de incluir uma avaliação. Agora, temos que realizar a operação inversa, caso um livro seja excluído, é necessário que as avaliações a ele relacionadas também sejam excluídas.

O primeiro passo é ajustar o repositório de avaliações para incluir a função que fará a exclusão:

**AvaliacaoRepository**

```java
package com.acme.avaliacaoservice;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long>, JpaSpecificationExecutor<Avaliacao> {
	@Transactional
	@Modifying
	@Query("delete from Avaliacao a where livroId = ?1")
    void deleteAvaliacaoPorLivroId(Long livroId);
}
```

Agora, vamos criar um end-point REST que irá proceder de fato a exclusão:

**AvalicacoesController**

```java
@DeleteMapping("/livro/{livroId}")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void deleteAvaliacaoPorLivroId(@PathVariable Long livroId) {
    logger.info("deleteAvaliacaoPorLivroId: " + livroId);
    repository.deleteAvaliacaoPorLivroId(livroId);
}
```

Ótimo, agora é a hora de ajustarmos o end-point do serviço de exclusão de livros para acionar o serviço de exclusão de avaliações:

**LivrosController**

```java
@DeleteMapping("/{id}")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void excluirLivro(@PathVariable Long id) {
    logger.info("excluirLivro: " + id);

    RestTemplate restTemplate = new RestTemplate();
    String avaliacaoResourceUrl = "http://localhost:8081/avaliacoes/livro/";

    try {
        restTemplate.delete(avaliacaoResourceUrl + id);
        logger.info("Avaliações vinculadas excluídas com sucesso");
    } catch (ResourceAccessException | HttpClientErrorException ex) {
        logger.error("Ocorreu um erro na comunicação com o serviço de avaliações", ex);
        throw new ResponseStatusException(HttpStatus.SERVICE_UNAVAILABLE,
                "Ocorreu um erro não esperado na comunicação com o serviço de livros: " + ex.getMessage());
    }

    repository.deleteById(id);
}
```

Tudo está funcionando agora, ao excluir um livro, as avaliações relacionadas àquele livro também são excluídas, mas se pararmos para pensar um pouco veremos que ainda existem algumas "pontas soltas":

- O serviço de exclusão de livros aguarda que as avaliações sejam excluídas para então proceder a exclusão do livro, ou seja, é uma operação síncrona, será que isso é realmente necessário?
- Caso a operação de exclusão de avaliações esteja indisponível, a exclusão de livros também ficará, será que realmente é necessário?
