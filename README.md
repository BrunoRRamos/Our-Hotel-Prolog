# Our-Hotel-Prolog
Projeto de um sistema de gerenciamento para hoteis desenvolvido em Prolog na disciplina de Paradigmas de Linguagem de Programação.

## Para rodar o sistema

1. Navegue até o diretorio raiz do projeto
2. Execute o seguinte comando na linha de comando para baixar as dependencias e gerar o banco de dados sql:
   ```shell
    > swipl -s src/init.pl
   ```
3. Execute o seguinte comando na linha de comando executar para iniciar o programa:
   ```shell
    > swipl -s src/main.pl -g main
   ```
4. Você pode iniciar usando nosso usuário admin como padrão:
   ```shell
    > email: adm@gmail.com
    > password: 123
   ```