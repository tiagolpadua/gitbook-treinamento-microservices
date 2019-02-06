# Cadastrando um livro de forma assíncrona

## Spring AMQP

O projeto Spring AMQP aplica os principais conceitos do Spring ao desenvolvimento de soluções de mensagens baseadas no AMQP. Ele fornece um "modelo" como uma abstração de alto nível para enviar e receber mensagens. Ele também fornece suporte para POJOs orientados por mensagens com um "listener container". Essas bibliotecas facilitam o gerenciamento de recursos do AMQP enquanto promovem o uso de injeção de dependência e configuração declarativa.

O projeto consiste em duas partes; O spring-amqp é a abstração base e o spring-rabbit é a implementação do RabbitMQ.

![](../assets/02-spring-amqp-robbitmq-1.png)

## Criando um cadastro de livro que "demora"

Em nosso controller vamos adicionar um método que cadastra um livro mas que demora a responder:

Agora vamos ajustar o controller de fato:

- `src/main/java/com/acme/livroservice/LivrosController.java`

```java
// Código atual omitido
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/livros")
public class LivrosController {

    // Código atual omitido
	@PostMapping("/demorado")
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivroDemorado(@RequestBody Livro livro) throws InterruptedException {
		return salvarLivroDemorado(livro);
	}
	
	public Livro salvarLivroDemorado(Livro livro) throws InterruptedException {
		logger.info("adicionarLivroDemorado iniciou: " + livro);
		TimeUnit.SECONDS.sleep(3);
		Livro livroSalvo = repository.save(livro);
		logger.info("adicionarLivroDemorado terminou: " + livroSalvo);
		return livroSalvo;
	}
}
```

Utilizando o RESTClient do Firefox, veja se realmente o livro está sendo salvo mas a requisição deve estar demorando 3 segundos para responder.

## Um cenário para a utilização de filas

Vamos imaginar que temos um problema que é o tempo de processamento do salvamento dos livros está demorando, para resolver isso, podemos fazer com que nossa aplicação, ao receber a solicitação de cadastramento de um livro, envie esta solicitação para uma fila e responda imediatamente ao solicitante. A fila será processada na medida da disponibilidade dos recursos. Utilizaremos o RabbitMQ para esta funcionalidade.

## Adicionando Dependências ao `pom.xml` de Nossa Aplicação

Vamos incluir as depenências `spring-boot-starter-amqp` em nosso `pom.xml`:

- `pom.xml`

```xml
  <!-- Código anterior omitido -->
  <dependencies>
    
    <!-- Dependências atuais omitidas -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>

  </dependencies>
  <!-- Código posterior omitido -->
```

Agora vamos criar algumas constantes que nos auxiliarão no restante do processo:

```java
package com.acme.livroservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LivroServiceApplication {

    // Novidades aqui
	static final String MATRICULA = "NNNNNNNN";
	static final String LIVRO_DIRECT_EXCHANGE_NAME = "livro-direct-exchange-" + MATRICULA;
	static final String CADASTRAR_LIVRO_QUEUE_NAME = "cadastrar_livro_queue_" + MATRICULA;
	static final String CADASTRAR_LIVRO_ROUTING_KEY = "livro.cadastrar." + MATRICULA;
	
	public static void main(String[] args) {
		SpringApplication.run(LivroServiceApplication.class, args);
	}
}
```

## Crie um receptor de mensagem RabbitMQ

Com qualquer aplicativo baseado em mensagens, você precisa criar um receptor que responda às mensagens publicadas.

- `src/main/java/com/acme/livroservice/Receiver.java`

```java
package com.acme.livroservice;

import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class Receiver {
	Logger logger = LoggerFactory.getLogger(Receiver.class);

	@RabbitListener(queues = LivroServiceApplication.CADASTRAR_LIVRO_QUEUE_NAME)
	public void receiveMessageCadastrarLivro(String message) throws InterruptedException {
		logger.info("Recebeu <" + message + ">");
	}
}
```

O **Receiver** é um POJO simples que define um método para receber mensagens. Poderia ser utilizado qualquer outro nome desejado. **@RabbitListener** é uma anotação utilizada para mapear mensagens destinadas a determinada fila.

## Enviando as mensagens

Agora, ajustaremos nosso controller para que envie as mensagens ao *broker*:

