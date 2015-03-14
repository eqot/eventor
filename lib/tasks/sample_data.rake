namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    clean
    # make_users
    # make_events
    # register_events
    # make_notifications
    invite_users
  end
end

def clean
  # User.all.delete_all
  # Event.all.delete_all
  # EventInvitation.all.delete_all
  Notification.all.delete_all
end

def make_users
  User.create!(
    email: 'foo@bar.com',
    name: 'Foo Bar',
    password: 'foobar'
  )

  3.times do
    User.create!(
      email: Faker::Internet.email,
      name: Faker::Name.name,
      password: '123456'
    )
  end
end

def make_events
  User.all[0..3].each do |user|
    10.times do |index|
      if index < 3
        start_time = Faker::Time.backward(20)
      else
        start_time = Faker::Time.forward(50)
      end
      end_time = start_time + 1.hour

      event = Event.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph(10),
        owner_id: user.id
      )

      EventInvitation.create!(
        start_time: start_time,
        end_time: end_time,
        location: Faker::Address.city,
        event_id: event.id
      )
    end
  end
end

def register_events
  User.all[0..3].each do |user|
    Event.all[6..29].each do |event|
      event.attend!(user)
    end
  end
end

def make_notifications
  10.times do |index|
    notification = Notification.create!(
      description: Faker::Lorem.sentence,
      image: nil,
      url:  Faker::Internet.url
    )

    User.all[0..3].each do |user|
      notification.notify!(user)
    end
  end
end

def invite_users
  User.all[0..3].each do |user|
    Event.all[7..16].each do |event|
      event.invite!(user)
    end
  end
end
