# Principais Conceitos

## O que é o AMQP 0-9-1?

O AMQP 0-9-1 *(Advanced Message Queuing Protocol)* é um protocolo de mensagens que permite que aplicativos clientes se comuniquem com brokers de mensagens.

## O papel dos brokers

Os brokers de mensagens recebem mensagens de *publishers* (aplicativos que as publicam, também conhecidos como *producers*) e os encaminham aos *consumers* (aplicativos que as processam).

Como é um protocolo de rede, os *publishers*, os *consumers* e o *broker* podem residir em máquinas diferentes.

## O modelo AMQP 0-9-1 em resumo

O Modelo AMQP 0-9-1 tem a seguinte visão de mundo: as mensagens são publicadas em *exchanges*, que são frequentemente comparadas a agências postais ou caixas de correio. *Exchanges* então distribuem cópias de mensagens para filas (*queues*) usando regras chamadas *bindings* . Em seguida, os brokers do AMQP entregam mensagens aos consumidores inscritos em filas ou os consumidores buscam/extraem mensagens das filas sob demanda.

![](../assets/02-hello-world-example-routing.png)

Ao publicar uma mensagem, os publicadores podem especificar vários atributos de mensagem (meta-dados da mensagem). Alguns desses metadados podem ser usados ​​pelo *broker*, no entanto, o restante é completamente opaco para o *broker* e é usado apenas pelos aplicativos que recebem a mensagem.

As redes não são confiáveis ​​e os aplicativos podem falhar ao processar mensagens, portanto, o modelo AMQP tem uma noção de confirmações de mensagem (*acknowledgements*): quando uma mensagem é entregue a um consumidor, o consumidor notifica o *broker* automaticamente ou assim que o desenvolvedor do aplicativo optar por fazê-lo. Quando confirmações de mensagem são utilizadas, um *broker* somente removerá completamente uma mensagem de uma fila quando receber uma notificação para essa mensagem (ou grupo de mensagens).

Em determinadas situações, por exemplo, quando uma mensagem não pode ser roteada, as mensagens podem ser devolvidas aos editores, eliminadas ou, se o intermediário *broker* uma extensão, colocadas em uma chamada "fila de devoluções". Os *publishers* escolhem como lidar com situações como essa publicando mensagens usando determinados parâmetros.

Filas, *exchanges* e *bindings* são coletivamente referidas como entidades AMQP .

## O AMQP é um protocolo programável

O AMQP 0-9-1 é um protocolo programável no sentido de que as entidades e os esquemas de roteamento do AMQP 0-9-1 são definidos principalmente pelos próprios aplicativos, não pelo administrador do *broker*. Consequentemente, a provisão é feita para operações de protocolo que declaram filas e *exchanges*, definem *bindings* entre elas, assinam filas e assim por diante.

Isso dá aos desenvolvedores de aplicativos muita liberdade, mas também exige que eles estejam cientes dos possíveis conflitos de definição. Na prática, os conflitos de definição são raros e geralmente indicam um erro de configuração.

As aplicações declaram as entidades do AMQP 0-9-1 de que precisam, definem os esquemas de roteamento necessários e podem optar por excluir as entidades do AMQP 0-9-1 quando elas não são mais usadas.

## Exchanges e tipos de Exchange

As *exchanges* são entidades AMQP nas quais as mensagens são enviadas. As *exchanges* levam uma mensagem e encaminham para zero ou mais filas. O algoritmo de roteamento usado depende do tipo de *exchanges* e das regras chamadas de *bindings*. *Brokers* AMQP 0-9-1 fornecem quatro tipos de *exchange*:

| Nome                | Nomes pré-declarados padrão           |
|---------------------|---------------------------------------|
| Direct exchange     | (String vazia) e amq.direct           |
| Fanout exchange     | amq.fanout                            |
| Topic exchange	  | amq.topic                             |
| Headers exchange    | amq.match (e amq.headers no RabbitMQ) |

Além do tipo de *exchange*, as *exchanges* são declaradas com um número de atributos, sendo os mais importantes:

- Nome
- Durabilidade (se as *exchange* sobrevivem ao reinício do *broker*)
- Exclusão automática (se a *exchange* é excluída quando a última fila é desvinculada dela)
- Argumentos (opcional, usados ​​por plug-ins e recursos específicos do *broker*)

