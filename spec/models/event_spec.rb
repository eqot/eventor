require 'rails_helper'

describe Event do
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:image_file) }
  it { should respond_to(:image_url) }
  it { should respond_to(:status) }
  it { should respond_to(:visibility) }
  it { should respond_to(:owner_id) }

  it "is valid with a title" do
    event = build(:event)
    expect(event).to be_valid
  end

  it "is invalid without a title" do
    event = build(:event, title: nil)
    expect(event).to have(1).errors_on(:title)
  end

  it "should have 4 attendees" do
    event = create(:event)
    expect(event.attendees).to have(4).items
  end

  it "should have 4 invitees" do
    event = create(:event)
    expect(event.invited_members).to have(4).items
  end
end
