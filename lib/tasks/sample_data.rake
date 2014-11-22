namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    clean
    make_users
    make_events
  end
end

def clean
  User.all.delete_all
  Event.all.delete_all
end

def make_users
  User.create!(
    email: "foo@bar.com",
    name: "Foo Bar",
    password: "foobar"
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
    10.times do
      start_time = Faker::Time.forward(20)
      end_time = start_time + 1.hour

      Event.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        start_time: start_time,
        end_time: end_time,
        place: Faker::Address.city,
        user_id: user.id
      )
    end
  end
end
