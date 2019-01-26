# Microsserviços

<!-- 
(Fonte https://martinfowler.com/bliki/BoundedContext.html)

O Contexto Delimitado é um padrão central no Design Dirigido por Domínio. É o foco da seção de design estratégico do DDD, que trata de grandes modelos e equipes. O DDD lida com grandes modelos dividindo-os em diferentes contextos limitados e sendo explícito sobre suas inter-relações.

![](assets/01-bounded-context.png)

DDD é sobre projetar software baseado em modelos do domínio. Um modelo funciona como uma "Linguagem Ubíqua" (prática de construir uma linguagem comum e rigorosa entre desenvolvedores e usuários) para ajudar na comunicação entre desenvolvedores de software e especialistas em domínio. Ele também atua como a base conceitual para o design do próprio software - como ele é dividido em objetos ou funções. Para ser eficaz, um modelo precisa ser unificado - isto é, ser internamente consistente para que não haja contradições dentro dele.

À medida que você tenta modelar um domínio maior, fica cada vez mais difícil construir um único modelo unificado. Diferentes grupos de pessoas usarão vocabulários sutilmente diferentes em diferentes partes de uma grande organização. A precisão da modelagem acorre rapidamente a isso, muitas vezes levando a muita confusão. Normalmente, essa confusão se concentra nos conceitos centrais do domínio. No início de minha carreira trabalhei com um utilitário de eletricidade - aqui a palavra "metro" significava coisas sutilmente diferentes para diferentes partes da organização: era a conexão entre a rede e um local, a rede e um cliente, o próprio medidor físico ( que pode ser substituído se estiver com defeito). Esses polissemes sutis poderiam ser suavizados na conversa, mas não no mundo preciso dos computadores. Repetidamente, vejo essa confusão se repetir com polissêmicos como "Cliente" e "Produto".

Naqueles dias mais jovens, fomos aconselhados a construir um modelo unificado de toda a empresa, mas a DDD reconhece que aprendemos que "a unificação total do modelo de domínio para um sistema grande não será viável ou econômica" [1]. Então, ao invés disso, o DDD divide um sistema grande em Contextos Limitados, cada um dos quais pode ter um modelo unificado - essencialmente uma maneira de estruturar o MultipleCanonicalModels.

Os contextos limitados têm conceitos não relacionados (como um ticket de suporte existente apenas em um contexto de suporte ao cliente), mas também compartilham conceitos (como produtos e clientes). Contextos diferentes podem ter modelos completamente diferentes de conceitos comuns, com mecanismos para mapear esses conceitos polissêmicos para integração. Vários padrões de DDD exploram relações alternativas entre contextos.

Vários fatores desenham limites entre os contextos. Normalmente o dominante é a cultura humana, já que os modelos funcionam como Linguagem Ubíqua, você precisa de um modelo diferente quando a linguagem muda. Você também encontra vários contextos dentro do mesmo contexto de domínio, como a separação entre os modelos de banco de dados na memória e relacional em um único aplicativo. Esse limite é definido pela maneira diferente como representamos os modelos.

O design estratégico da DDD segue descrevendo uma variedade de formas de relacionamento entre os Contextos Limitados. Geralmente vale a pena descrevê-los usando um mapa de contexto.
-->

<!--
https://hackernoon.com/microservices-bounded-context-cohesion-what-do-they-have-in-common-1107b70342b3
https://www.eduardopires.net.br/2016/03/ddd-bounded-context/
https://docs.microsoft.com/pt-br/dotnet/standard/microservices-architecture/microservice-ddd-cqrs-patterns/microservice-domain-model
http://www.pedromendes.com.br/2016/01/02/microservicos/ - Microsserviços, por Martin Fowler e James Lewis
-->

## Definição de Microsserviços

Microsserviços são uma abordagem arquitetural para a criação de aplicações. O que diferencia a arquitetura de microsserviços das abordagens monolíticas tradicionais é como ela decompõe a aplicação por funções básicas. Cada função é denominada um serviço e pode ser criada e implantada de maneira independente. Isso significa que cada serviço individual pode funcionar ou falhar sem comprometer os demais.

![](assets/monolithic-vs-microservices.png)

Pense na última vez em que você acessou um site de vendas no varejo. Provavelmente, você usou a barra de pesquisa do site para procurar produtos. Essa pesquisa representa um serviço. Talvez você também tenha visto recomendações de produtos relacionados, extraídas de um banco de dados das preferências dos compradores. Isso também é um serviço. Você adicionou algum item ao carrinho de compras? Isso mesmo, esse é mais um serviço.

Portanto, um microsserviço é uma função essencial de uma aplicação e é executado independentemente dos outros serviços. No entanto, a arquitetura de microsserviços é mais complexa do que o mero acoplamento flexível das funções essenciais de uma aplicação. Trata-se da restruturação das equipes de desenvolvimento e da comunicação entre serviços de modo a preparar a aplicação para falhas inevitáveis, escalabilidade futura e integração de recursos novos.

Como isso é possível? Com a adaptação dos fundamentos da arquitetura orientada a serviço (SOA) para a implantação de microsserviços.

Uma abordagem monolítica:
![](assets/monolithic-approach.jpg)

Uma abordagem de microsserviços:
![](assets/microservices-approach.jpg)

### Isso soa familiar?
Se você conhece o método de decompor aplicações em funções essenciais para evitar os problemas provocados pelas arquiteturas monolíticas é porque o estilo de arquitetura de microsserviços é semelhante ao da arquitetura orientada para serviços (SOA), um já consagrado no desenvolvimento de programas de software.

Nos primórdios do desenvolvimento de aplicações, até mesmo as alterações mais insignificantes em uma aplicação pronta exigiam uma atualização da versão de atacado, com um ciclo próprio de garantia da qualidade (QA). Isso, provavelmente, atrasava o trabalho de muitas subequipes. Muitas vezes, essa abordagem é chamada de “monolítica” porque o código-fonte da aplicação toda era incorporado em uma única unidade de implantação, como .war ou .ear. Se a atualização de alguma das partes causasse erros, era necessário desativar a aplicação inteira, reverter a escala e corrigir o problema. Embora essa abordagem ainda seja viável para aplicações menores, as empresas em ampla expansão não podem se dar ao luxo de sofrer com tempo de inatividade.

A arquitetura orientada a serviço serve pra resolver essa questão, pois estrutura as aplicações em serviços distintos e reutilizáveis que se comunicam por meio de um Enterprise Service Bus (ESB). Nessa arquitetura, os serviços individuais, cada um deles organizado em torno de um processo de negócios específico, aderem a um protocolo de comunicação, como SOAP, ActiveMQ ou Apache Thrift, para que sejam compartilhados por meio do ESB. Quando reunidos, esse pacote de serviços, integrados por meio de um ESB, formam uma aplicação.

Por um lado, isso permite criar, testar e ajustar os serviços de maneira simultânea, eliminando os ciclos de desenvolvimento monolíticos. No entanto, por outro lado, o ESB representa um ponto único de falha no sistema inteiro. Portanto, todo o esforço empregado para eliminar uma estrutura monolítica, de certo modo, serviu apenas para criar outra: o ESB, que potencialmente pode congestionar toda a organização.

### Então, qual é a diferença entre a SOA e a arquitetura de microsserviços?

Os microsserviços podem se comunicar entre si, normalmente sem monitoração de estado. Portanto, as aplicações criadas dessa maneira podem ser mais tolerantes a falhas e depender menos de um único ESB. Além disso, as equipes de desenvolvimento podem escolher as ferramentas que desejarem, pois os microsserviços podem se comunicar por meio de interfaces de programação de aplicações (APIs) independentes de linguagem.

Levando em consideração a história da SOA, os microsserviços não são uma ideia completamente nova. Porém, eles se tornaram mais viáveis graças aos avanços nas tecnologias de containerização. Com os containers Linux, agora é possível executar várias partes de uma aplicação de maneira independente no mesmo hardware e com um controle muito maior sobre os componentes individuais e ciclos de vida.

O maior desafio para a adoção de qualquer arquitetura nova é dar o primeiro passo. Você quer criar aplicações novas ou transformar as antigas? Em ambos os casos, é bom refletir sobre os benefícios e os desafios de criar microsserviços.

### Quais são os benefícios da arquitetura de microsserviços?

Com os microsserviços, suas equipes e tarefas rotineiras podem ser tornar mais eficientes por meio do desenvolvimento distribuído. Além disso, é possível desenvolver vários microsserviços ao mesmo tempo. Isso significa que você pode ter mais desenvolvedores trabalhando simultaneamente na mesma aplicação, o que resulta na redução do tempo gasto com desenvolvimento.

- **Lançamento no mercado com mais rapidez**: Como os ciclos de desenvolvimento são reduzidos, a arquitetura de microsserviços é compatível com implantações e atualizações mais ágeis.

- **Altamente escalável**: À medida que a demanda por determinados serviços aumenta, você pode fazer implantações em vários servidores e infraestruturas para atender às suas necessidades.

- **Resiliente**: Os serviços independentes, se construídos corretamente, não afetam uns aos outros. Isso significa que, se um elemento falhar, o restante da aplicação permanece em funcionamento, diferentemente do modelo monolítico.

- **Fácil de implantar**: Como as aplicações baseadas em microsserviços são mais modulares e menores do que as aplicações monolíticas tradicionais, as preocupações resultantes dessas implantações são invalidadas. Isso requer uma coordenação maior, mas as recompensas podem ser extraordinárias.

- **Acessível**: Como a aplicação maior é decomposta em partes menores, os desenvolvedores tem mais facilidade para entender, atualizar e aprimorar essas partes. Isso resulta em ciclos de desenvolvimento mais rápidos, principalmente quando também são empregadas as tecnologias de desenvolvimento ágil.

- **Mais aberta**: Devido ao uso de APIs poliglotas, os desenvolvedores têm liberdade para escolher a melhor linguagem e tecnologia para a função necessária.

## Apresentação do What - Why - How no contexto de Negócio e Desenvolvimento

### O que é arquitetura? (What)

*A arquitetura é organizar blocos de maneira modular e estruturada. Arquitetura é arte e arquiteto é o artista.*

Tudo requer arquitetura. Todos somos arquitetos em nosso dia a dia. Em nossa casa, estamos organizando nosso material, livros, utensílios de cozinha, tudo o que organizamos de maneira correta é arquitetura. O lojista arruma a loja. Tudo organizado de maneira modular e estruturada é *arquitetura* .

*Arquitetura é uma arte, e na arte temos padrões e estilos. Os estilos e padrões são alterados com base no contexto, domínio e problema.*

A arquitetura de software é "o conjunto de estruturas necessárias para raciocinar sobre o sistema, que incluem elementos de software, relações entre eles e propriedades de ambos".

Uma boa arquitetura de software é descrever os padrões, camadas ou níveis aplicados que são usados ​​para definir a clara separação de interesses do seu negócio.


### Por que isso é necessário? (Why)

Menos é mais. Conforme declarado pela Microsoft, "O objetivo da arquitetura é identificar os requisitos que afetam a estrutura do aplicativo. Uma boa arquitetura reduz os riscos de negócios associados à criação de uma *solução técnica*."

Boa arquitetura é fácil de entender e barata de modificar. O sucesso dos negócios depende da arquitetura.

#### Benefícios da arquitetura

Benefícios que nós sempre nos interessam. Sem benefícios, não há negócios.

Abaixo estão os benefícios que você obterá se seguir estilos e padrões arquiteturais:

1. Alta produtividade
1. Melhor manutenabilidade
1. Alta adaptabilidade
1. Torna mais fácil avaliar e gerenciar mudanças
1. Segurança e escalaboçodade
1. Entregas de maior qualidade a um custo menor

A arquitetura define um conjunto de regras e restrições específicas para um sistema ou projeto. Arquitetura permite o atributo de qualidade do sistema ou podemos dizer que define a qualidade a cada ação.

### Como nós projetamos uma boa arquitetura? (How)

Para se tornar um especialista, precisamos praticar. Prática leva a perfeição.

Existem alguns princípios importantes que precisam ser considerados ao projetar a arquitetura.

1. Senso comum: - (O que é isso?) É uma habilidade básica para perceber, entender e julgar as coisas
1. *O sistema deve ser construído para mudar em vez de construir para durar*
1. Aprenda com sua experiência passada e tendências de tecnologia atuais
1. Há mais jeito do que um para fazer isso. (É útil encontrar a solução otimizada)
1. Entenda o contexto do usuário final e o domínio do negócio
1. Siga os padrões e estilos de design
1. Siga as práticas recomendadas de codificação
1. Entenda o módulo de negócios, submódulo, considere componentes e camadas (camadas) para abstraí-los e identificar as principais interfaces
1. *Use a abordagem iterativa ao projetar a arquitetura*

*Arquitetura de software e design de software são duas coisas diferentes, não se deve misturá-las. A arquitetura de software é o esqueleto, enquanto o design de software é carne.*

Arquitetura de software é sobre o alto nível de abstraçã e design de software é sobre componentes, classes ou módulos.

Um exemplo de arquitetura de software é o padrão MV*. E exemplos de design de software são DAO e Factory.

Qualquer arquitetura de software possui dois componentes principais.

1. **Padrões de Arquitetura**: Define as estratégias de implementação dos componentes;
1. **Estilo de Arquitetura**: Define os componentes e conectores;

<!--
https://medium.com/@maheshwar.ligade/software-architecture-what-why-how-34061f105dc2
-->

## Desenvolvimento de Softwares

### Análise Estruturada

A análise estruturada é uma atividade de construção de modelos. Utiliza uma notação que é particular ao método de análise estruturada para com a finalidade de retratar o fluxo e o conteúdo das informações utilizadas pelo sistema, dividir o sistema em partições funcionais e comportamentais e descrever a essência daquilo que será construído.

A análise estruturada é muito difícil de ser modelada, rastrear e gerenciar mudanças manualmente. Por essas e outras razões, as ferramentas DFD tornaram-se uma abordagem preferida. Para uma pré-elaboração de um projeto de desenvolvimento de software. A análise estruturada também contém gráficos que possibilitam ao analista criar modelos de fluxo de informação, com uma heurística para o uso dos símbolos, juntamente com um dicionário de dados, e narrativas de processamentos como o complemento aos modelos defluxo de informação. Um modelo de fluxo pode ser criado para qualquer sistema baseado em computador, independentemente do tamanho e complexidade.

O dicionário de dados é uma listagem organizada de todos os elementos de dados que são pertinentes ao sistema, com definições precisas e rigorosas, de forma que tanto o usuário como os analistas de sistemas tenham uma compreensão comum das tarefas, das saídas, dos componentes dos depósitos e (até mesmo) dos cálculos intermediários. Atualmente, isto é inserido quase sempre como parte de uma ferramenta de projeto e análise estruturada.

#### Principais Ferramentas

- Diagrama de Fluxo de Dados (DFD)
- Dicionário de dados (DD)
- Linguagem estruturada
- Tabelas de Decisão
- Diagrama Entidade-Relacionamento (DER)
- Diagrama de Transição de Estados (DTE)


- Diagrama de Fluxo de Dados - DFD
![](assets/01-dfd.jpg)

- Dicionário de Dados - DD
![](assets/01-dicionario-de-dados.png)

### Orientada a Objetos

A programação orientada a objetos é diferente da programação estruturada. Na programação orientada a objeto, funções e os dados estão juntos, formando o objeto. Essa abordagem cria uma nova forma de analisar, projetar e desenvolver programas, é uma forma mais abstrata, e genérica, que permite um maior reaproveitamento dos códigos, e facilita a sua manutenção.

Observe que a modelagem orientada a objeto, não é somente uma nova forma de programar, mas uma nova forma de pensar um problema, de forma abstrata, utilizando conceitos do mundo real e não conceitos computacionais. Na programação orientada a objeto o conceito de objeto deve acompanhar todo o ciclo de desenvolvimento do software.

A POO também inclui uma nova notação e exige do analista/programador o conhecimento dessa notação (diagramas de classe, diagramas de interação, diagramas de sequência, etc.). Atualmente existem centenas de bibliotecas, cuidadosamente desenhadas, para dar suporte aos programadores menos sofisticados. Desta forma os programadores podem montar seus programas unindo as bibliotecas externas com alguns objetos que criaram, ou seja, poderão montar suas aplicações rapidamente, contando com módulos pré-fabricados.

O usuário final verá todos os ícones e janelas da tela como objetos e associará a manipulação desses objetos visuais à manipulação dos objetos reais que eles representam. Enxerga o mundo como objetos com estrutura de dados e comportamentos.

O objetivo é desenvolver uma série de modelos de análise, satisfazendo um conjunto de requisitos definidos pelo cliente. O problema não está em aprender como programar em uma linguagem OO, mas sim em aprender a explorar as vantagens que as linguagens OO oferecem. Portanto, para o sucesso de um projeto OO é necessário seguir boas práticas de engenharia discutidas na literatura e pesquisando padrões já consolidados e aprovados.

- Diagrama de Classes
![](assets/01-diagrama_de_classes.gif)

### SOA

### Microsserviços

<!--
http://grupotads2014.blogspot.com/2014/04/analise-estruturada-vs-orientada-objetos.html
http://www.luiztools.com.br/post/microservices-vs-soa-entenda-as-diferencas/
-->

## Fatores Chaves de Sucesso para Implementação de Microsserviço

Se a sua organização pretende migrar para a arquitetura de microsserviços, tenha em mente que será necessário implementar mudanças não somente nas aplicações, mas também no modo como as pessoas trabalham. As mudanças organizacionais e culturais podem ser, em parte, consideradas como desafios, porque cada equipe terá um ritmo próprio de implantação e será responsável por um serviço exclusivo, com um conjunto próprio de clientes. Talvez essas não sejam preocupações típicas para os desenvolvedores, mas elas serão essenciais para o sucesso da arquitetura de microsserviços.

Além das mudanças na cultura e nos processos, a complexidade e a eficiência são outros dois grandes desafios da arquitetura baseada em microsserviços. John Frizelle, arquiteto de plataformas do Red Hat Mobile, definiu as oito categorias de desafios a seguir em sua palestra no Red Hat Summit de 2017:

1. ***Compilação***: é necessário dedicar um tempo à identificação das dependências entre os serviços. É preciso estar ciente de que concluir uma compilação pode gerar muitas outras devido a essas dependências. Também é necessário levar em consideração como os microsserviços afetam os dados.
1. ***Testes***: os testes de integração, assim como os testes end-to-end, podem ser mais difíceis e importantes como jamais foram. Saiba que uma falha em uma parte da arquitetura pode provocar outra mais adiante, dependendo de como os serviços foram projetados para embasar uns aos outros.
1. ***Controle de versão***: ao atualizar para versões novas, lembre-se de que a compatibilidade com as versões anteriores pode ser rompida. É possível resolver esse problema usando a lógica condicional, mas isso pode se tornar outra complicação rapidamente. Como alternativa, você pode colocar no ar várias versões ativas para clientes diferentes, mas essa solução é mais complexa em termos de manutenção e gerenciamento.
1. ***Implantação***: sim, isso também é um desafio, pelo menos na configuração inicial. Para facilitar a implantação, primeiro é necessário investir bastante na automação, pois a complexidade dos microsserviços é demais para a implantação manual. Pense sobre como e em que ordem os serviços serão implementados.
1. ***Geração de logs***: com os sistemas distribuídos, é necessário ter logs centralizados para unificar tudo. Caso contrário, é impossível gerenciar o escalonamento.
1. ***Monitoramento***: é crítico ter uma visualização centralizada do sistema para identificar as fontes de problemas.
1. ***Depuração***: a depuração remota não é uma opção e não funciona com centenas de serviços. Infelizmente, no momento não há uma única resposta para como realizar depurações.
1. ***Conectividade***: considere a detecção de serviços, seja de maneira centralizada ou integrada.

![](assets/microservices.png)
<!-- 
https://pt.slideshare.net/DustinRuehle/success-factors-for-a-mature-microservices-implementation
https://techbeacon.com/app-dev-testing/5-fundamentals-successful-microservice-design
https://dzone.com/articles/microservices-keys-to-success
-->

## Fontes

- https://www.redhat.com/pt-br/topics/microservices/what-are-microservices
- https://medium.com/@maheshwar.ligade/software-architecture-what-why-how-34061f105dc2
- http://grupotads2014.blogspot.com/2014/04/analise-estruturada-vs-orientada-objetos.html
