require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid' do
    context 'Endereço' do
      it 'deve ter Endereço' do
        order = Order.new(address: '')
        order.valid?
        expect(order.errors.include? :address).to be true
      end
    end

    context 'Quantidade de Convidados' do
      it 'deve ter Quanitdade de Convidados' do
        order = Order.new(number_of_guests: '')
        order.valid?
        expect(order.errors.include? :number_of_guests).to be true
      end

      it 'Quantidade de Convidados não pode ser menor do que o mínimo para o evento' do
        # Arrange
        cash = PaymentMethod.create!(name: 'Dinheiro')
        admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
        buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                admin: admin, payment_methods: [cash])
        event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                      min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                      offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                      default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                      extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                      weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                      buffet: buffet)
        order = Order.new(event_type: event_type, number_of_guests: 19)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :number_of_guests).to be true
        expect(order.errors[:number_of_guests]).to include("deve ser maior ou igual a 20")
      end

      it 'Quantidade de Convidados não pode ser maior do que o máximo para o evento' do
        # Arrange
        cash = PaymentMethod.create!(name: 'Dinheiro')
        admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
        buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                admin: admin, payment_methods: [cash])
        event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                      min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                      offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                      default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                      extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                      weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                      buffet: buffet)
        order = Order.new(event_type: event_type, number_of_guests: 101)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :number_of_guests).to be true
        expect(order.errors[:number_of_guests]).to include("deve ser menor ou igual a 100")
      end

      it 'Quantidade de Convidados deve estar dentro dos limites do tipo de evento' do
        # Arrange
        cash = PaymentMethod.create!(name: 'Dinheiro')
        admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
        buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                                registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                                email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                                neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                                description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                                admin: admin, payment_methods: [cash])
        event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                      min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                      offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                      default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                      extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                      weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                      buffet: buffet)
        order = Order.new(event_type: event_type, number_of_guests: 80)

        # Act
        order.valid?

        # Assert
        expect(order.errors.include? :number_of_guests).to be false
        expect(order.errors[:number_of_guests]).not_to include("deve ser maior ou igual a 20")
        expect(order.errors[:number_of_guests]).not_to include("deve ser menor ou igual a 100")
      end
    end

    context 'Data Estimada' do
      it 'deve ter Data Estimada' do
        order = Order.new(estimated_date: '')
        order.valid?
        expect(order.errors.include? :estimated_date).to be true
      end

      it 'data estimada não deve ser passada' do
        order = Order.new(estimated_date: 1.day.ago)
        order.valid?
        expect(order.errors.include? :estimated_date).to be true
        expect(order.errors[:estimated_date]).to include("deve ser maior que #{Date.today}")
      end

      it 'data estimada não deve ser igual a hoje' do
        order = Order.new(estimated_date: Date.today)
        order.valid?
        expect(order.errors.include? :estimated_date).to be true
        expect(order.errors[:estimated_date]).to include("deve ser maior que #{Date.today}")
      end

      it 'data estimada deve ser igual ou maior do que amanhã' do
        order = Order.new(estimated_date: 1.day.from_now)
        order.valid?
        expect(order.errors.include? :estimated_date).to be false
        expect(order.errors[:estimated_date]).not_to include("deve ser maior que #{Date.today}")
      end
    end

  end

  describe 'gera um código aleatório' do
    it  'ao criar um novo pedido' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                              registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                              email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                              neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                              description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                              admin: admin, payment_methods: [cash])
      event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                    min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                    offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                    default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.new(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                        estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')

      # Act
      order.save!
      result = order.code

      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end
    it  'e o código é único' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                              registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                              email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                              neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                              description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                              admin: admin, payment_methods: [cash])
      event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                    min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                    offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                    default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      first_order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                                  estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
      second_order = Order.new(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 55,
                              estimated_date: 2.months.from_now, address: 'Avenida Principal, 289')


      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                              registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                              email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                              neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                              description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                              admin: admin, payment_methods: [cash])
      event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                    min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                    offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                    default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                            estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
      original_code = order.code

      # Act
      order.update!(number_of_guests: 55)

      # Assert
      expect(order.code).to eq original_code
    end
  end

  describe 'calcula valor padrão do pedido' do
    it 'ao criar um novo pedido' do
      # Arrange
      cash = PaymentMethod.create!(name: 'Dinheiro')
      admin = Admin.create!(email: 'saboresdivinos@email.com', password: 'senha123')
      buffet = Buffet.create!(corporate_name: 'Sabores Divinos Eventos Ltda.', brand_name: 'Sabores Divinos Buffet',
                              registration_number: CNPJ.generate, number_phone: '(55)5555-5555',
                              email: 'contato@saboresdivinos.com',  full_address: 'Av. das Delícias, 1234',
                              neighborhood: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '01234-567',
                              description: 'Sabores Divinos Buffet é especializado em transformar eventos em experiências inesquecíveis',
                              admin: admin, payment_methods: [cash])
      event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                    min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                    offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                    default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                            estimated_date: 2.weeks.from_now.next_weekday, address: 'Avenida Principal, 100')

      # Act
      result = order.default_value

      # Assert
      expect(result).to eq 25_000
    end
  end
end
