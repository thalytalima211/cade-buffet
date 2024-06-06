require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe '#valid' do
    it {should validate_presence_of :name}

    it {should validate_presence_of :description}

    it {should validate_presence_of :min_guests}
    it {should validate_numericality_of(:min_guests).is_greater_than(0)}

    it {should validate_presence_of :max_guests}
    it {should validate_numericality_of(:max_guests).is_greater_than(0)}

    it 'Número máximo de pessoas deve ser maior ou igual ao número mínimo de pessoas' do
      event_type = EventType.new(min_guests: 50, max_guests: 10)
      event_type.valid?
      expect(event_type.errors.include? :max_guests).to be true
      expect(event_type.errors[:max_guests]).to include('deve ser maior ou igual a 50')
    end

    it {should validate_presence_of :menu}

    it {should validate_presence_of :default_address}
    it {should define_enum_for(:default_address).with_values(buffet_address: 0, indicated_address: 1)}

    it {should validate_presence_of :min_value}
    it {should validate_numericality_of(:min_value).is_greater_than(0)}

    it {should validate_presence_of :additional_per_guest}
    it {should validate_numericality_of(:additional_per_guest).is_greater_than(0)}

    it {should validate_presence_of :extra_hour_value}
    it {should validate_numericality_of(:extra_hour_value).is_greater_than(0)}

    it {should validate_presence_of :weekend_min_value}
    it {should validate_numericality_of(:weekend_min_value).is_greater_than(0)}

    it {should validate_presence_of :weekend_additional_per_guest}
    it {should validate_numericality_of(:weekend_additional_per_guest).is_greater_than(0)}

    it {should validate_presence_of :weekend_extra_hour_value}
    it {should validate_numericality_of(:weekend_extra_hour_value).is_greater_than(0)}

    it {should validate_presence_of :default_duration}
    it {should validate_numericality_of(:default_duration).is_greater_than(0)}
  end

  describe 'Associações' do
    it {should have_many :orders}
    it {should belong_to :buffet}
  end
end
