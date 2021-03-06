# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
MoveType.destroy_all
Moving.destroy_all
Item.destroy_all
Client.destroy_all
Mover.destroy_all

# Create Move Type
move_types = [
    {
        text: 'Small Move',
        factor: 1,
        icon: 'dolly',
        value: 1,
        items: 2
    },
    {
        text: 'Room Move',
        factor: 1.4,
        icon: 'dolly flatbed',
        value: 2,
        items: 5
    },
    {
        text: 'Apt Move',
        factor: 1.7,
        icon: 'truck',
        value: 3,
        items: 10
    },
    {
        text: 'House Move',
        factor: 2,
        icon: 'home',
        value: 4,
        items: 15
    }
]

move_types.each do |t|
  MoveType.create(
      moving_type: t[:text],
      price_factor: t[:factor],
      icon: t[:icon],
      move_value: t[:value]
  )
end

10.times {
  # Creating the Client
  name = Faker::Name.unique.name
  c = Client.create(
      name: name,
      email: Faker::Internet.unique.email,
      password: 'handly_bot',
      avatar: Faker::Avatar.image,
      phone_number: Faker::PhoneNumber.cell_phone,
      email_verified: Faker::Boolean.boolean
  )
  # Creating the Mover
  company_name = Faker::Company.unique.name
  m = Mover.create(
      company_name: company_name,
      admin_name: Faker::Name.unique.name,
      address: Faker::Address.full_address,
      logo: Faker::Company.logo,
      verified: Faker::Boolean.boolean,
      insured: Faker::Boolean.boolean,
      bid_factor: rand(0.85...1.15)
  )

  # Creating the moving
  origin_address = Faker::Address.full_address.split(',')
  origin_state = origin_address[2].strip.split(' ')[0]

  destination_address = Faker::Address.full_address.split(',')
  destination_state = destination_address[2].strip.split(' ')[0]

  distance = rand(1...10)
  estimate = 30 + (distance * 8)

  review = [
      'were amazing handling my stuff.',
      'were on time, and handled everything cleanly',
      'are very honest and careful with their work',
      'have an amazing staff! thanks!',
      'are awesome <3',
      'I love you guys',
      'great, great ,great service, recommended.'
  ]
  Moving.create(
      client: c,
      mover: m,
      origin_administrative: origin_state,
      origin_address: origin_address[0],
      destination_administrative: destination_state,
      destination_address: destination_address[0],
      moving_time: Faker::Date.backward(14),
      distance: distance,
      estimate: estimate,
      final_price: estimate,
      moving_rating: rand(3...5),
      moving_review: "#{company_name} #{review.sample}",
      move_type_id: MoveType.first.id,
      status: "Completed"
  )

  # Create Items
  2.times { Item.create(client: c, item_type: Faker::House.furniture, weight: rand(10...100)) }

}

