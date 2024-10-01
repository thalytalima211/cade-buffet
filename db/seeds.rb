# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

cash = PaymentMethod.create!(name: 'Dinheiro')
credit_card = PaymentMethod.create!(name: 'Cartão de Crédito')
debit_card = PaymentMethod.create!(name: 'Cartão de Débito')
pix = PaymentMethod.create!(name: 'PIX')

first_admin = Admin.create!(email: 'contato@estreladourada.com.br', password: 'admin123')
second_admin = Admin.create!(email: 'contato@luacheiaeventos.com', password: 'admin123')
third_admin = Admin.create!(email: 'contato@solnascentegastronomia.com', password: 'admin123')
fourth_admin = Admin.create!(email: 'contato@encantosgastronomicos.com', password: 'admin123')
fifth_admin = Admin.create!(email: 'contato@deliciasdovale.com', password: 'admin123')

first_buffet_description = <<~DESCRIPTION.strip.gsub("\n", " ")
O Buffet Estrela Dourada oferece uma experiência gastronômica única para eventos especiais. Com um cardápio
diversificado e serviço de alta qualidade, tornamos seu evento inesquecível.
DESCRIPTION
first_buffet_photo = Photo.create!()
first_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'first_buffet.jpeg')),
                              filename: 'first_buffet.jpeg')
first_buffet = Buffet.create!(corporate_name: 'Estrela Dourada Buffet Ltda.', brand_name: 'Estrela Dourada',
                              registration_number: '48.723.329/0001-07', number_phone: '(11) 1234-5678',
                              email: 'contato@estreladourada.com.br', full_address: 'Rua das Flores, 100',
                              neighborhood: 'Jardim das Estrelas', city: 'Sâo Paulo', state: 'SP', zip_code: '01234-567',
                              description: first_buffet_description, admin: first_admin, payment_methods: [credit_card,
                              cash], photo: first_buffet_photo)
second_buffet_description = <<~DESCRIPTION.strip.gsub("\n", " ")
O Buffet Lua Cheia oferece uma atmosfera mágica para seus eventos. Com um ambiente sofisticado e culinária excepcional,
transformamos suas celebrações em momentos inesquecíveis.
DESCRIPTION
second_buffet_photo = Photo.create!()
second_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'second_buffet.jpeg')),
                              filename: 'second_buffet.jpeg')
second_buffet = Buffet.create!(corporate_name: 'Lua Cheia Eventos Ltda.', brand_name: 'Lua Cheia',
                              registration_number: '44.524.856/0001-31', number_phone: '(21) 98765-4321',
                              email: 'contato@luacheiaeventos.com', full_address: 'Av. dos Anjos, 500',
                              neighborhood: 'Praia da Lua', city: 'Rio de Janeiro', state: 'RJ', zip_code: '21000-123',
                              description: second_buffet_description, admin: second_admin, payment_methods: [credit_card,
                              debit_card], photo: second_buffet_photo)
third_buffet_description = <<~DESCRIPTION.strip.gsub("\n", " ")
O Buffet Sol Nascente oferece uma experiência gastronômica refinada, com pratos exclusivos e serviço impecável.
Transformamos seu evento em uma verdadeira celebração.
DESCRIPTION
third_buffet_photo = Photo.create!()
third_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'third_buffet.jpeg')),
                              filename: 'third_buffet.jpeg')
third_buffet = Buffet.create!(corporate_name: 'Sol Nascente Gastronomia Ltda.', brand_name: 'Sol Nascente',
                              registration_number: '97.840.378/0001-35', number_phone: '(31) 5432-1098',
                              email: 'contato@solnascentegastronomia.com', full_address: 'Rua das Palmeiras, 200',
                              neighborhood: 'Centro Solar', city: 'Belo Horizonte', state: 'MG', zip_code: '30123-456',
                              description: third_buffet_description, admin: third_admin, payment_methods: [credit_card,
                              cash, pix], photo: third_buffet_photo)
fourth_buffet_description = <<~DESCRIPTION.strip.gsub("\n", " ")
O Buffet Gastronômico Encantos oferece uma variedade de pratos deliciosos, preparados com ingredientes frescos e
selecionados. Garantimos uma experiência gastronômica única para seus eventos.
DESCRIPTION
fourth_buffet_photo = Photo.create!()
fourth_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'fourth_buffet.jpeg')),
                              filename: 'fourth_buffet.jpeg')
