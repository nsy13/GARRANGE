# Testユーザー用データ

User.create!(name: "Test User",
             email: "test@test.com",
             password: "password")

2.times do |n|
  Calendar.create!(name: "MyCalendar_No.#{n + 1}", color: Faker::Color.hex_color)
  UserCalendar.create!(user_id: 1, calendar_id: n + 1, owner: true)
end

20.times do |n|
  start_date = Date.today + rand(1..20).days + rand(1..12).hours
  Event.create!(title: "Meeting about #{ Faker::Company.buzzword }",
                description: Faker::ChuckNorris.fact,
                start_date: start_date,
                end_date: (start_date.to_time + rand(1..72).hours).to_s,
                place: Faker::Address.country,
                organizer_id: 1)
end

20.times do |n|
  UserEvent.create!(user_id: 1, event_id: n + 1, accepted: true)
end

10.times do |n|
  CalendarEvent.create!(calendar_id: 1, event_id: n + 1)
end

10.times do |n|
  CalendarEvent.create!(calendar_id: 2, event_id: n + 11)
end

# その他ユーザーデータ

20.times do |n|
  User.create!(name: Faker::Name.name,
               email: Faker::Internet.email,
               password: "password")
  Calendar.create!(name: "#{User.find(n + 2).name}のカレンダー", color: Faker::Color.hex_color)
  UserCalendar.create!(user_id: n + 2, calendar_id: n + 3, owner: true)
end

100.times do |n|
  user_id = rand(2..21)
  start_date = Date.today + rand(1..20).days + rand(1..12).hours
  Event.create!(title: "Meeting about #{ Faker::Company.buzzword }",
                description: Faker::ChuckNorris.fact,
                start_date: start_date,
                end_date: (start_date.to_time + rand(1..72).hours).to_s,
                place: Faker::Address.country,
                organizer_id: user_id)
  UserEvent.create!(user_id: user_id, event_id: n + 21, accepted: true)
  CalendarEvent.create!(calendar_id: user_id + 1, event_id: n + 21)
end

50.times do |n|
  event_id = rand(21..120)
  user_id = rand(2..21)
  UserEvent.create!(user_id: 1, event_id: event_id, accepted: false)
  UserEvent.create!(user_id: user_id, event_id: n + 21, accepted: false)
end
