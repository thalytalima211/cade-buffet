require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe '#valid' do
    it 'deve ter Nome' do
      event_type = EventType.new(name: '')
      event_type.valid?
      expect(event_type.errors.include? :name).to be true
    end

    it 'deve ter Descrição' do
      event_type = EventType.new(description: '')
      event_type.valid?
      expect(event_type.errors.include? :description).to be true
    end

    it 'deve ter Número mínimo de pessoas' do
      event_type = EventType.new(min_guests: '')
      event_type.valid?
      expect(event_type.errors.include? :min_guests).to be true
    end

    it 'Número mínimo de pessoas deve ser maior do que 0' do
      event_type = EventType.new(min_guests: 0)
      event_type.valid?
      expect(event_type.errors.include? :min_guests).to be true
      expect(event_type.errors[:min_guests]).to include('deve ser maior que 0')
    end

    it 'deve ter Número máximo de pessoas' do
      event_type = EventType.new(max_guests: '')
      event_type.valid?
      expect(event_type.errors.include? :max_guests).to be true
    end

    it 'Número máximo de pessoas deve ser maior do que 0' do
      event_type = EventType.new(max_guests: 0)
      event_type.valid?
      expect(event_type.errors.include? :max_guests).to be true
      expect(event_type.errors[:max_guests]).to include('deve ser maior que 0')
    end

    it 'Número máximo de pessoas deve ser maior ou igual ao número mínimo de pessoas' do
      event_type = EventType.new(min_guests: 50, max_guests: 10)
      event_type.valid?
      expect(event_type.errors.include? :max_guests).to be true
      expect(event_type.errors[:max_guests]).to include('deve ser maior ou igual a 50')
    end

    it 'deve ter Cardápio' do
      event_type = EventType.new(menu: '')
      event_type.valid?
      expect(event_type.errors.include? :menu).to be true
    end

    it 'deve ter Endereço padrão' do
      event_type = EventType.new(default_address: '')
      event_type.valid?
      expect(event_type.errors.include? :default_address).to be true
    end

    it 'deve ter Valor mínimo' do
      event_type = EventType.new(min_value: '')
      event_type.valid?
      expect(event_type.errors.include? :min_value).to be true
    end

    it 'Valor mínimo deve ser maior do que 0' do
      event_type = EventType.new(min_value: 0)
      event_type.valid?
      expect(event_type.errors.include? :min_value).to be true
      expect(event_type.errors[:min_value]).to include('deve ser maior que 0')
    end

    it 'deve ter Adicional por pessoa' do
      event_type = EventType.new(additional_per_guest: '')
      event_type.valid?
      expect(event_type.errors.include? :additional_per_guest).to be true
    end

    it 'Adicional por pessoa deve ser maior do que 0' do
      event_type = EventType.new(additional_per_guest: 0)
      event_type.valid?
      expect(event_type.errors.include? :additional_per_guest).to be true
      expect(event_type.errors[:additional_per_guest]).to include('deve ser maior que 0')
    end

    it 'deve ter Valor por hora extra' do
      event_type = EventType.new(extra_hour_value: '')
      event_type.valid?
      expect(event_type.errors.include? :extra_hour_value).to be true
    end

    it 'Valor por hora extra deve ser maior do que 0' do
      event_type = EventType.new(extra_hour_value: 0)
      event_type.valid?
      expect(event_type.errors.include? :extra_hour_value).to be true
      expect(event_type.errors[:extra_hour_value]).to include('deve ser maior que 0')
    end

    it 'deve ter Valor mínimo no final de semana' do
      event_type = EventType.new(weekend_min_value: '')
      event_type.valid?
      expect(event_type.errors.include? :weekend_min_value).to be true
    end

    it 'Valor mínimo no final de semana deve ser maior do que 0' do
      event_type = EventType.new(weekend_extra_hour_value: 0)
      event_type.valid?
      expect(event_type.errors.include? :weekend_extra_hour_value).to be true
      expect(event_type.errors[:weekend_extra_hour_value]).to include('deve ser maior que 0')
    end

    it 'deve ter Adicional por pessoa no final de semana' do
      event_type = EventType.new(weekend_additional_per_guest: '')
      event_type.valid?
      expect(event_type.errors.include? :weekend_additional_per_guest).to be true
    end

    it 'Adicional por pessoa no final de semana deve ser maior do que 0' do
      event_type = EventType.new(weekend_additional_per_guest: 0)
      event_type.valid?
      expect(event_type.errors.include? :weekend_additional_per_guest).to be true
      expect(event_type.errors[:weekend_additional_per_guest]).to include('deve ser maior que 0')
    end

    it 'deve ter Valor por hora extra no final de semana' do
      event_type = EventType.new(weekend_extra_hour_value: '')
      event_type.valid?
      expect(event_type.errors.include? :weekend_extra_hour_value).to be true
    end

    it 'Valor por hora extra no final de semana deve ser maior do que 0' do
      event_type = EventType.new(weekend_extra_hour_value: 0)
      event_type.valid?
      expect(event_type.errors.include? :weekend_extra_hour_value).to be true
      expect(event_type.errors[:weekend_extra_hour_value]).to include('deve ser maior que 0')
    end

    it 'deve ter Duração padrão' do
      event_type = EventType.new(default_duration: '')
      event_type.valid?
      expect(event_type.errors.include? :default_duration).to be true
    end

    it 'Duração padrão deve ser maior do que 0' do
      event_type = EventType.new(default_duration: 0)
      event_type.valid?
      expect(event_type.errors.include? :default_duration).to be true
      expect(event_type.errors[:default_duration]).to include('deve ser maior que 0')
    end
  end
end