fourth_buffet = Buffet.create!(corporate_name: 'Encantos Gastronômicos Ltda.', brand_name: 'Encantos Gastronômico',
                              registration_number: '29.225.393/0001-13', number_phone: '(51) 2345-6789',
                              email: 'contato@encantosgastronomicos.com', full_address: 'Rua das Estrelas, 300',
                              neighborhood: 'Centro Encantado', city: 'Porto Alegre', state: 'RS', zip_code: '90000-321',
                              description: fourth_buffet_description, admin: fourth_admin, payment_methods: [credit_card,
                              debit_card], photo: fourth_buffet_photo)
fifth_buffet_description = <<~DESCRIPTION.strip.gsub("\n", " ")
O Buffet Delícias do Vale oferece uma fusão de sabores regionais e internacionais, proporcionando uma experiência
culinária única para seus convidados. Surpreenda-se com nossas iguarias.
DESCRIPTION
fifth_buffet_photo = Photo.create!()
fifth_buffet_photo.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'fifth_buffet.jpeg')),
                              filename: 'fifth_buffet.jpeg')
fifth_buffet = Buffet.create!(corporate_name: 'Delícias do Vale Eventos Ltda.', brand_name: 'Delícias do Vale',
                              registration_number: '55.857.806/0001-92', number_phone: '(85) 8765-4321',
                              email: 'contato@deliciasdovale.com', full_address: 'Av. das Águas, 400',
                              neighborhood: 'Vale Encantado', city: 'Fortaleza', state: 'CE', zip_code: '60000-987',
                              description: fifth_buffet_description, admin: fifth_admin, payment_methods: [credit_card,
                              cash], photo: fifth_buffet_photo)

first_event_type = EventType.create!(name: 'Casamento Clássico', min_guests: 50, max_guests: 200,
                                    description: ' Um casamento tradicional e elegante, com decoração refinada',
                                    default_duration: 360, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: true, default_address: :buffet_address,
                                    menu: 'Entradas variadas, prato principal (opção de carne, peixe ou vegetariano)',
                                    min_value: 10_000.00, weekend_min_value: 15_000.00, additional_per_guest: 50.00,
                                    weekend_additional_per_guest: 70.00, extra_hour_value: 500.00,
                                    weekend_extra_hour_value: 700.00, buffet: first_buffet)
second_event_type = EventType.create!(name: 'Festa de 15 anos Temática', min_guests: 50, max_guests: 150,
                                    description: 'Uma festa de debutante com tema escolhido pela aniversariante.',
                                    default_duration: 300, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: true, default_address: :buffet_address,
                                    menu: 'Finger foods temáticos, prato principal, mesa de doces temática.',
                                    min_value: 8_000.00, weekend_min_value: 12_000.00, additional_per_guest: 40.00,
                                    weekend_additional_per_guest: 60.00, extra_hour_value: 400.00,
                                    weekend_extra_hour_value: 600.00, buffet: first_buffet)
third_event_type = EventType.create!(name: 'Coquetel Corporativo', min_guests: 30, max_guests: 100,
                                    description: 'Um evento empresarial ideal para networking e comemorações de sucesso.',
                                    default_duration: 180, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: false, default_address: :indicated_address,
                                    menu: 'Canapés variados, estação de risotos, mesa de frios e antepastos.',
                                    min_value: 5_000.00, weekend_min_value: 7_000.00, additional_per_guest: 30.00,
                                    weekend_additional_per_guest: 50.00, extra_hour_value: 300.00,
                                    weekend_extra_hour_value: 500.00, buffet: first_buffet)
fourth_event_type = EventType.create!(name: 'Aniversário Infantil Lúdico', min_guests: 20, max_guests: 50,
                                    description: 'Uma festa de aniversário com atividades recreativas para crianças.',
                                    default_duration: 180, offer_drinks: false, offer_decoration: true,
                                    offer_parking_service: false, default_address: :buffet_address,
                                    menu: 'Mini-pizzas, cachorro-quente, mini-hambúrgueres, mesa de doces infantis.',
                                    min_value: 3_000.00, weekend_min_value: 4_500.00, additional_per_guest: 25.00,
                                    weekend_additional_per_guest: 40.00, extra_hour_value: 250.00,
                                    weekend_extra_hour_value: 400.00, buffet: second_buffet)
