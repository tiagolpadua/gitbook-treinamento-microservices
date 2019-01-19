if exist book.pdf del book.pdf
docker run --rm -v "E:\git\gitbook-treinamento-microservices:/gitbook" -p 4000:4000 billryan/gitbook gitbook pdf .
start "" /max "book.pdf"
