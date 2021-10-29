# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "\n== Creating default admin set"
admin_set = AdminSet.find(AdminSet.find_or_create_default_admin_set_id)

puts "\n== Creating default collection types"
Hyrax::CollectionType.find_or_create_default_collection_type
Hyrax::CollectionType.find_or_create_admin_set_type
collection_types = Hyrax::CollectionType.all
collection_types.each do |c|
  next unless c.title =~ /^translation missing/
  oldtitle = c.title
  c.title = I18n.t(c.title.gsub("translation missing: en.", ''))
  c.save
  Rails.logger.debug "#{oldtitle} changed to #{c.title}"
end

puts "\n== Loading workflows"
Hyrax::Workflow::WorkflowImporter.load_workflows
errors = Hyrax::Workflow::WorkflowImporter.load_errors
abort("Failed to process all workflows:\n  #{errors.join('\n  ')}") unless errors.empty?

puts "\n== Creating permission template"
begin
  permission_template = admin_set.permission_template
  # If the permission template is missing we will need to run the creete service
rescue
  Hyrax::AdminSetCreateService.new(admin_set: admin_set, creating_user: nil).create
end

puts "\n== Creating admin user"
admin = User.find_by(email: 'admin@example.com') || User.create!(email: 'admin@example.com', password: 'testing123')
role = Role.find_or_create_by!(name: 'admin')
role.users |= [admin]