fifth_event_type = EventType.create!(name: 'Festa de Formatura Glamourosa', min_guests: 80, max_guests: 300,
                                    description: 'Uma celebração luxuosa com decoração elegante e gastronomia requintada.',
                                    default_duration: 420, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: true, default_address: :buffet_address,
                                    menu: 'Coquetel volante, prato principal, estação de sobremesas.',
                                    min_value: 15_000.00, weekend_min_value: 20_000.00, additional_per_guest: 60.00,
                                    weekend_additional_per_guest: 80.00, extra_hour_value: 800.00,
                                    weekend_extra_hour_value: 1_000.00, buffet: second_buffet)
sixth_event_type = EventType.create!(name: 'Brunch Corporativo', min_guests: 20, max_guests: 80,
                                    description: 'Um evento matinal para reuniões de negócios ou celebrações de equipe',
                                    default_duration: 180, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: false, default_address: :indicated_address,
                                    menu: 'Café da manhã continental, quiches, frutas frescas, sucos naturais.',
                                    min_value: 4_500.00, weekend_min_value: 6_000.00, additional_per_guest: 35.00,
                                    weekend_additional_per_guest: 50.00, extra_hour_value: 400.00,
                                    weekend_extra_hour_value: 600.00, buffet: third_buffet)
seventh_event_type = EventType.create!(name: 'Jantar de Gala Beneficente', min_guests: 100, max_guests: 500,
                                    description: 'Um evento de caridade com jantar de gala, leilões e arrecadação de fundos',
                                    default_duration: 360, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: true, default_address: :buffet_address,
                                    menu: 'Coquetel de boas-vindas, menu degustação de pratos gourmet',
                                    min_value: 20_000.00, weekend_min_value: 30_000.00, additional_per_guest: 80.00,
                                    weekend_additional_per_guest: 100.00, extra_hour_value: 1_000.00,
                                    weekend_extra_hour_value: 1_500.00, buffet: third_buffet)
eighth_event_type = EventType.create!(name: 'Almoço Empresarial', min_guests: 30, max_guests: 150,
                                    description: 'Um evento corporativo para reuniões de negócios ou almoços de confraternização',
                                    default_duration: 150, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: false, default_address: :indicated_address,
                                    menu: 'Buffet de saladas, prato quente (opção de carne, frango ou vegetariano).',
                                    min_value: 7_000.00, weekend_min_value: 10_000.00, additional_per_guest: 40.00,
                                    weekend_additional_per_guest: 60.00, extra_hour_value: 500.00,
                                    weekend_extra_hour_value: 800.00, buffet: third_buffet)
nineth_event_type = EventType.create!(name: 'Festa de Halloween', min_guests: 50, max_guests: 200,
                                    description: 'Uma festa temática de Halloween cheia de diversão e sustos',
                                    default_duration: 240, offer_drinks: true, offer_decoration: true,
                                    offer_parking_service: false, default_address: :indicated_address,
                                    menu: 'Petiscos temáticos, bar de drinks especiais.',
                                    min_value: 8_000.00, weekend_min_value: 12_000.00, additional_per_guest: 40.00,
                                    weekend_additional_per_guest: 60.00, extra_hour_value: 400.00,
                                    weekend_extra_hour_value: 650.00, buffet: fifth_buffet)
tenth_event_type = EventType.create!(name: 'Chá de Bebê Aconchegante', min_guests: 15, max_guests: 40,
                                    description: 'Uma celebração íntima para comemorar a chegada do bebê',
                                    default_duration: 120, offer_drinks: false, offer_decoration: true,
                                    offer_parking_service: false, default_address: :indicated_address,
                                    menu: 'Mini-sanduíches, salgadinhos, docinhos variados, chá e sucos.',
                                    min_value: 2_500.00, weekend_min_value: 3_500.00, additional_per_guest: 30.00,
                                    weekend_additional_per_guest: 45.00, extra_hour_value: 250.00,
                                    weekend_extra_hour_value: 380.00, buffet: fifth_buffet)

customer = Customer.create!(name: 'Flávia Soares', cpf: '874.047.760-66', email: 'flavia_soares@gmail.com',
                            password: 'senha123')

first_order = Order.create!(buffet: first_buffet, event_type: first_event_type, customer: customer,
                            estimated_date: 1.week.from_now, number_of_guests: 50,
                            details: 'Jantar romântico à luz de velas, com música ao vivo de um quarteto de cordas',
                            address: 'Rua das Flores, 100')
second_order = Order.create!(buffet: first_buffet, event_type: second_event_type, customer: customer,
                            estimated_date: 2.weeks.from_now, number_of_guests: 100,
                            details: 'A festa será inspirada em um conto de fadas, com decoração que remete a um castelo encantado',
                            address: 'Rua das Flores, 100')