- `src/main/java/com/acme/livroservice/LivrosController.java`

```java
package com.acme.livroservice;

// Novidade aqui
import org.springframework.amqp.rabbit.core.RabbitTemplate;

// Código atual omitido

@RestController
@RequestMapping("/livros")
public class LivrosController {

	Logger logger = LoggerFactory.getLogger(LivrosController.class);

	private final LivroRepository repository;
	
    // Novidade aqui
	private final RabbitTemplate rabbitTemplate;

    // Novidade aqui
	LivrosController(LivroRepository repository, RabbitTemplate rabbitTemplate) {
		this.repository = repository;
		this.rabbitTemplate = rabbitTemplate;
	}

    // Código atual omitido
	
    // Novidade aqui
	@PostMapping("/async/direct")
	@ResponseStatus(HttpStatus.CREATED)
	public void adicionarLivroAsyncDirect(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroAsyncDirect iniciou: " + livro);
		rabbitTemplate.convertAndSend(LivroServiceApplication.LIVRO_DIRECT_EXCHANGE_NAME, LivroServiceApplication.CADASTRAR_LIVRO_ROUTING_KEY, livro.toString());
        logger.info("adicionarLivroAsyncDirect terminou");
	}
}
```

## Configurando o endereço do broker

A configuração do endereço do broker é feita no arquivo `application.properties`, deixaremos o log com nível `DEBUG` para que possamos ver as mensagens que estão sendo enviadas.

**/src/main/resources/application.properties**

```
logging.level.org.springframework.amqp=DEBUG
spring.rabbitmq.host=[IP-DO-HOST]
```

## Criando as Exchanges, Queues e Bindings

O próximo passo é realizar a criação das Exchanges, Queues e Bindings via interface de administração do RabbitMQ: http://[IP-DO-HOST]:15672

- Crie uma Direct Exchange com o nome: `livro-direct-exchange-NNNNNNNN`
- Crie uma Queue com o nome: `livro_queue_NNNNNNNN`
- Crie um Binding entre a exchange e a queue com o valor: `livro.cadastrar.NNNNNNNN`

(substitua NNNNNNNN pela sua matrícula)

## Testando o envio de mensagens

Ótimo, agora já é possível ver as mensagens sendo enviadas e processadas por nossa aplicação.

