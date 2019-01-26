# Entendendo REST

REST (Representational State Transfer) foi introduzido em 2000 por Roy Fielding em sua tese de doutorado. REST é um estilo arquitetural para projetar sistemas distribuídos. Não é um padrão, mas um conjunto de restrições, como ser sem estado, ter uma relação cliente/servidor e uma interface uniforme. O REST não está estritamente relacionado ao HTTP, mas é mais comumente associado a ele.

## Princípios do REST
- ***Recursos*** expõem URIs de estrutura de diretórios facilmente compreendidos;
- As ***representações*** transferem JSON ou XML para representar objetos e atributos de dados;
- ***Mensagens*** usam métodos HTTP explicitamente (por exemplo, GET, POST, PUT e DELETE);
- Interações ***sem estado*** não armazenam nenhum contexto de cliente no servidor entre as solicitações. As dependências de estado limitam e restringem a escalabilidade. O cliente mantém o estado da sessão;

## Métodos HTTP
Use métodos HTTP para mapear operações CRUD (criar, recuperar, atualizar, excluir) para solicitações HTTP.

## GET
Recuperar informação. As solicitações GET devem ser seguras e idempotentes, ou seja, independentemente de quantas vezes ela se repete com os mesmos parâmetros, os resultados são os mesmos. Eles podem ter efeitos colaterais, mas o usuário não os espera, portanto não podem ser críticos para a operação do sistema. As solicitações também podem ser parciais ou condicionais.

Recuperar um endereço com um ID de 1:

```
GET / endereços / 1
```

## POST

Solicita que o recurso na URI faça alguma coisa com a entidade fornecida. Geralmente, o POST é usado para criar uma nova entidade, mas também pode ser usado para atualizar uma entidade.

Criar um novo endereço:

```
POST / addresses
```

## PUT

Armazena uma entidade em um URI. PUT pode criar uma nova entidade ou atualizar uma existente. Uma solicitação PUT é idempotente. Idempotência é a principal diferença entre as expectativas de PUT e uma solicitação POST.

Modifique o endereço com um ID de 1:

```
PUT / endereços / 1
```

Nota: PUT substitui uma entidade existente. Se apenas um subconjunto de elementos de dados for fornecido, o restante será substituído por vazio ou nulo.

```
PATCH
```

Atualiza apenas os campos especificados de uma entidade em um URI. Uma solicitação PATCH não é segura nem idempotente. Isso porque uma operação PATCH não pode garantir que todo o recurso tenha sido atualizado.

```
PATCH / endereços / 1
```

## DELETE

Solicita que um recurso seja removido; no entanto, o recurso não precisa ser removido imediatamente. Pode ser um pedido assíncrono ou de longa duração.

Exclua um endereço com um ID de 1:

```
DELETE / endereços / 1
```

## Códigos de status HTTP
Códigos de status indicam o resultado da solicitação HTTP.

- ***1XX*** - informativo
- ***2XX*** - sucesso
- ***3XX*** - redirecionamento
- ***4XX*** - erro do cliente
- ***5XX*** - erro do servidor

## Media types (Tipos de mídia)

Os cabeçalhos HTTP ```Accept``` e ```Content-Type``` podem ser usados ​​para descrever o conteúdo enviado ou solicitado em uma solicitação HTTP. O cliente pode definir ```Accept``` para ```application/json``` se estiver solicitando uma resposta em JSON. Por outro lado, ao enviar dados, a configuração do ```Content-Type``` para ```application/xml``` informa ao cliente que os dados que estão sendo enviados na solicitação são XML.

## Fontes

- https://spring.io/understanding/REST