As *exchanges* podem ser duradouras ou transitórias. As *exchanges* duráveis ​​sobrevivem ao reinício do *broker* enquanto as *exchange* transientes não (elas precisam ser redeclaradas quando o *broker* volta a ficar on-line). Nem todos os cenários e casos de uso exigem que as *exchanges* sejam duráveis.

## *Exchange* Padrão

A *exchange* padrão é uma *exchange* direta sem nome (string vazia) pré-declarada pelo *broker*. Ela tem uma propriedade especial que a torna muito útil para aplicativos simples: cada fila criada é automaticamente vinculada a ela com uma chave de roteamento (*routing key*) que é igual ao nome da fila.

Por exemplo, quando você declara uma fila com o nome *"search-indexing-online"*, o *broker* AMQP 0-9-1 irá vinculá-la à *exchange* padrão usando *"search-indexing-online"* como a chave de roteamento. Portanto, uma mensagem publicada na *exchange* padrão com a chave de roteamento *"search-indexing-online"* será roteada para a fila *"search-indexing-online"*. Em outras palavras, a *exchange* padrão faz parecer que é possível entregar mensagens diretamente para as filas, mesmo que isso não seja tecnicamente o que está acontecendo.

## Direct Exchange

Uma *Direct Exchange* envia mensagens para filas com base na chave de roteamento de mensagens. Uma *Direct Exchange* é ideal para o roteamento *unicast* de mensagens (embora elas também possam ser usadas para roteamento *multicast*). Como isso funciona:

- Uma fila liga-se à *exchange* com uma chave de roteamento K
- Quando uma nova mensagem com a chave de roteamento R chega à troca direta, a troca a encaminha para a fila se K = R

As *Direct Exchanges* costumam ser usadas para distribuir tarefas entre vários trabalhadores (instâncias do mesmo aplicativo) de maneira rotativa. Ao fazer isso, é importante entender que, no AMQP 0-9-1, as mensagens são balanceadas por carga entre os consumidores e não entre as filas.

Uma *Direct Exchange* pode ser representada graficamente da seguinte maneira:

![](../assets/02-exchange-direct.png)

## Fanout Exchange

Uma *Fanout Exchange* encaminha mensagens para todas as filas que estão vinculadas a ela e a chave de roteamento é ignorada. Se N filas estiverem vinculadas a uma *Fanout Exchange*, quando uma nova mensagem for publicada nessa *exchange*, uma cópia da mensagem será entregue a todas as filas de N. As *Fanout Exchange* são ideais para o roteamento de transmissão de mensagens.

Como uma *Fanout Exchange* fornece uma cópia de uma mensagem a cada fila vinculada a ela, seus casos de uso são bastante semelhantes:

- Os jogos on-line massivos multi-jogador (MMO) podem usá-la para atualizações de leaderboard ou outros eventos globais
- Os sites de notícias esportivas podem usar *Fanout Exchange* para distribuir atualizações de pontuação para clientes móveis quase em tempo real
- Sistemas distribuídos podem transmitir várias atualizações de estado e configuração
Os bate-papos de grupo podem distribuir mensagens entre os participantes usando uma *Fanout Exchange*

Uma troca de fanout pode ser representada graficamente da seguinte forma: 

![](../assets/02-exchange-fanout.png)

## Topic Exchange

As *Topic Exchanges* encaminham mensagens para uma ou várias filas com base na correspondência entre uma chave de roteamento de mensagem e o padrão que foi usado para ligar uma fila a uma *exchange*. *Topic Exchange* é geralmente usada para implementar várias variações de padrões de *publish/subscribe*. *Topic Exchanges* são comumente usadas para o roteamento *multicast* de mensagens.

As *Topic Exchanges* têm um conjunto muito amplo de casos de uso. Sempre que um problema envolve vários consumidores/aplicativos que selecionam seletivamente o tipo de mensagens que desejam receber, o uso de *Topic Exchange* deve ser considerado.

Exemplos de uso:

