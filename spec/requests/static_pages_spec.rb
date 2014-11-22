require 'rails_helper'

describe "Static pages" do

  describe "Top page" do

    it "should have the content 'Congreg'" do
      visit root_path
      expect(page).to have_content('Congreg')
    end
  end
end
