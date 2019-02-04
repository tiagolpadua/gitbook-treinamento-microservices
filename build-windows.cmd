@echo on

REM Proteger pdf: https://online-pdf-no-copy.com/online-pdf-no-copy/
REM Proteger pdf: https://www.pdf2go.com/protect-pdf

set  tm=%time: =0%
set  tm=%tm::=%
set file="apostila_treinamento_correios_%tm%.pdf"

REM del book*.pdf

docker run --rm -v "%cd%:/gitbook" -p 4000:4000 billryan/gitbook gitbook pdf .

move book.pdf %file%

start "" /max %file%