- Distribuir dados relevantes para uma localização geográfica específica, por exemplo, pontos de venda
- Processamento de tarefas em segundo plano feito por vários trabalhadores, cada um capaz de lidar com um conjunto específico de tarefas
- Atualizações de preço de ações (e atualizações sobre outros tipos de dados financeiros)
- Atualizações de notícias que envolvem categorização ou marcação (por exemplo, apenas para um determinado esporte ou equipe)
- Orquestração de serviços de diferentes tipos na nuvem
- Arquitetura distribuída / software específico do sistema operacional ou empacotamento em que cada construtor pode manipular apenas uma arquitetura ou sistema operacional

## Headers Exchange

Uma *Headers Exchange* é projetada para roteamento em vários atributos que são mais facilmente expressos como cabeçalhos de mensagens do que uma chave de roteamento. *Headers Exchange* ignoram o atributo de chave de roteamento. Em vez disso, os atributos usados ​​para roteamento são obtidos do atributo *headers*. Uma mensagem é considerada correspondente se o valor do cabeçalho for igual ao valor especificado no *binding*.

É possível vincular uma fila a uma troca de cabeçalhos usando mais de um cabeçalho para correspondência. Nesse caso, o *broker* precisa de mais uma informação do desenvolvedor do aplicativo, ou seja, deve considerar as mensagens com algum dos cabeçalhos correspondentes ou todas elas? É para isso que serve o argumento de ligação "x-match". Quando o argumento "x-match" é definido como "any", apenas um valor de cabeçalho correspondente é suficiente. Alternativamente, definindo "x-match" para "todos" determina que todos os valores devem corresponder.

*Headers Exchange* podem ser encaradas como "trocas diretas turbinadas". Como elas são roteadas com base em valores de cabeçalho, elas podem ser usadas ​​como *direct exchanges*, em que a chave de roteamento não precisa ser uma string; poderia ser um inteiro ou um hash (dicionário) por exemplo.

## Filas (Queues)

As filas no modelo AMQP 0-9-1 são muito semelhantes às filas em outros sistemas de enfileiramento de mensagens e tarefas: elas armazenam mensagens que são consumidas pelos aplicativos. As filas compartilham algumas propriedades com *exchanges*, mas também possuem algumas propriedades adicionais:

- Nome
- Durável (se a fila sobreviverá a uma reinicialização do *broker*)
- Exclusivo (usado por apenas uma conexão e a fila será excluída quando essa conexão for fechada)
- Exclusão automática (a fila que teve pelo menos um consumidor é excluída quando o último consumidor cancela a inscrição)
- Argumentos (opcional; usado por plugins e recursos específicos do *broker*, como mensagem TTL, limite de tamanho da fila, etc)

Antes que uma fila possa ser usada, ela deve ser declarada. Declarar uma fila fará com que ela seja criada se ainda não existir. A declaração não terá efeito se a fila já existir e seus atributos forem os mesmos da declaração. Quando os atributos de fila existentes não são os mesmos da declaração, uma exceção de nível de canal com o código 406 ( ```PRECONDITION_FAILED```) será lançada.

## Nomes de Filas

Os aplicativos podem escolher nomes de filas ou solicitar que o *broker* crie um nome para eles. Os nomes das filas podem ter até 255 bytes de caracteres UTF-8. Um *broker* AMQP 0-9-1 pode gerar um nome de fila exclusivo em nome de um aplicativo. Para usar esse recurso, passe uma string vazia como o argumento do nome da fila. O nome gerado será retornado ao cliente com a resposta da declaração de fila.

Nomes de filas começando com "amq". são reservados para uso interno pelo *broker*. As tentativas de declarar uma fila com um nome que viole essa regra resultarão em uma exceção no nível do canal com o código de resposta 403 (```ACCESS_REFUSED```).

## Durabilidade da fila

As filas duráveis ​​são mantidas em disco e, assim, sobrevivem às reinicializações do *broker*. Filas que não são duráveis ​​são chamadas de transitórias. Nem todos os cenários e casos de uso obrigam as filas a serem duráveis.

A durabilidade de uma fila não torna as mensagens encaminhadas para essa fila duráveis. Se o *broker* sair do ar e, em seguida, retornado, a fila durável será declarada novamente durante a inicialização do *broker*, no entanto, somente as mensagens persistentes serão recuperadas.

## Bindings (Ligações)

