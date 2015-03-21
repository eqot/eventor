require 'rails_helper'

describe Event do
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:image_file) }
  it { should respond_to(:image_url) }
  it { should respond_to(:status) }
  it { should respond_to(:visibility) }
  it { should respond_to(:owner_id) }

  it { should respond_to(:invitees) }

  it 'is valid with a title' do
    event = build(:event)
    expect(event).to be_valid
  end

  it 'is invalid without a title' do
    event = build(:event, title: nil)
    expect(event).to have(1).errors_on(:title)
  end

  it 'should have right attendees' do
    event = create(:event)
    expect(event.attendees).to have(4).items
  end

  it 'should have right invitees' do
    event = create(:event)

    4.times do
      invitee = create(:user)
      event.invite!(invitee)
    end

    expect(event.invitees).to have(4).items
  end
end
