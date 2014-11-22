require 'rails_helper'
describe 'Static pages' do
  describe 'Top page' do
    it "should have the content 'Eventor'" do
      visit root_path
      expect(page).to have_content('Eventor')
    end
  end
end
