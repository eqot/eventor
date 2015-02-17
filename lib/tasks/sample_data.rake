namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    clean
    # make_users
    make_events
    register_events
  end
end

def clean
  # User.all.delete_all
  Event.all.delete_all
  EventInvitation.all.delete_all
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
        description: Faker::Lorem.paragraph,
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
    Event.all[26..39].each do |event|
      event.attend!(user)
    end
  end
end
