require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    context 'Data de Vencimento' do
      it {should validate_presence_of :expiration_date}
      it {should validate_comparison_of(:expiration_date).is_greater_than(Date.today)}
    end

    it {should validate_presence_of :surcharge}
    it {should validate_numericality_of(:surcharge).is_greater_than_or_equal_to(0)}

    it {should validate_presence_of :discount}
    it {should validate_numericality_of(:discount).is_greater_than_or_equal_to(0)}

    it {should validate_presence_of :description}
  end

  describe 'Calcula valor final' do
    it 'ao criar um novo evento' do
      # Arrange
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
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                        estimated_date: 2.weeks.from_now.next_weekday, address: 'Avenida Principal, 100', status: :accepted)
      event = Event.create!(expiration_date: 1.week.from_now, surcharge: 200.00, discount: 0.00, payment_method: cash,
                            description: 'Adicional pelo custo das rosas brancas', order: order, customer: customer,
                            buffet: buffet)

      # Act
      result = event.final_value

      # Assert
      expect(result).to eq 25_200.00
    end
  end

  describe 'Associações' do
    it {should belong_to :payment_method}
    it {should belong_to :order}
    it {should belong_to :customer}
    it {should belong_to :buffet}
  end
end
