require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid' do
    context 'Endereço' do
      it {should validate_presence_of :address}
    end

    context 'Quantidade de Convidados' do
      it {should validate_presence_of :number_of_guests}

      it 'Quantidade de Convidados não pode ser menor do que o mínimo para o evento' do
        # Arrange
        loadBuffet
        buffet = Buffet.first
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
        loadBuffet
        buffet = Buffet.first
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
        loadBuffet
        buffet = Buffet.first
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
      it {should validate_presence_of :estimated_date}
      it {should validate_comparison_of(:estimated_date).is_greater_than(Date.today)}
    end

    it {should validate_presence_of :status}
    it {should define_enum_for(:status).with_values(pending: 0, cancelled: 5, pending_confirmation: 7,
                                                    expired: 8, accepted: 10)}

  end

  describe 'gera um código aleatório' do
    it  'ao criar um novo pedido' do
      # Arrange
      order = Order.new()

      # Act
      order.save
      result = order.code

      # Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end
    it  'e o código é único' do
      # Arrange
      loadBuffetAndEventType
      event_type = EventType.first
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      first_order = Order.create!(event_type: event_type, buffet: event_type.buffet, customer: customer, number_of_guests: 80,
                                  estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
      second_order = Order.new(event_type: event_type, buffet: event_type.buffet, customer: customer, number_of_guests: 55,
                              estimated_date: 2.months.from_now, address: 'Avenida Principal, 289')


      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      # Arrange
      loadBuffetAndEventType
      event_type = EventType.first
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: event_type.buffet, customer: customer, number_of_guests: 80,
                            estimated_date: 1.month.from_now, address: 'Avenida Principal, 100')
      original_code = order.code

      # Act
      order.update!(number_of_guests: 55)

      # Assert
      expect(order.code).to eq original_code
    end
  end

  describe 'calcula valor padrão do pedido' do
    it 'em dias de semana' do
      loadBuffet
      buffet = Buffet.first
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

      expect(order.default_value).to eq 25_000
    end

    it 'em finais de semana' do
      loadBuffet
      buffet = Buffet.first
      event_type = EventType.create!(name: 'Festa de Casamento', description: 'Celebre seu dia do SIM com o nosso buffet',
                                    min_guests: 20, max_guests: 100, default_duration: 90, menu: 'Bolo e Doces',
                                    offer_decoration: true, offer_drinks: false, offer_parking_service: true,
                                    default_address: :indicated_address, min_value: 10_000.00, additional_per_guest: 250.00,
                                    extra_hour_value: 1_000.00, weekend_min_value: 14_000.00,
                                    weekend_additional_per_guest: 300.00, weekend_extra_hour_value: 1_500.00,
                                    buffet: buffet)
      customer = Customer.create!(name: 'Maria', cpf: CPF.generate, email: 'maria@email.com', password: 'senha123')
      order = Order.create!(event_type: event_type, buffet: buffet, customer: customer, number_of_guests: 80,
                            estimated_date: 2.weeks.from_now.end_of_week, address: 'Avenida Principal, 100')

      expect(order.default_value).to eq 32_000
    end
  end

  describe 'Associações' do
    it {should belong_to :buffet}
    it {should belong_to :event_type}
    it {should belong_to :customer}
    it {should have_one :event}
  end
end