```
2019-02-05 22:34:49.390  INFO 19352 --- [nio-8080-exec-2] com.acme.livroservice.LivrosController   : adicionarLivroAssincrono iniciou: Livro [id=null, autor=string, titulo=string, preco=0.0]
2019-02-05 22:34:49.391 DEBUG 19352 --- [nio-8080-exec-2] o.s.amqp.rabbit.core.RabbitTemplate      : Executing callback RabbitTemplate$$Lambda$907/0x000000080086cc40 on RabbitMQ Channel: Cached Rabbit Channel: AMQChannel(amqp://guest@127.0.0.1:5672/,2), conn: Proxy@587878da Shared Rabbit Connection: SimpleConnection@199a59d7 [delegate=amqp://guest@127.0.0.1:5672/, localPort= 56092]
2019-02-05 22:34:49.391 DEBUG 19352 --- [nio-8080-exec-2] o.s.amqp.rabbit.core.RabbitTemplate      : Publishing message (Body:'Livro [id=null, autor=string, titulo=string, preco=0.0]' MessageProperties [headers={}, contentType=text/plain, contentEncoding=UTF-8, contentLength=55, deliveryMode=PERSISTENT, priority=0, deliveryTag=0])on exchange [cadastrar_livro_queue_NNNNNNNN], routingKey = [livro.cadastrar.NNNNNNNN]
2019-02-05 22:34:49.391  INFO 19352 --- [nio-8080-exec-2] com.acme.livroservice.LivrosController   : adicionarLivroAssincrono terminou
2019-02-05 22:34:49.405 DEBUG 19352 --- [pool-3-thread-5] o.s.a.r.listener.BlockingQueueConsumer   : Storing delivery for consumerTag: 'amq.ctag-0Sunur9xyt4x5ovgRsD5Qg' with deliveryTag: '2' in Consumer@50dd38ea: tags=[[amq.ctag-0Sunur9xyt4x5ovgRsD5Qg]], channel=Cached Rabbit Channel: AMQChannel(amqp://guest@127.0.0.1:5672/,1), conn: Proxy@587878da Shared Rabbit Connection: SimpleConnection@199a59d7 [delegate=amqp://guest@127.0.0.1:5672/, localPort= 56092], acknowledgeMode=AUTO local queue size=0
2019-02-05 22:34:49.406 DEBUG 19352 --- [cTaskExecutor-1] o.s.a.r.listener.BlockingQueueConsumer   : Received message: (Body:'Livro [id=null, autor=string, titulo=string, preco=0.0]' MessageProperties [headers={}, contentType=text/plain, contentEncoding=UTF-8, contentLength=0, receivedDeliveryMode=PERSISTENT, priority=0, redelivered=false, receivedExchange=cadastrar_livro_queue_NNNNNNNN, receivedRoutingKey=livro.cadastrar.NNNNNNNN, deliveryTag=2, consumerTag=amq.ctag-0Sunur9xyt4x5ovgRsD5Qg, consumerQueue=cadastrar_livro_queue_NNNNNNNN])
2019-02-05 22:34:49.406 DEBUG 19352 --- [cTaskExecutor-1] .a.r.l.a.MessagingMessageListenerAdapter : Processing [GenericMessage [payload=Livro [id=null, autor=string, titulo=string, preco=0.0], headers={amqp_receivedDeliveryMode=PERSISTENT, amqp_receivedRoutingKey=livro.cadastrar.NNNNNNNN, amqp_contentEncoding=UTF-8, amqp_receivedExchange=cadastrar_livro_queue_NNNNNNNN, amqp_deliveryTag=2, amqp_consumerQueue=cadastrar_livro_queue_NNNNNNNN, amqp_redelivered=false, id=1f7b0044-9de5-3537-4ce3-69a3ca5bba9d, amqp_consumerTag=amq.ctag-0Sunur9xyt4x5ovgRsD5Qg, contentType=text/plain, timestamp=1549413289406}]]
2019-02-05 22:34:49.406  INFO 19352 --- [cTaskExecutor-1] com.acme.livroservice.LivrosController   : Recebeu <Livro [id=null, autor=string, titulo=string, preco=0.0]>
2019-02-05 22:34:52.406  INFO 19352 --- [cTaskExecutor-1] com.acme.livroservice.LivrosController   : Processou <Livro [id=null, autor=string, titulo=string, preco=0.0]>
```

## Envio de objetos na mensagem

Um payload de uma mensagem é um array de bytes, deste modo, podemos enviar representações serializadas do objeto e recebê-las para facilitar o processamento, vamos fazer uma alteração e permitir que o objeto "Livro" seja enviado serializado na mensagem.

O primeiro passo é tornar o Livro um objeto serializável:

- `/src/main/java/com/acme/livroservice/Livro.java`

```java
package com.acme.livroservice;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
// Novidade aqui
public class Livro implements Serializable {
	private static final long serialVersionUID = 1L;

    // Código atual omitido
}
```

Vamos ajustar em seguida a classe `LivrosController` para que faça o envio de uma instância do próprio Livro e não sua representação textual:

- `src/main/java/com/acme/livroservice/LivrosController.java`

```java
// Código atual omitido
public class LivrosController {

    // Código atual omitido
    @PostMapping("/async/direct")
	@ResponseStatus(HttpStatus.CREATED)
	public void adicionarLivroAsyncDirect(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroAsyncDirect iniciou: " + livro);
		rabbitTemplate.convertAndSend(LivroServiceApplication.LIVRO_DIRECT_EXCHANGE_NAME, LivroServiceApplication.CADASTRAR_LIVRO_ROUTING_KEY, livro);
	}
}
```

O `Receiver` também deve ser ajustado, e agora já poderá fazer a persistência do objeto recebido:

- `src/main/java/com/acme/livroservice/Receiver.java`

```java
package com.acme.livroservice;

import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class Receiver {

	Logger logger = LoggerFactory.getLogger(Receiver.class);

	private final LivroRepository repository;

	Receiver(LivroRepository repository) {
		this.repository = repository;
	}

	@RabbitListener(queues = LivroServiceApplication.CADASTRAR_LIVRO_QUEUE_NAME)
	public void receiveMessage(Livro livro) throws InterruptedException {
		logger.info("Recebeu <" + livro.toString() + ">");
		TimeUnit.SECONDS.sleep(3);
		repository.save(livro);
		logger.info("Processou <" + livro.toString() + ">");
	}
}
```

