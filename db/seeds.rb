# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

users = User.create(
  [
    {
      username: "adm",
      password: "909d7501be4a3df32a592e5d05773d18",
      email: "",
      phone_no: "",
      description: "",
      role_id: 1
    },
    {
      username: "admin",
      password: "909d7501be4a3df32a592e5d05773d18",
      email: "",
      phone_no: "",
      description: "",
      role_id: 2
    }
  ]
)
