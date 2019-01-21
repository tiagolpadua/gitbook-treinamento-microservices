# Iniciando nossa nuvem

As aplicações que são executados com arquitetura de microsserviços visam simplificar o desenvolvimento, a implantação e a manutenção. A natureza decomposta da aplicação permite que os desenvolvedores se concentrem em um problema por vez. Melhorias podem ser introduzidas sem afetar outras partes de um sistema.

Por outro lado, diferentes desafios surgem quando adotamos uma abordagem de microsserviço:

- Externalização da configuração para que seja flexível e não requeira a reconstrução do serviço na alteração;
- Descoberta de serviço;
- Ocultar a complexidade dos serviços implantados em hosts diferentes;

Neste capítulo executaremos cinco microsserviços: um servidor de configuração, um servidor de descoberta, um servidor de gateway, o microsserviço de catálogo de livros e, finalmente, um serviço de avaliação de livros. Esses cinco microsserviços formam um aplicativo de base sólida para iniciar o desenvolvimento da nuvem e abordar os desafios mencionados anteriormente.

Neste contexto, o Spring Cloud é um framework para criar aplicativos robustos na nuvem. O framework facilita o desenvolvimento de aplicativos, fornecendo soluções para muitos dos problemas comuns enfrentados ao migrar para um ambiente distribuído.
