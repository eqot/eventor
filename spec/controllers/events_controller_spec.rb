require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before :each do
    @user = create(:user)
    sign_in @user

    @event = create(:event)
  end

  describe 'Get #index' do
    it "populates an array of events ordering by date" do
      next_event = create(:event)

      get :index
      expect(assigns(:events)).to match([@event, next_event])
    end

    context 'with invitees only event' do
      before :each do
        sign_out @user
      end

      it "populates an array of events which can be seen by invitee" do
        invitee = @event.invitees[0]
        sign_in invitee

        get :index
        expect(assigns(:events)).to match([@event])
      end

      it "populates an array of events which cannot be seen by non-invitee" do
        non_invitee = create(:user)
        sign_in non_invitee

        get :index
        expect(assigns(:event)).to eq nil
      end
    end
  end

  describe 'Get #show' do
    it "assigns the requested event to @event" do
      get :show, id: @event
      expect(assigns(:event)).to eq @event
    end
  end
end
