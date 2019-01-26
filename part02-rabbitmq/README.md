# RabbitMQ

RabbitMQ é um servidor de mensageria de código aberto (open source) desenvolvido em Erlang, implementado para suportar mensagens em um protocolo denominado Advanced Message Queuing Protocol (AMQP). Ele possibilita lidar com o tráfego de mensagens de forma rápida e confiável, além de ser compatível com diversas linguagens de programação, possuir interface de administração nativa e ser multiplataforma.

Dentre as aplicabilidades do RabbitMQ estão possibilitar a garantia de assincronicidade entre aplicações, diminuir o acoplamento entre aplicações, distribuir alertas, controlar fila de trabalhos em background.

## Outras características do RabbitMQ:

- É desenvolvido em Erlang;
- É considerado rápido e confiável;
- Compatível com os principais sistemas operacionais;
- Suporta diversas plataformas de desenvolvimento. Bibliotecas de conexão com o RabbitMQ estão disponíveis em diversas linguagens de programação;

## Visão Geral

O RabbitMQ é um *message broker*: recebe e encaminha mensagens. Você pode pensar como uma agência dos correios: quando você coloca a carta que deseja postar em uma caixa postal, pode ter certeza de que o carteiro entregará a correspondência ao seu destinatário. Nessa analogia, o RabbitMQ é uma caixa postal, um correio e um carteiro.

A principal diferença entre o RabbitMQ e os correios é que ele não lida com papel, ao invés disso ele aceita, armazena e envia dados binários - mensagens.

## Principais Conceitos

*Produzir* significa nada mais que enviar. Um programa que envia mensagens é um *produtor*:

![Producer](../assets/02-producer.png)

Uma *fila* (queue) é o nome de uma caixa postal que vive no RabbitMQ. Embora as mensagens fluam pelo RabbitMQ e suas aplicações, elas só podem ser armazenadas em uma fila. Uma fila só é limitada pelos limites de memória e disco do host, é essencialmente um grande buffer de mensagem. Muitos *produtores* podem enviar mensagens para uma fila e muitos *consumidores* podem tentar receber dados de uma fila. É assim que representamos uma fila:

![Producer](../assets/02-queue.png)

*Consumir* tem um significado semelhante ao receber. Um consumidor é um programa que espera principalmente receber mensagens:

![Consumer](../assets/02-consumer.png)

Observe que o produtor, o consumidor e o broker não precisam residir no mesmo host; na verdade, na maioria das aplicações eles não residem. Uma aplicação pode ser produtora e consumidora também.

No diagrama abaixo, "P" é nosso produtor e "C" é nosso consumidor. A caixa no meio é uma fila - um buffer de mensagem que o RabbitMQ mantém para o consumidor.

![Diagram](../assets/02-python-one.png)


-----------------------------------------


"Olá Mundo"
(usando o cliente Java)
Nesta parte do tutorial, vamos escrever dois programas em Java; um produtor que envia uma única mensagem e um consumidor que recebe mensagens e as imprime. Vamos passar alguns detalhes na API Java, concentrando-nos nesta coisa muito simples apenas para começar. É um "Hello World" de mensagens.

(P) -> [|||] -> (C)
A biblioteca cliente Java
O RabbitMQ fala vários protocolos. Este tutorial usa o AMQP 0-9-1, que é um protocolo aberto de uso geral para mensagens. Existem vários clientes para o RabbitMQ em muitos idiomas diferentes. Usaremos o cliente Java fornecido pelo RabbitMQ.

Baixe a biblioteca cliente e suas dependências (SLF4J API e SLF4J Simple). Copie esses arquivos em seu diretório de trabalho, junto aos arquivos Java dos tutoriais.

Observe que o SLF4J Simple é suficiente para tutoriais, mas você deve usar uma biblioteca de registro completa como o Logback em produção.

(O cliente RabbitMQ Java também está no repositório central do Maven, com o groupId com.rabbitmq e o artifactId amqp-client.)

Agora temos o cliente Java e suas dependências, podemos escrever algum código.

Envio
(P) -> [|||]
Vamos ligar para o nosso editor de mensagens (remetente) Enviar e nossa mensagem consumidor (receptor) Recv. O editor se conectará ao RabbitMQ, enviará uma única mensagem e sairá.

Em Send.java, precisamos de algumas classes importadas:

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;
Configure a classe e nomeie a fila:

public class Enviar {
  sequência final privada estática QUEUE_NAME = "olá";
  public static void main (String [] argv) gera exceção {
      ...
  }
}
então podemos criar uma conexão com o servidor:

ConnectionFactory factory = novo ConnectionFactory ();
factory.setHost ("localhost");
tente (Connection connection = factory.newConnection ();
     Canal canal = connection.createChannel ()) {

}
A conexão abstrai a conexão do soquete e cuida da negociação e autenticação da versão do protocolo e assim por diante. Aqui nos conectamos a um corretor na máquina local - daí o localhost. Se quiséssemos nos conectar a um corretor em uma máquina diferente, nós simplesmente especificaríamos seu nome ou endereço IP aqui.

Em seguida, criamos um canal, que é onde reside a maior parte da API para fazer as coisas. Note que podemos usar uma instrução try-with-resources porque Connection e Channel implementam java.io.Closeable. Dessa forma, não precisamos fechá-los explicitamente em nosso código.

Para enviar, devemos declarar uma fila para nós enviarmos para; então podemos publicar uma mensagem na fila, tudo isso na declaração try-with-resources:

channel.queueDeclare (QUEUE_NAME, false, false, false, null);
String message = "Olá mundo!";
channel.basicPublish ("", QUEUE_NAME, null, message.getBytes ());
System.out.println ("[x] Enviados" "+ mensagem +" '");
Declarar uma fila é idempotente - ela só será criada se já não existir. O conteúdo da mensagem é uma matriz de bytes, para que você possa codificar o que quiser.

Aqui está toda a classe Send.java.

Envio não funciona!
Se esta é sua primeira vez usando RabbitMQ e você não vê o "Enviado"

## Uso em alta disponibilidade (cluster)

## Fontes
- https://www.rabbitmq.com/tutorials/tutorial-one-java.html
