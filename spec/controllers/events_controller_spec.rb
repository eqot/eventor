require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'Get #show' do
    it "assigns the requested event to @event" do
      user = create(:user)
      sign_in user

      event = create(:event)
      get :show, id: event
      expect(assigns(:event)).to eq event
    end
  end
end