Os *bindings* são regras que as *exchanges* usam (entre outras coisas) para rotear mensagens para filas. Para instruir uma *exchange* E para rotear mensagens para uma fila Q, Q tem que ser ligado a E. As *bindings* podem ter um atributo de chave de roteamento opcional usado por alguns tipos de *exchange*. O objetivo da chave de roteamento é selecionar determinadas mensagens publicadas em uma *exchange* para serem roteadas para a fila de ligação. Em outras palavras, a chave de roteamento age como um filtro.

Uma analogia para demonstrar:
- Fila é como o seu destino na cidade de Nova York
- *Exchange* é como o aeroporto JFK
- *Bindings* são rotas de JFK para o seu destino. Pode haver zero ou muitas maneiras de alcançá-lo

Ter essa camada de indirecção permite cenários de roteamento que são impossíveis ou muito difíceis de implementar usando a publicação diretamente em filas e também elimina certa quantidade de trabalho duplicado que os desenvolvedores de aplicativos precisam fazer.

Se a mensagem AMQP não puder ser roteada para qualquer fila (por exemplo, porque não há ligações para a *exchange* para a qual ela foi publicada), ela será eliminada ou retornada ao publicador, dependendo dos atributos da mensagem que o publicador configurou.

## Consumidores

Armazenar mensagens em filas é inútil, a menos que os aplicativos possam consumi-las. No Modelo AMQP 0-9-1, existem duas maneiras de os aplicativos fazerem isso:

- Receber mensagens entregues a eles ("push API")
- Buscar mensagens conforme necessário ("pull API")

Com a "API push", os aplicativos precisam indicar interesse em consumir mensagens de uma fila específica. Quando o fazem, dizemos que registram um consumidor ou, simplesmente, assinam uma fila. É possível ter mais de um consumidor por fila ou registrar um consumidor exclusivo (exclui todos os outros consumidores da fila enquanto está consumindo).

Cada consumidor (assinatura) possui um identificador chamado tag do consumidor. Pode ser usado para cancelar a assinatura de mensagens. Tags de consumidor são apenas strings.

## Mensagem Acknowledgements

Aplicativos do consumidor - aplicativos que recebem e processam mensagens - ocasionalmente podem falhar ao processar mensagens individuais ou, às vezes, travar. Há também a possibilidade de problemas de rede causando problemas. Isso levanta uma questão: quando o broker AMQP deve remover mensagens de filas? A especificação AMQP 0-9-1 propõe duas opções:

- Depois que o *broker* envia uma mensagem para um aplicativo (usando os métodos AMQP ```basic.deliver``` ou ```basic.get-ok```);
- Depois que o aplicativo envia de volta uma confirmação (usando o método AMQP ```basic.ack```).

A primeira opção é chamada de modelo de reconhecimento automático, enquanto a segunda é chamada de modelo de reconhecimento explícito. Com o modelo explícito, o aplicativo escolhe quando é hora de enviar uma confirmação. Pode ser logo após o recebimento de uma mensagem ou após sua persistência em um armazenamento de dados antes do processamento ou após o processamento completo da mensagem (por exemplo, buscar com êxito uma página da Web, processá-la e armazená-la em algum armazenamento de dados persistente).

Se um consumidor morrer sem enviar uma confirmação, o intermediário AMQP o entregará a outro consumidor ou, se nenhum estiver disponível no momento, o agente aguardará até que pelo menos um consumidor seja registrado para a mesma fila antes de tentar a nova entrega.

## Rejeitando Mensagens

Quando um aplicativo consumidor recebe uma mensagem, o processamento dessa mensagem pode ou não ter êxito. Um aplicativo pode indicar ao intermediário que o processamento da mensagem falhou (ou não pode ser realizado no momento) ao rejeitar uma mensagem. Ao rejeitar uma mensagem, um aplicativo pode solicitar ao *broker* que a descarte ou enfileire novamente. Quando houver apenas um consumidor em uma fila, certifique-se de não criar loops infinitos de entrega de mensagens rejeitando e enfileirando novamente uma mensagem do mesmo consumidor repetidas vezes.

## Acknowledgements Negativos

As mensagens são rejeitadas com o método AMQP ```basic.reject```. Há uma limitação que o ```basic.reject``` tem: não há como rejeitar mensagens múltiplas como você pode fazer com os *acknowledgements*. No entanto, se você estiver usando o RabbitMQ, haverá uma solução. O RabbitMQ fornece uma extensão AMQP 0-9-1, conhecida como *negative acknowledgements* ou *nacks*.

