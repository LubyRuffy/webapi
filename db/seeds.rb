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

Check.create([  
	{name:'Xss'}, 
	{name:'Sql injection'},
	{name:'Webshell'},
	{name:'Code injection'},
	{name:"File inclusion"},
	{name:'CSRF'},
	{name:'Other'}]
)   
Template.create(
	{name:'test',
	checks:['1','2','3','4','5','6','7'],
	ref:0}
)

#save plugins
io = File.open("./db/checks")
plugins = io.readlines
i = 0
plugins.each do |tmp|
	Plugin.create(name:tmp,checks_id:(i%7+1))
	i=i+1
end

Diskcheck.create(db_limit: 1, report_limit:2)

License.create(license:'', valid_time: '', activate_time: '', expired_time: '', activated: false)

