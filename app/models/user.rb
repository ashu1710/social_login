class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
			user.email = data["email"] if user.email.blank?
			end
		end
	end

  	def self.from_omniauth(auth)
    	# Either create a User record or update it based on the provider (Google) and the UID
	    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	      user.email = auth.info.email
	      user.password = '321321'
	      user.token = auth.credentials.token
	      user.expires = auth.credentials.expires
	      user.expires_at = auth.credentials.expires_at
	      user.refresh_token = auth.credentials.refresh_token
	    end
  	end

  	 def self.koala(auth)
	    access_token = auth['token']
	    facebook = Koala::Facebook::API.new(access_token)
	    binding.pry
	    facebook.get_connections("me", "friends")
	    # facebook.get_object("me?fields=name,picture")
  	end


end
