# Monitorando Nosso Projeto

## Prometheus

O Prometheus é um kit open source de ferramentas de monitoramento e alerta originalmente criado no SoundCloud. Desde a sua criação em 2012, muitas empresas e organizações adotaram o Prometheus, e o projeto tem uma comunidade de desenvolvedores e usuários muito ativa. Agora é um projeto de código aberto independente e mantido independentemente de qualquer empresa.

### Características

As principais características do Prometheus são:

- Um modelo de dados multidimensional com dados de série temporal identificados por pares de nome de métrica e chave/valor;
- PromQL, uma linguagem de consulta flexível para se aproveitar essa dimensionalidade;
- Nenhuma dependência de armazenamento distribuído; nós de servidor único são autônomos;
- Coleção de séries temporais por meio de um modelo pull sobre HTTP;
- A série temporal de envio é suportada através de um gateway intermediário;
- Os destinos são descobertos por meio da descoberta de serviço ou da configuração estática;
- Vários modos de suporte a gráficos e painéis;

### Componentes

O ecossistema Prometheus consiste em vários componentes, muitos dos quais são opcionais:

- O servidor principal Prometheus que busca e armazena dados de séries temporais;
- Bibliotecas do cliente para instrumentar o código do aplicativo;
- Um gateway de envio para apoiar trabalhos de curta duração
- Exportadores especiais para serviços como HAProxy, StatsD, Graphite, etc;
- Um gerenciador de alertas para lidar com alertas
- Várias ferramentas de suporte

A maioria dos componentes do Prometheus é escrita em Go, facilitando sua criação e implementação como binários estáticos.

### Arquitetura

Este diagrama ilustra a arquitetura do Prometheus e alguns de seus componentes do ecossistema:

![Arquitetura Prometheus](../assets/06-prom-architecture.png)

O Prometheus obtém as métricas de trabalhos instrumentados, diretamente ou através de um gateway de envio intermediário para trabalhos de curta duração. Ele armazena todos os exemplos obtidos localmente e executa regras sobre esses dados para agregar e registrar novas séries temporais a partir de dados existentes ou gerar alertas. Grafana ou outros consumidores de API podem ser usados ​​para visualizar os dados coletados.

### Quando utilizá-lo?

O Prometheus funciona bem para gravar qualquer série temporal puramente numérica. Ele se ajusta tanto ao monitoramento centrado na máquina quanto ao monitoramento de arquiteturas altamente dinâmicas orientadas a serviços. Em um mundo de microsserviços, seu suporte para coleta e consulta de dados multidimensionais é uma força especial.

Prometheus é projetado para confiabilidade, para ser o sistema que você utiliza durante uma interrupção para permitir que você rapidamente diagnostique problemas. Cada servidor Prometheus é independente, não dependendo do armazenamento de rede ou de outros serviços remotos. Você pode confiar nele quando outras partes de sua infraestrutura estiverem quebradas e não precisar configurar uma infraestrutura extensiva para usá-lo.

### Quando não utilizá-lo?

Prometheus valoriza a confiabilidade. Você sempre pode ver quais estatísticas estão disponíveis sobre o seu sistema, mesmo em condições de falha. Se você precisar de 100% de precisão, como por faturamento por solicitação, o Prometheus não é uma boa escolha, pois os dados coletados provavelmente não serão detalhados e completos o suficiente. Nesse caso, seria melhor usar algum outro sistema para coletar e analisar os dados para faturamento e a Prometheus para o restante de seu monitoramento.

## Grafana

O Grafana permite consultar, visualizar, alertar e entender suas métricas, independentemente de onde elas estejam armazenadas. Crier, explorar e compartilhar painéis com sua equipe e promover uma cultura orientada por dados.

## Utilizando em nosso projeto

Descompactar o Prometheus e executálo com arquivo de configuração:

**prometheus.yml**

```yml
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9091']
```

```sh
> prometheus-2.7.0.windows-amd64\prometheus.exe --config.file=prometheus.yml --web.enable-admin-api --web.listen-address=:9091
```

Para testar a execução, acesse o endereço http://localhost:9091.

Agora, vamos iniciar o Grafana e conectá-lo ao Prometheus, para isso, descompacte o Grafana e no diretório `conf`, crie uma cópia do arquivo `sample.ini` com o nome `custom.ini`, execute o Grafana:

 ```sh
> grafana-5.4.3\bin\grafana-server.exe
 ```

Para testar a execução, acesse o endereço http://localhost:3000.

## Criando uma fonte de dados Prometheus

Para criar uma fonte de dados do Prometheus:

1. Clique no logotipo do Grafana para abrir o menu da barra lateral.
1. Clique em "Data Sources" na barra lateral.
1. Clique em "Add New".
1. Selecione "Prometheus" como o tipo.
1. Definir a URL do servidor Prometheus apropriada (por exemplo, http://localhost:9091)
1. Clique em "Adicionar" para salvar a nova fonte de dados.

## Importando dashboards pré-criados do Grafana.com

O Grafana.com mantém uma coleção de dashboards compartilhados que podem ser baixados e usados com instâncias autônomas do Grafana. Use a opção "Filtro" do Grafana.com para procurar dashboards somente pela fonte de dados "Prometheus".

O link direto é https://grafana.com/dashboards/2

Clique em "+" e "Import" e cole o conteúdo do JSON, em seguida aponte para a fonte de dados correta.

## Micrometer

https://micrometer.io/

## Configurando a aplicação

Incluir as dependencias do micrometer na aplicação
```xml
<!-- Micrometer core dependecy  -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-core</artifactId>
</dependency>
<!-- Micrometer Prometheus registry  -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

Consultar a url http://localhost:8080/actuator, deve retornar um end-point do prometheus

http://localhost:8080/actuator/prometheus deve retornar as métricas do prometheus



## Fontes
- https://prometheus.io/docs/introduction/overview/
- https://dzone.com/articles/prometheus-monitoring-with-grafana
- https://dzone.com/articles/monitoring-using-spring-boot-2-prometheus-and-graf
- https://dzone.com/articles/monitoring-using-spring-boot-20-prometheus-and-gra
- https://thepracticalsysadmin.com/introduction-to-grafana/
