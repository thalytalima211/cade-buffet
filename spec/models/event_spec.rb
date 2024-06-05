require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    context 'Data de Vencimento' do
      it 'deve ter Data de Vencimento' do
        event = Event.new(expiration_date: '')
        event.valid?
        expect(event.errors.include? :expiration_date).to be true
      end

      it 'Data de Vencimento não deve ser passada' do
        event = Event.new(expiration_date: 1.day.ago)
        event.valid?
        expect(event.errors.include? :expiration_date).to be true
        expect(event.errors[:expiration_date]).to include("deve ser maior que #{Date.today}")
      end

      it 'Data de Vencimento não deve ser igual a hoje' do
        event = Event.new(expiration_date: Date.today)
        event.valid?
        expect(event.errors.include? :expiration_date).to be true
        expect(event.errors[:expiration_date]).to include("deve ser maior que #{Date.today}")
      end

      it 'Data de Vencimento deve ser igual ou maior do que amanhã' do
        event = Event.new(expiration_date: 1.day.from_now)
        event.valid?
        expect(event.errors.include? :expiration_date).to be false
        expect(event.errors[:expiration_date]).not_to include("deve ser maior que #{Date.today}")
      end
    end

    it 'deve ter Taxa Extra' do
      event = Event.new(surcharge: '')
      event.valid?
      expect(event.errors.include? :surcharge).to eq true
    end

    it 'Taxa Extra deve ser maior ou igual a 0' do
      event = Event.new(surcharge: -1)
      event.valid?
      expect(event.errors.include? :surcharge).to eq true
    end

    it 'deve ter Desconto' do
      event = Event.new(discount: '')
      event.valid?
      expect(event.errors.include? :discount).to eq true
    end

    it 'Desconto deve ser maior ou igual a 0' do
      event = Event.new(discount: -1)
      event.valid?
      expect(event.errors.include? :discount).to eq true
    end

    it 'deve ter Descrição' do
      event = Event.new(description: '')
      event.valid?
      expect(event.errors.include? :description).to eq true
    end
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
end