Se consultar o log, verá que agora o conteúdo enviado é bem diferente, em especial o **contentType=application/x-java-serialized-object**:

```
2019-02-05 22:48:10.227 DEBUG 18832 --- [nio-8080-exec-9] o.s.amqp.rabbit.core.RabbitTemplate      : Publishing message (Body:'[B@74824f3b(byte[243])' MessageProperties [headers={}, contentType=application/x-java-serialized-object, contentLength=243, deliveryMode=PERSISTENT, priority=0, deliveryTag=0])on exchange [cadastrar_livro_queue_NNNNNNNN], routingKey = [livro.cadastrar.NNNNNNNN]
```

Conseguimos enviar o objeto ao *broker*, recebê-lo em seguida e fazer sua persistência no banco. Porém estamos trafegando dados binários, o que dificulta a integração de nossa aplicação com outras tecnologias (talvez um serviço *NodeJS* poderia enviar o livro para persistência).

Para evitar este problema, iremos alterar novamente o projeto para que o Livro seja enviado no formato JSON.

Em `LivroServiceApplication` devemos incluir os métodos **producerJackson2MessageConverter** e **rabbitTemplate**:

**src/main/java/com/acme/livroservice/LivroServiceApplication.java**

```java
package com.acme.livroservice;

import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class LivroServiceApplication {

	static final String MATRICULA = "NNNNNNNN";
	static final String LIVRO_DIRECT_EXCHANGE_NAME = "livro-direct-exchange-" + MATRICULA;
	static final String CADASTRAR_LIVRO_QUEUE_NAME = "cadastrar_livro_queue_" + MATRICULA;
	static final String CADASTRAR_LIVRO_ROUTING_KEY = "livro.cadastrar." + MATRICULA;

	@Bean
	public RabbitTemplate rabbitTemplate(final ConnectionFactory connectionFactory,
			MessageConverter producerJackson2MessageConverter) {
		final RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
		rabbitTemplate.setMessageConverter(producerJackson2MessageConverter);
		return rabbitTemplate;
	}

	@Bean
	public Jackson2JsonMessageConverter producerJackson2MessageConverter() {
		return new Jackson2JsonMessageConverter();
	}

	public static void main(String[] args) {
		SpringApplication.run(LivroServiceApplication.class, args);
	}
}
```

Tudo deve continuar funcionando como antes, porém, ao incluirmos um livro, a saída do log deve conter algo como **contentType=application/json**:

```
2019-02-05 22:51:17.948 DEBUG 23344 --- [nio-8080-exec-1] o.s.amqp.rabbit.core.RabbitTemplate      : Publishing message (Body:'{"id":null,"autor":"string","titulo":"string","preco":0.0}' MessageProperties [headers={__TypeId__=com.acme.livroservice.Livro}, contentType=application/json, contentEncoding=UTF-8, contentLength=58, deliveryMode=PERSISTENT, priority=0, deliveryTag=0])on exchange [cadastrar_livro_queue_NNNNNNNN], routingKey = [livro.cadastrar.NNNNNNNN]
```

Perceba que o conteúdo do `Body` é um JSON e `contentType` agora é `application/json`.

## Distribuindo a carga de trabalho

Levante mais duas instâncias do microsserviço em portas distintas e faça novamente a solicitação de cadastro de livro assíncrono, perceba que o trabalho é distribuído entre as instâncias:

```
$ java -jar livro-service-0.0.1-SNAPSHOT.jar --server.port=7081
$ java -jar livro-service-0.0.1-SNAPSHOT.jar --server.port=7082
```

## Excluindo livros de forma assíncrona

Faça o mesmo agora para a funcionalidade de exclusão de livros, para isso, crie um end-point de exclusão de livros assíncrono, uma queue, um binding e um novo método no receiver.

## Excluindo avaliações de um livro de forma assíncrona

Já que estamos excluindo os livros de forma assíncrona, seria interessante também realizar a exclusão das avaliações relacionadas a este livro de forma assíncrona.

## Multicast de Mensagens

Para exercitarmos o envio de mensagens em "multicast", podemos utilizar o padrão fanout de exchange, para isso, podemos utilizar o recurso de criação programática de Exchanges/Queues/Bindings do RabbitMQ.