## Prefetching de Mensagens

Para casos em que vários consumidores compartilham uma fila, é útil poder especificar quantas mensagens cada consumidor pode enviar de uma vez antes de enviar a próxima confirmação. Isso pode ser usado como uma técnica simples de balanceamento de carga ou para melhorar o rendimento se as mensagens tendem a ser publicadas em lotes. Por exemplo, se um aplicativo de produção enviar mensagens a cada minuto devido à natureza do trabalho que está fazendo.

Observe que o RabbitMQ suporta apenas a *prefetching* no nível do canal, não a conexão ou a *prefetching* baseada no tamanho.

## Atributos de mensagem e payload

Mensagens no modelo AMQP possuem atributos. Alguns atributos são tão comuns que a especificação AMQP 0-9-1 os define e os desenvolvedores de aplicativos não precisam pensar no nome exato do atributo. Alguns exemplos são:

- Tipo de conteúdo
- Codificação de conteúdo
- Chave de roteamento
- Modo de entrega (persistente ou não)
- Prioridade de mensagem
- Timestamp de publicação de mensagem
- Período de Expiração
- ID do aplicativo do editor

Alguns atributos são usados ​​pelos *brokers* do AMQP, mas a maioria está aberta a interpretações por aplicativos que os recebem. Alguns atributos são opcionais e conhecidos como cabeçalhos. Eles são semelhantes aos X-Headers no HTTP. Atributos de mensagem são definidos quando uma mensagem é publicada.

As mensagens AMQP também têm um *payload* (os dados que elas carregam), que os *brokers* do AMQP tratam como uma matriz de bytes opaca. O *broker* não inspecionará ou modificará o *payload*. É possível que as mensagens contenham apenas atributos e nenhum *payload*. É comum usar formatos de serialização como JSON, Thrift, Protocol Buffers e MessagePack para serializar dados estruturados para publicá-los como *payload* da mensagem. Os pares AMQP geralmente usam os campos "content-type" e "content-encoding" para comunicar essas informações, mas isso é apenas por convenção.

As mensagens podem ser publicadas como persistentes, o que faz com que o *broker* do AMQP as mantenha em disco. Se o servidor for reiniciado, o sistema garante que as mensagens persistentes recebidas não sejam perdidas. A simples publicação de uma mensagem em uma *exchange* durável ou o fato de a(s) fila(s) para a qual ela é roteada serem duráveis ​​não torna a mensagem persistente: tudo depende do modo de persistência da própria mensagem. A publicação de mensagens como persistentes afeta o desempenho (assim como ocorre com os armazenamentos de dados, a durabilidade tem um certo custo no desempenho).

## Acknowledgements (confirmação) de Mensagem 

Como as redes não são confiáveis ​​e os aplicativos falham, geralmente é necessário ter algum tipo de confirmação de processamento. Às vezes, é necessário apenas reconhecer o fato de que uma mensagem foi recebida. Às vezes, confirmações significam que uma mensagem foi validada e processada por um consumidor, por exemplo, verificada como tendo dados obrigatórios e persistiu em um armazenamento de dados ou indexada.

Essa situação é muito comum, por isso o AMQP 0-9-1 tem um recurso interno chamado de confirmação de mensagem (às vezes chamado de acks) que os consumidores usam para confirmar a entrega e/ou o processamento da mensagem. Se um aplicativo trava (o *broker* AMQP percebe isso quando a conexão é fechada), se uma confirmação de uma mensagem era esperada mas não recebida pelo intermediário AMQP, a mensagem é reenviada (e possivelmente entregue imediatamente a outro consumidor, se houver existe).

Ter reconhecimentos embutidos no protocolo ajuda os desenvolvedores a construir um software mais robusto.

## Métodos AMQP 0-9-1

O AMQP 0-9-1 é estruturado como um número de métodos. Os métodos são operações (como os métodos HTTP) e não têm nada em comum com métodos em linguagens de programação orientadas a objeto. Os métodos AMQP são agrupados em classes. Classes são apenas agrupamentos lógicos de métodos AMQP. A referência AMQP 0-9-1 contém detalhes completos de todos os métodos AMQP.

