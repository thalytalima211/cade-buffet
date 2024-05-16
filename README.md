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

![](https://lh3.googleusercontent.com/drive-viewer/AKGpihb0i3xJO2AG-LE__Cte3mERm78XAiNrqRxJhNSnSaHWsDtC7IXMeOeoP9OBCxuT9C44es1prw2MACdoqc_5RsMQt0zGbKgFyw=w1920-h912)

Exibição da página inicial da aplicação, com buffets cadastrados e acesso aos tipos de eventos oferecidos

![](https://lh3.googleusercontent.com/drive-viewer/AKGpihYgIQ9YxBbXbWSPwgCcAV9GCDzr-oz6MkQEZY9Hh5T6cRponpRVCnw7pjoXj1kmX_xmsjGVcMimeuYiWu8WCqKJGLFL_gk3sbw=w1920-h912)

Tela de pedidos de um cliente específico, com abas classificando cada pedido de acordo com seu status
