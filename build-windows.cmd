@echo on

set  tm=%time: =0%
set  tm=%tm::=%
set file="book_%tm%.pdf"

del book*.pdf

docker run --rm -v "%cd%:/gitbook" -p 4000:4000 billryan/gitbook gitbook pdf .

move book.pdf %file%

start "" /max %file%
