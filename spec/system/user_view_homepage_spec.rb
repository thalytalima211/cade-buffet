require 'rails_helper'

describe 'Usuário entra na página inicial' do
  it 'com sucesso' do
    visit root_path
    expect(page).to have_content 'Cadê buffet?'
  end
end