Primeiro, vamos ajustar **LivroServiceApplication**:

```java
package com.acme.livroservice;

// Código atual omitido

@SpringBootApplication
public class LivroServiceApplication {

	static final String MATRICULA = "NNNNNNNN";
	static final String LIVRO_DIRECT_EXCHANGE_NAME = "livro-direct-exchange-" + MATRICULA;
	static final String LIVRO_FANOUT_EXCHANGE_NAME = "livro-fanout-exchange";
	static final String CADASTRAR_LIVRO_QUEUE_NAME = "cadastrar_livro_queue_" + MATRICULA;
	static final String CADASTRAR_LIVRO_ROUTING_KEY = "livro.cadastrar." + MATRICULA;

    // Novidades aqui
	static final String EXCLUIR_LIVRO_QUEUE_NAME = "excluir_livro_queue_" + MATRICULA;
	static final String EXCLUIR_LIVRO_ROUTING_KEY = "livro.excluir." + MATRICULA;

	@Bean
	public Queue cadastrarLivroQueue() {
		return new Queue(CADASTRAR_LIVRO_QUEUE_NAME);
	}

	@Bean
	public FanoutExchange fanoutExchange() {
		return new FanoutExchange(LIVRO_FANOUT_EXCHANGE_NAME);
	}

	@Bean
	public Binding binding(Queue cadastrarLivroQueue, FanoutExchange fanoutExchange) {
		return BindingBuilder.bind(cadastrarLivroQueue).to(fanoutExchange);
	}

    // Código atual omitido
}
```

Agora vamos ajustar o controller para que tenha um método de publicação de mensagens multicast:

- `src/main/java/com/acme/livroservice/LivrosController.java`

```java
// Código atual omitido
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/livros")
public class LivrosController {

    // Código atual omitido

    // Novidade aqui
	@PostMapping("/async/fanout")
	@ResponseStatus(HttpStatus.CREATED)
	public void adicionarLivroAsyncFanout(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroAsyncFanout iniciou: " + livro);
		rabbitTemplate.convertAndSend(LivroServiceApplication.LIVRO_FANOUT_EXCHANGE_NAME, "*", livro);
		logger.info("adicionarLivroAsyncFanout terminou");
	}
}
```

## Mensagens por tópico

Já implementamos um cadastro de livros via *direct exchanges*, *fanout exchanges* e agora, iremos fazer o mesmo utilizando uma *topic exchange*.


<!--
LivrosController

package com.acme.livroservice;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.data.jpa.domain.Specification;
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
	private final RabbitTemplate rabbitTemplate;

	LivrosController(LivroRepository repository, RabbitTemplate rabbitTemplate) {
		this.repository = repository;
		this.rabbitTemplate = rabbitTemplate;
	}

	@GetMapping
	public List<Livro> getLivros(@RequestParam("autor") Optional<String> autor,
			@RequestParam("titulo") Optional<String> titulo) {
		logger.info(
				"getLivros - autor: " + autor.orElse("Não informado") + " titulo: " + titulo.orElse("Não informado"));

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

	@GetMapping("/{id}")
	public Livro getLivroPorId(@PathVariable Long id) {
		logger.info("getLivroPorId: " + id);
		return repository.findById(id)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
	}

	@PostMapping
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivro(@RequestBody Livro livro) {
		logger.info("adicionarLivro: " + livro);
		return repository.save(livro);
	}
	
	@PostMapping("/demorado")
	@ResponseStatus(HttpStatus.CREATED)
	public Livro adicionarLivroDemorado(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroDemorado iniciou: " + livro);
		TimeUnit.SECONDS.sleep(3);
		Livro livroSalvo = repository.save(livro);
		logger.info("adicionarLivroDemorado terminou: " + livroSalvo);
		return livroSalvo;
	}
	
	@PostMapping("/assincrono")
	@ResponseStatus(HttpStatus.CREATED)
	public void adicionarLivroAssincrono(@RequestBody Livro livro) throws InterruptedException {
		logger.info("adicionarLivroAssincrono iniciou: " + livro);
		rabbitTemplate.convertAndSend(LivroServiceApplication.CADASTRAR_LIVRO_QUEUE_NAME, LivroServiceApplication.CADASTRAR_LIVRO_ROUTING_KEY, livro);
        logger.info("adicionarLivroAssincrono terminou");
	}

	@PutMapping("/{id}")
	public Livro atualizarLivro(@RequestBody Livro livro, @PathVariable Long id) {
		logger.info("atualizarLivro: " + livro + " id: " + id);
		return repository.findById(id).map(livroSalvo -> {
			livroSalvo.setAutor(livro.getAutor());
			livroSalvo.setTitulo(livro.getTitulo());
			livroSalvo.setPreco(livro.getPreco());
			return repository.save(livroSalvo);
		}).orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Livro não encontrado: " + id));
	}

	@DeleteMapping("/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void excluirLivro(@PathVariable Long id) {
		logger.info("excluirLivro: " + id);
		repository.deleteById(id);
	}
	
	@DeleteMapping("/assincrono/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void excluirLivroAssincrono(@PathVariable Long id) {
		logger.info("excluirLivroAssincrono iniciou: " + id);
		rabbitTemplate.convertAndSend(LivroServiceApplication.EXCLUIR_LIVRO_QUEUE_NAME, LivroServiceApplication.EXCLUIR_LIVRO_ROUTING_KEY, id);
        logger.info("excluirLivroAssincrono terminou");
	}
}