third_order = Order.create!(buffet: first_buffet, event_type: third_event_type, customer: customer,
                            estimated_date: 3.weeks.from_now, number_of_guests: 50, status: :cancelled,
                            details: 'O coquetel será realizado em um ambiente elegante, com decoração minimalista',
                            address: 'Rua das Palmeiras, 200')
fourth_order = Order.create!(buffet: second_buffet, event_type: fourth_event_type, customer: customer,
                            estimated_date: 4.weeks.from_now, number_of_guests: 30, status: :cancelled,
                            details: 'A festa terá como tema "Mundo dos Dinossauros", com decoração colorida e divertida',
                            address: 'Av. dos Anjos, 500')
fifth_order = Order.create!(buffet: second_buffet, event_type: fifth_event_type, customer: customer,
                            estimated_date: 5.weeks.from_now, number_of_guests: 150, status: :pending_confirmation,
                            details: 'A festa deve ser decorada com elementos sofisticados e glamourosos',
                            address: 'Av. dos Anjos, 500')
sixth_order = Order.create!(buffet: third_buffet, event_type: sixth_event_type, customer: customer,
                            estimated_date: 6.weeks.from_now, number_of_guests: 60, status: :pending_confirmation,
                            details: 'O brunch deverá ter mesas dispostas de forma a promover a interação entre os participantes',
                            address: 'Av. das Águas, 400')
seventh_order = Order.create!(buffet: third_buffet, event_type: seventh_event_type, customer: customer,
                            estimated_date: 7.weeks.from_now, number_of_guests: 200, status: :expired,
                            details: 'O jantar será realizado em um salão de eventos luxuoso, decorado com elegância e sofisticação',
                            address: 'Rua das Palmeiras, 200')
eighth_order = Order.create!(buffet: third_buffet, event_type: eighth_event_type, customer: customer,
                            estimated_date: 8.weeks.from_now, number_of_guests: 40, status: :accepted,
                            details: 'O almoço será realizado em um ambiente corporativo',
                            address: 'Rua do Comércio, 500')
nineth_order = Order.create!(buffet: fifth_buffet, event_type: nineth_event_type, customer: customer,
                            estimated_date: 9.weeks.from_now, number_of_guests: 80, status: :accepted,
                            details: 'A festa será realizada em um espaço decorado com abóboras, teias de aranha, e decorações assustadoras.',
                            address: 'Rua dos Sustos, 967')
tenth_order = Order.create!(buffet: fifth_buffet, event_type: tenth_event_type, customer: customer,
                            estimated_date: 10.weeks.from_now, number_of_guests: 25, status: :accepted,
                            details: 'Decoração em tons suaves e elementos fofos, como ursinhos de pelúcia e nuvens',
                            address: 'Rua das Nuvens, 123')

first_event = Event.create!(buffet: second_buffet, order: fifth_order, customer: customer, payment_method: debit_card,
                            expiration_date: 4.weeks.from_now, surcharge: 300.00, discount: 0.00,
                            description: 'Custo adicional pela decoração especial')
second_event = Event.create!(buffet: third_buffet, order: sixth_order, customer: customer, payment_method: credit_card,
                            expiration_date: 5.weeks.from_now, surcharge: 0.00, discount: 150.00,
                            description: 'Custo promocional')
third_event = Event.create!(buffet: third_buffet, order: seventh_order, customer: customer, payment_method: cash,
                            expiration_date: 6.weeks.from_now, surcharge: 0.00, discount: 0.00,
                            description: 'Valor padrão')
fourth_event = Event.create!(buffet: third_buffet, order: eighth_order, customer: customer, payment_method: pix,
                            expiration_date: 7.weeks.from_now, surcharge: 0.00, discount: 0.00,
                            description: 'Valor padrão')
fifth_event = Event.create!(buffet: fifth_buffet, order: nineth_order, customer: customer, payment_method: credit_card,
                            expiration_date: 8.weeks.from_now, surcharge: 0.00, discount: 200.00,
                            description: 'Promoção especial do dia das bruxas')
sixth_event = Event.create!(buffet: fifth_buffet, order: tenth_order, customer: customer, payment_method: cash,
                            expiration_date: 9.weeks.from_now, surcharge: 150.00, discount: 0.00,
                            description: 'Adicional por decoração temática')
