# Cadê Buffet? API
A API Cadê Buffet? disponibiliza o acesso aos dados públicos da aplicação para consulta externa, além da simulação da disponibilidade para contratação de um evento. Segue abaixo os endpoints disponíveis

## Listar buffets cadastrados na plataforma
O endpoint ```GET /api/v1/buffets``` lista todos os buffets cadastrados por ordem alfabética da seguinte maneira:
```json
[
    {
        "id": 7,
        "brand_name": "Delícias & Companhia Buffet",
        "state": "SP",
        "city": "São Paulo"
    },
    {
        "id": 6,
        "brand_name": "Gourmet & Companhia",
        "state": "SP",
        "city": "São Paulo"
    },
    {
        "id": 4,
        "brand_name": "Sabores Divinos Buffet",
        "state": "SP",
        "city": "Metropolis"
    }
]
```
Podemos também realizar a pesquisa de um buffet pelo nome, cidade ou tipo de evento oferecido usando o campo ```search```.
#### Exemplo de Requisição
```url
http://localhost:3000/api/v1/buffets?search=buffet
```
#### Exemplo de Resposta
```json
[
    {
        "id": 7,
        "brand_name": "Delícias & Companhia Buffet",
        "state": "SP",
        "city": "São Paulo"
    },
    {
        "id": 4,
        "brand_name": "Sabores Divinos Buffet",
        "state": "SP",
        "city": "Metropolis"
    }
]
```

## Listar tipos de eventos cadastrados em um buffet
Com o ID de um buffet podemos obter todos os dados dos tipos de evento que este buffet oferece.
#### Exemplo de Requisição
```url
GET http://localhost:3000/api/v1/buffets/4/event_types
```
#### Exemplo de Resposta
```json
[
    {
        "id": 2,
        "name": "'Festa de Casamento'",
        "description": "'Celebre seu dia do SIM com o nosso buffet'",
        "min_guests": 20,
        "max_guests": 100,
        "default_duration": 90,
        "menu": "Bolo e Doces",
        "offer_drinks": false,
        "offer_decoration": true,
        "offer_parking_service": true,
        "default_address": "indicated_address",
        "min_value": "10000.0",
        "additional_per_guest": "250.0",
        "extra_hour_value": "1000.0",
        "weekend_min_value": "14000.0",
        "weekend_additional_per_guest": "300.0",
        "weekend_extra_hour_value": "1500.0",
        "buffet_id": 4
    },
    {
        "id": 4,
        "name": "Festa de Aniversário",
        "description": "Assopre as velinhas conosco",
        "min_guests": 15,
        "max_guests": 90,
        "default_duration": 120,
        "menu": "Salgadinhos e bolo de aniversário",
        "offer_drinks": false,
        "offer_decoration": true,
        "offer_parking_service": false,
        "default_address": "indicated_address",
        "min_value": "8000.0",
        "additional_per_guest": "100.0",
        "extra_hour_value": "900.0",
        "weekend_min_value": "12000.0",
        "weekend_additional_per_guest": "200.0",
        "weekend_extra_hour_value": "1200.0",
        "buffet_id": 4
    }
]
```

## Ver detalhes de um buffet
Fornecendo um ID, exibe todos os dados cadastrados de um buffet, exceto razão social e CNPJ.
#### Exemplo de Requisição
```url
GET http://localhost:3000/api/v1/buffets/7
```
#### Exemplo de Resposta
```json
{
    "id": 7,
    "brand_name": "Delícias & Companhia Buffet",
    "number_phone": "(21)98765-4321",
    "email": "contato@deliciasciabuffet.com",
    "full_address": "Rua dos Sabores, 789",
    "neighborhood": "Vila Gourmet",
    "state": "SP",
    "city": "São Paulo",
    "zip_code": "12345-678",
    "description": "Delícias & Companhia Buffet é uma empresa especializada em criar experiências gastronômicas únicas para todos os tipos de eventos.",
    "payment_methods": [
        {
            "name": "Dinheiro"
        }
    ]
}
```

## Simular a disponibilidade de agendamento de um evento
Informando o ID do tipo de evento desejado, a data estimada para realização do evento e a quantidade de convidados, recebe o valor prévio para contratação desse evento se a data desejada for futura, se não houver nenhum evento dentro do buffet já confirmado para o data desejada e a quantidade de pessoas estiver dentro dos limites do tipo de evento. Caso contrário, recebe uma mensagem de erro.
#### Exemplo de Requisição 1
```url
GET http://localhost:3000/api/v1/buffets/4/event_types/4/disponibility?estimated_date=2024-05-10&number_of_guests=50
```
#### Exemplo de Resposta
```json
{
    "default_value":"11500.0"
}
```

#### Exemplo de Requisição 2
```url
GET http://localhost:3000/api/v1/buffets/4/event_types/4/disponibility?estimated_date=2024-05-07&number_of_guests=120
```
#### Exemplo de Resposta
```json
{
    "errors": [
        "Data Estimada deve ser maior que 2024-05-08",
        "Quantidade de Convidados deve ser menor ou igual a 90"
    ]
}
```

#### Exemplo de Requisição 3
```url
GET http://localhost:3000/api/v1/buffets/4/event_types/4/disponibility
```
#### Exemplo de Resposta
```json
{
    "errors": [
        "Data Estimada não pode ficar em branco",
        "Quantidade de Convidados não pode ficar em branco"
    ]
}
```
