# Testes

Uma confusão bastante comum na comunidade de desenvolvimento é justamente sobre qual nome dar para o tipo de teste. **Esse é um teste de unidade, integração ou sistema?** Apesar de parecer uma discussão boba, é importante que desenvolvedores usem os mesmos termos para se comunicar; isso facilita e acelera o entendimento.

Um **teste de unidade** é aquele que testa uma única unidade do sistema. Ele a testa de maneira isolada, geralmente simulando as prováveis dependências que aquela unidade tem. Em sistemas orientados a objetos, é comum que a unidade seja uma classe. Ou seja, quando queremos escrever testes de unidade para a classe Pedido, essa bateria de testes testará o funcionamento da classe Pedido, isolada, sem interações com outras classes.

Um **teste de integração** é aquele que testa a integração entre duas partes do seu sistema. Os testes que você escreve para a sua classe *PedidoDao*, por exemplo, onde seu teste vai até o banco de dados, é um teste de integração. Afinal, você está testando a integração do seu sistema com o sistema externo, que é o banco de dados. Testes que garantem que suas classes comunicam-se bem com serviços web, escrevem arquivos texto, ou mesmo mandam mensagens via socket são considerados testes de integração.

Já um **teste de sistema** garante que o sistema funciona como um todo. Este nível de teste está interessado se o sistema funciona como um todo, com todas as unidades trabalhando juntas. Ele é comumente chamado de teste de caixa preta, já que o sistema é testado “com tudo ligado”: banco de dados, serviços web, batch jobs, e etc. Os **testes de aceitação**, famosos com a onda ágil, são, no fim, testes de sistema. Testes de aceitação são aqueles onde as equipes ágeis dizem se uma determinada funcionalidade está “aceita” ou não.

Independente do nível do teste, todos eles tem vantagens e desvantagens. Um teste de unidade, por exemplo, é bastante fácil de ser e roda muito fácil; mas não é um teste que simula bem o mundo real. Por outro lado, um teste de sistema faz uma simulação bastante real, mas é muito mais difícil de ser escrito, dá mais trabalho de manutenção e leva mais tempo para executar.

Mas qual nível de teste usar então? A ideia é que você escolha o nível de teste certo para aquele problema. Uma classe de negócio pode ser testada de maneira isolada; já um DAO precisa ser testado junto a um banco de dados. Lembre-se: o teste deve dar feedback rico; um teste que nunca quebra não serve de nada.

## Introdução

Abordaremos aqui o suporte do Spring para testes de integração e práticas recomendadas para testes de unidade. O time do Spring defende o desenvolvimento orientado a testes (TDD). A equipe do Spring descobriu que o uso correto da inversão de controle (IoC) certamente torna os testes de unidade e integração mais fáceis (na medida em que a presença de métodos setter e construtores apropriados em classes facilita a conexão em um teste sem ter que configurar registros de localizadores de serviço e estruturas semelhantes).

O teste é uma parte integrante do desenvolvimento de software corporativo. Iremos enfocar o valor agregado pelo princípio IoC ao teste de unidade e aos benefícios do suporte do Spring Framework para testes de integração.

## Testes Unitários no Spring

A injeção de dependência deve tornar seu código menos dependente do contêiner do que seria com o desenvolvimento tradicional do Java EE. Os POJOs que compõem seu aplicativo devem ser testáveis ​​nos testes JUnit ou TestNG, com objetos instanciados usando o novo operador, sem o Spring ou qualquer outro contêiner. Você pode usar objetos simulados (em conjunto com outras valiosas técnicas de teste) para testar seu código isoladamente. Se você seguir as recomendações de arquitetura do Spring, a estratificação e a componentização limpas resultantes da base de código facilitarão o teste da unidade. Por exemplo, você pode testar objetos da camada de serviço por meio do stub ou do escaneamento de interfaces DAO ou de repositório, sem precisar acessar dados persistentes durante a execução de testes de unidade.

Os testes unitários verdadeiros geralmente são executados com extrema rapidez, pois não há infraestrutura de tempo de execução para serem configurados. Enfatizar os verdadeiros testes unitários como parte de sua metodologia de desenvolvimento pode aumentar sua produtividade.

## Teste de integração no Spring

É importante poder realizar alguns testes de integração sem exigir a implantação no servidor de aplicativos ou a conexão com outra infraestrutura corporativa. Isso permite testar coisas como:

- A ligação correta dos contextos de contêiner do Spring IoC.
- Acesso de dados usando JDBC ou uma ferramenta ORM. Isso pode incluir coisas como a correção de instruções SQL, consultas Hibernate, mapeamentos de entidades JPA e assim por diante.

??? 

O Spring Framework fornece suporte de primeira classe para testes de integração no módulo `spring-teste`. O nome do arquivo JAR real pode incluir a versão de liberação e também pode estar no formato longo `org.springframework.test`, dependendo de onde você o obteve (consulte a seção Gerenciamento de Dependências para obter uma explicação). Essa biblioteca inclui o pacote org.springframework.test, que contém classes valiosas para teste de integração com um contêiner Spring. Esse teste não depende de um servidor de aplicativos ou outro ambiente de implementação. Esses testes são mais lentos para serem executados do que os testes de unidade, mas muito mais rápidos que os testes de selênio equivalentes ou testes remotos que dependem da implantação em um servidor de aplicativos.

No Spring 2.5 e posterior, o suporte a testes de unidade e integração é fornecido na forma de Spring TestContext Framework orientada por anotações. O framework TestContext é agnóstico da estrutura de teste em uso, que permite a instrumentação de testes em vários ambientes, incluindo JUnit, TestNG e outros.

3.2. Objetivos do Teste de Integração
O suporte de testes de integração do Spring tem os seguintes objetivos principais:

Para gerenciar o armazenamento em cache do contêiner do Spring IoC entre os testes.

Fornecer Injeção de Dependência de instâncias de fixtures de teste.

Fornecer gerenciamento de transações apropriado para testes de integração.

Fornecer classes base específicas de Spring que auxiliem os desenvolvedores a escrever testes de integração.

As próximas seções descrevem cada meta e fornecem links para detalhes de implementação e configuração.

## Fontes
- http://blog.caelum.com.br/unidade-integracao-ou-sistema-qual-teste-fazer/
- https://www.baeldung.com/spring-boot-testing
