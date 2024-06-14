def loadBuffet
  cash = PaymentMethod.create!(name: 'Dinheiro')
  admin = Admin.create!(email: 'admin@email.com', password: 'senha123')
  buffet_photo = Photo.create!()
  buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                            filename: 'buffet_image.jpg')
  buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                          registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                          email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                          neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                          description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                          admin: admin, payment_methods: [cash], photo: buffet_photo)
end

def loadBuffetAndEventType
  cash = PaymentMethod.create!(name: 'Dinheiro')
  admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
  buffet_photo = Photo.create!()
  buffet_photo.image.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'buffet_image.jpg')),
                            filename: 'buffet_image.jpg')
  buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                          registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                          email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                          neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                          description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                          admin: admin, payment_methods: [cash], photo: buffet_photo)
  event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                buffet: buffet)
end
