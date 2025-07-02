# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Users
user1 = User.find_or_create_by!(name: 'Joe')
user2 = User.find_or_create_by!(name: 'Patricia')
user3 = User.find_or_create_by!(name: 'Aaron')

# Create Trails
trail1 = Trail.find_or_create_by!(
  name: 'Kings Mountain',
  location: 'Tillamook Forest',
  length: 5,
  elevation: 2532,
  description: 'A beautiful loop through the forest with scenic views.'
)

trail2 = Trail.find_or_create_by!(
  name: 'Dog Mountain',
  location: 'Columbia River Gorge',
  length: 6,
  elevation: 2952,
  description: 'Challenging ascent to the summit with panoramic views.'
)

trail3 = Trail.find_or_create_by!(
  name: 'Timberline Trail',
  location: 'Mt Hood Wilderness',
  length: 40,
  elevation: 9852,
  description: 'Circumnavigate Mt Hood on this historic trail.'
)

# Create comments for trails
Comment.find_or_create_by!(
  content: 'So beautiful!',
  trail_id: trail1.id
)

Comment.find_or_create_by!(
  content: 'Really challenging',
  trail_id: trail1.id
)

Comment.find_or_create_by!(
  content: 'It was sooooo rainy. Took me way longer than I thought.',
  trail_id: trail1.id
)

Comment.find_or_create_by!(
  content: 'Go in May to see the best wildflowers!',
  trail_id: trail2.id
)

Comment.find_or_create_by!(
  content: 'Bring lots of snacks and water.',
  trail_id: trail2.id
)

Comment.find_or_create_by!(
  content: 'The "more difficult" option is pretty hard. But if you go when it snows, you might get to slide down instead of walk down.',
  trail_id: trail2.id
)

Comment.find_or_create_by!(
  content: 'The up was hard, but the down was so much harder on my knees. Jelly legs on the way home.',
  trail_id: trail2.id
)

Comment.find_or_create_by!(
  content: 'Hot tip! Book a stay at the lodge and camp there as a halfway point.',
  trail_id: trail3.id
)

Comment.find_or_create_by!(
  content: 'Lots of water crossings. Be prepared in the spring.',
  trail_id: trail3.id
)

Comment.find_or_create_by!(
  content: 'Fantastic stars!',
  trail_id: trail3.id
)

# Create Activities
Activity.find_or_create_by!(
  name: 'Weekend trek',
  user_id: user1.id,
  trail_id: trail1.id,
  start_time: 5.hours.ago,
  end_time: 1.hour.ago,
  in_progress: false
)

Activity.find_or_create_by!(
  name: 'Afternoon hike',
  user_id: user2.id,
  trail_id: trail2.id,
  start_time: 1.hour.ago,
  in_progress: true
)

Activity.find_or_create_by!(
  name: 'Backpacking trip',
  user_id: user1.id,
  trail_id: trail3.id,
  in_progress: true
)

Activity.find_or_create_by!(
  name: 'Training hike',
  user_id: user3.id,
  trail_id: trail1.id,
  start_time: 6.hours.ago,
  end_time: 3.hours.ago,
  in_progress: false
)

puts "Seeding complete!"
