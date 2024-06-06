require 'rails_helper'

RSpec.describe BuffetPhoto, type: :model do
  it {should belong_to :buffet}
  it {should belong_to :photo}
end
