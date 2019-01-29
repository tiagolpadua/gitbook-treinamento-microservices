# Tolerância a Falhas

Um sistema distribuído típico consiste em vários serviços que colaboram juntos.

Esses serviços são propensos a falhas ou respostas atrasadas. Se um serviço falhar, isso pode afetar outros serviços que afetam o desempenho e possivelmente tornar outras partes do aplicativo inacessíveis ou, no pior dos casos, derrubar todo o aplicativo.

Naturalmente, existem soluções disponíveis que ajudam a tornar os aplicativos resilientes e tolerantes a falhas - uma dessas estruturas é a Hystrix.

A biblioteca de framework Hystrix ajuda a controlar a interação entre os serviços, fornecendo tolerância a falhas e tolerância a latência. Ele melhora a resiliência geral do sistema, isolando os serviços com falha e interrompendo o efeito de falhas em cascata.

Analisaremos como a Hystrix auxilia quando um serviço ou sistema falha e o que a Hystrix pode realizar nessas circunstâncias.

Usaremos a biblioteca e implementaremos o padrão corporativo "Circuit Breaker", que descreve uma estratégia contra a falha em cascata em diferentes níveis em um aplicativo.

O princípio é análogo à eletrônica: a Hystrix observa métodos para falhas nas chamadas de serviços relacionados. Se houver essa falha, ele abrirá o circuito e encaminhará a chamada para um método de fallback.

A biblioteca tolerará falhas até um limite. Além disso, deixa o circuito aberto. O que significa que ele encaminhará todas as chamadas subsequentes para o método de fallback, para evitar futuras falhas. Isso cria um buffer de tempo para o serviço relacionado recuperar de seu estado com falha.

## REST Producer


## Fontes
- https://www.baeldung.com/spring-cloud-netflix-hystrix
