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
    password: "foobarbaz"
  )
end

def make_events
  user = User.first

  100.times do
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
