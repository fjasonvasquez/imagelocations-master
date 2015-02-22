# Companies
$IMAGE_LOCATIONS_COMPANY = Company.create   :name => "Image Locations",
								:logo => File.open("#{Rails.root}/public/imagelocations_logo.gif")
								
								

# Roles & Permissions

admin_role = Role.find_by_name("admin")
#admin_role.permissions << Permission.find(1)
#admin_role.level = 0
#admin_role.save

admin_membership = Membership.new
admin_membership.role = admin_role
admin_membership.set_all_sites TRUE

admin_membership2 = Membership.new
admin_membership2.role = admin_role
admin_membership2.set_all_sites TRUE

# Users

#Create Admin User
a = User.create({
		:email => 'admin@imagelocations.com', 
        :password => '12345678', 
        :password_confirmation => '12345678',
        :profile_attributes => {
        	:first_name => "Admin",
        	:last_name => "Istrator",
        	:company => $IMAGE_LOCATIONS_COMPANY
        },
        :memberships => [admin_membership]
})
        
#Create Admin User
a2 = User.create({
		:email => 'mailo.arsac@geosith.com', 
        :password => '12345678', 
        :password_confirmation => '12345678',
        :profile_attributes => {
        	:first_name => "Mailo",
        	:last_name => "Arsac",
        	:company => $IMAGE_LOCATIONS_COMPANY
        },
        :memberships => [admin_membership2]
})
       
#a.profile.first_name = "Mailo"
#a.profile.last_name = "Arsac"
#a.profile.save
#Membership.create	:user => a,
#					:role => @admin_role,
#1`					:site_id => 0


#Create Registered User					
u = User.create   :email => 'paul@imagelocations.com',
        :password => 'pk123456', 
        :password_confirmation => 'pk123456',
        :memberships_attributes => [{
	        :role => Role.find_by_name("manager"),
	        :site => Site.default
        }]

u = User.create   :email => 'louie@b-rolling.com',
        :password => '1heredia1', 
        :password_confirmation => '1heredia1',
        :memberships_attributes => [{
	        :role => Role.find_by_name("manager"),
	        :site => Site.default
        }]

u2 = User.create   :email => 'jason@imagelocations.com',
        :password => 'dragonforce', 
        :password_confirmation => 'dragonforce',
        :memberships_attributes => [{
	        :role => Role.find_by_name("manager"),
	        :site => Site.default
        }]

