# Projeto Cadê Buffet?

## Descrição do projeto
Plataforma para cadastro de buffets e seus respectivos pedidos para realização de eventos

## Funcionalidades
✔️ Cadastro de perfis para cliente e administrador

✔️ Cadastro e gerenciamento de dados de buffets e os tipos de eventos que oferece por um administrador

✔️ Pesquisa de buffets cadastrados na base de dados por razão social, cidade e tipos de eventos oferecidos

✔️ Pedidos para um determinado tipo de evento por um cliente

✔️ Gerenciamento de andamento dos pedidos por seus respectivos clientes e buffets, com detalhamento do status de cada pedido

## Pré-Requisitos
- [Ruby](https://github.com/rvm/ubuntu_rvm)

## Como rodar a aplicação
No terminal, clone o projeto:
```
git clone https://github.com/thalytalima211/cade-buffet.git
```

Entre na pasta do projeto:
```
cd cade-buffet
```

Execute o comando para instalar as gems necessárias:
```
bundle install
```

Execute o comando para carregar a estrutura do banco de dados da aplicação:
```
rails db:migrate
```

Execute o comando para carregar no banco de dados informações iniciais para exemplificação de uso da aplicação:
```
rails db:seed
```

Execute a aplicação:
```
rails server
```

Acesse a aplicação pelo link
```
http://localhost:3000/
```

## Como rodar os testes
Para executar os testes da aplicação, execute o comando:
```
rspec
```

## Casos de teste
![Página inicial](https://github.com/user-attachments/assets/026b77db-20de-4c5a-a43c-2a23690faba9)

Página inicial da aplicação, com listagem de todos os buffets cadastrados na plataforma.

![Detalhamento de buffet](https://github.com/user-attachments/assets/9381f816-c831-43fb-9f30-a18fdaebe6a5)

Tela de detalhes de um buffet, com listagem dos tipos de eventos oferecidos.

![Tela de pedidos](https://github.com/user-attachments/assets/d3bb3ccd-600d-42e8-a20b-f7bf4c065865)

Tela de pedidos de um cliente específico, com abas classificando cada pedido de acordo com seu status.

Ao rodar o comando ```rails db:seed``` é carregado no banco de dados informações iniciais de pedidos de uma cliente pré-cadastrada.
Dados de login - Email: flavia_soares@gmail.com  Senha: senha123