Vamos dar uma olhada na classe de *exchanges* , um grupo de métodos relacionados a operações em *exchanges*. Inclui as seguintes operações:

 - ```exchange.declare```
 - ```exchange.declare-ok```
 - ```exchange.delete```
 - ```exchange.delete-ok```

As operações acima formam pares lógicos: ```exchange.declare``` e ```exchange.declare-ok```, ```exchange.delete``` e ```exchange.delete-ok```. Essas operações são "solicitações" (enviadas por clientes) e "respostas" (enviadas por *brokers* em resposta às "solicitações" mencionadas anteriormente).

Na maioria das vezes estes métodos são transparentes ao desenvolvedor uma vez que são utilizados pelas bibliotecas específicas das linguagens para efetuarem a comunicação com os *brokers*.

## Conexões

As conexões AMQP são geralmente de longa duração. O AMQP é um protocolo em nível de aplicativo que usa o TCP para entrega confiável. As conexões AMQP usam autenticação e podem ser protegidas usando TLS (SSL). Quando um aplicativo não precisa mais estar conectado a um *broker* AMQP, ele deve fechar a conexão AMQP de forma controlada em vez de abruptamente.

## Canais

Alguns aplicativos precisam de várias conexões para um *broker* AMQP. No entanto, é indesejável manter muitas conexões TCP abertas ao mesmo tempo, pois isso consome recursos do sistema e dificulta a configuração de *firewalls*. As conexões do AMQP 0-9-1 são multiplexadas com canais que podem ser considerados como "conexões leves que compartilham uma única conexão TCP".

Para aplicativos que usam vários processos/threads para processamento, é muito comum abrir um novo canal por thread/processo e não compartilhar canais entre eles.

A comunicação em um canal específico é completamente separada da comunicação em outro canal, portanto, todo método AMQP também transporta um número de canal que os clientes usam para descobrir para qual canal o método é (e, portanto, qual manipulador de eventos precisa ser chamado, por exemplo) .

## Hosts Virtuais

Para possibilitar que um único broker hospede vários "ambientes" isolados (grupos de usuários, trocas, filas e assim por diante), o AMQP inclui o conceito de hosts virtuais (vhosts). Eles são semelhantes aos hosts virtuais usados ​​por muitos servidores Web populares e fornecem ambientes completamente isolados nos quais as entidades do AMQP residem. Os clientes AMQP especificam quais vhosts eles querem usar durante a negociação de conexão AMQP.

## AMQP é extensível
O AMQP 0-9-1 possui vários pontos de extensão:

- Os tipos de *exchange* personalizados permitem que os desenvolvedores implementem esquemas de roteamento que tipos de troca *exchange* prontos para o uso não cobrem bem, por exemplo, roteamento baseado em geodados;
- A declaração de *exchanges* e filas pode incluir atributos adicionais que o *broker* pode usar. Por exemplo, a mensagem por fila TTL no RabbitMQ é implementada dessa maneira.
- Extensões específicas do *broker* ao protocolo. Por exemplo, extensões que o RabbitMQ implementa;
- Novas classes de método AMQP 0-9-1 podem ser introduzidas;
- Os *brokers* podem ser estendidos com *plug-ins* adicionais, por exemplo, o *frontend* de gerenciamento do RabbitMQ e a API HTTP são implementados como um plug-in;

Esses recursos tornam o Modelo AMQP 0-9-1 ainda mais flexível e aplicável a uma ampla variedade de problemas.

## AMQP 0-9-1 ecossistema de clientes

Existem muitos clientes AMQP 0-9-1 para muitas linguagens e plataformas de programação populares. Alguns deles seguem a terminologia AMQP de perto e apenas fornecem a implementação dos métodos AMQP. Alguns outros possuem recursos adicionais, métodos de conveniência e abstrações. Alguns dos clientes são assíncronos (non-blocking), alguns são síncronos (blocking), alguns suportam ambos os modelos. Alguns clientes suportam extensões específicas do fornecedor (por exemplo, extensões específicas do RabbitMQ).

Como um dos principais objetivos do AMQP é a interoperabilidade, é uma boa idéia que os desenvolvedores entendam as operações do protocolo e não se limitem à terminologia de uma determinada biblioteca cliente. Dessa forma, comunicar-se com os desenvolvedores usando bibliotecas diferentes será significativamente mais fácil.
