# Um Servidor de Configurações

Ao desenvolver um aplicativo em nuvem, um problema é manter e distribuir a configuração para nossos serviços. Nós realmente não queremos perder tempo configurando cada ambiente antes de dimensionar nosso serviço horizontalmente ou arriscar violações de segurança embutindo a configuração em nosso aplicativo.

Para resolver isso, vamos consolidar toda a nossa configuração em um único repositório Git e conectá-lo a um aplicativo que gerencia uma configuração para todos os nossos aplicativos. Vamos configurar uma implementação muito simples.

## Montando o Servidor

Acesse https://start.spring.io/ , em Group altere para ```com.acme```, em Artifact digite ```config-server``` e nas dependências busque por "Config Server", gere o projeto, faça o download e importe no Spring Tools.