LivroServiceApplication

package com.acme.livroservice;

import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class LivroServiceApplication {

	static final String MATRICULA = "NNNNNNNN";
	static final String LIVRO_DIRECT_EXCHANGE_NAME = "livro-direct-exchange-" + MATRICULA;
	static final String CADASTRAR_LIVRO_QUEUE_NAME = "cadastrar_livro_queue_" + MATRICULA;
	static final String CADASTRAR_LIVRO_ROUTING_KEY = "livro.cadastrar." + MATRICULA;
	
	static final String EXCLUIR_LIVRO_QUEUE_NAME = "excluir_livro_queue_" + MATRICULA;
	static final String EXCLUIR_LIVRO_ROUTING_KEY = "livro.excluir." + MATRICULA;

	@Bean
	public RabbitTemplate rabbitTemplate(final ConnectionFactory connectionFactory,
			MessageConverter producerJackson2MessageConverter) {
		final RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
		rabbitTemplate.setMessageConverter(producerJackson2MessageConverter);
		return rabbitTemplate;
	}

	@Bean
	public Jackson2JsonMessageConverter producerJackson2MessageConverter() {
		return new Jackson2JsonMessageConverter();
	}

	public static void main(String[] args) {
		SpringApplication.run(LivroServiceApplication.class, args);
	}
}

Receiver

package com.acme.livroservice;

import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class Receiver {
	Logger logger = LoggerFactory.getLogger(LivrosController.class);

	private final LivroRepository repository;

	Receiver(LivroRepository repository) {
		this.repository = repository;
	}

	@RabbitListener(queues = LivroServiceApplication.CADASTRAR_LIVRO_QUEUE_NAME)
	public void receiveMessageCadastrarLivro(Livro livro) throws InterruptedException {
		logger.info("Recebeu <" + livro.toString() + ">");
		TimeUnit.SECONDS.sleep(3);
		repository.save(livro);
		logger.info("Processou <" + livro.toString() + ">");
	}
	
	@RabbitListener(queues = LivroServiceApplication.EXCLUIR_LIVRO_QUEUE_NAME)
	public void receiveMessageExcluirLivro(Long id) throws InterruptedException {
		logger.info("Recebeu para exclusão id: <" + id + ">");
		TimeUnit.SECONDS.sleep(3);
		repository.deleteById(id);
		logger.info("Processou exclusão do id: <" + id + ">");
	}
}
-->


> Para desabilitar temporariamente o RabbitMQ e evitar erros de conexão durante o restante do treinamento, anote a classe Receiver com `@Profile("disabled")`

## Fontes

- https://spring.io/projects/spring-amqp
- https://spring.io/guides/gs/messaging-rabbitmq/
- https://thepracticaldeveloper.com/2016/10/23/produce-and-consume-json-messages-with-spring-boot-amqp/
- https://springbootdev.com/2017/09/15/spring-boot-and-rabbitmq-direct-exchange-example-messaging-custom-java-objects-and-consumes-with-a-listener/
