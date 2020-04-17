require 'google/apis/people_v1'
require 'google/api_client/client_secrets.rb'
require 'koala'
require 'net/http'
class HomeController < ApplicationController
	People = Google::Apis::PeopleV1
	def index
		if current_user.present? && current_user.provider.eql?("google_oauth2")
		    secrets = Google::APIClient::ClientSecrets.new(
		      {
		        "web" =>
		          {
		            "access_token" => current_user.token,
		            "refresh_token" => current_user.refresh_token,
		            "client_id" => ENV['google_client_id'],
		            "client_secret" => ENV['google_secret']
		          }
		      }
		    )
		    service = People::PeopleServiceService.new
		    service.authorization = secrets.to_authorization
		    @response = service.list_person_connections(
		      'people/me',
		       person_fields: ['names', 'emailAddresses', 'phoneNumbers']
		    )
		elsif current_user.present? && current_user.provider.eql?("facebook")
		    # @user = User.koala(request.env["omniauth.auth"]['credentials'])
		elsif current_user.present? && current_user.provider.eql?("github")
			@github_hash = {repo_list: {}, clone_url: {}, ssh_url: {}}
			@github_hash.merge!(repo_list: HTTParty.get(current_user.github_repo))
		end
	end
end
