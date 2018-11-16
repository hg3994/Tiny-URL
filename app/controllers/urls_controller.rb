class UrlsController < ApplicationController

	# post		 'urls/create_shorturl'
	# params[:long_url]
	# API for creating a shortened URL of a long URL.
	# If the long URL already exists, then show the short URL already formed.
	def create_shorturl
		long_url = beautify_url params[:long_url]
		long_url_present = Url.find_by_long_url(long_url)
		present = false
		if long_url_present.nil?
			@url = Url.create!(long_url: long_url)
			short_url = get_short_url_from_id @url.id
			present = false
		else
			present = true
			short_url = get_short_url_from_id long_url_present.id
		end
		respond_to do |format|
			if present
				format.js {render inline: "alert('already present'); location.reload();"}
			else
				format.js {render inline: "alert('created');location.reload();"}
			end
		end
	end

	# post     'urls/get_longurl'
	# params[:short_url]
	# API for fetching Long URLs from the Short URLs
	def get_longurl
		url_id = get_id_from_short_url params[:short_url]
		url = Url.find(url_id)
		json_response({long_url: "Long URL for the given Short URL: www.tinyurl/#{params[:short_url]} is: #{url[:long_url]}"})
	end

	# get      'urls/show_short_urls'
	# API for fetching the list of shortened URLs
	def show_short_urls
		urls = Url.all
		@short_url_list = []
		urls.each do |url|
			short_url = get_short_url_from_id url.id
			@short_url_list << short_url
		end
		render "url"
	end

	# delete 	 'urls/delete_short_url'
	# params[:short_url]
	# API for deleting a short url from the DB
	def delete_short_url
		url_id = get_id_from_short_url params[:short_url]
		url = Url.find(url_id)
		current_page_url = "/urls/show_short_urls"

		url.destroy
    respond_to do |format|
      format.html { redirect_to current_page_url, notice: 'url is successfully Deleted.' }
      format.json { head :no_content }
    end
	end

	private

	# To get the base62 format of the ID.
	def get_short_url_from_id n
    # Map to store 62 possible characters 
    map = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; 
   	shorturl = ""

    # Convert given integer id to a base 62 number 
    while n!=0 do
        # use above map to store actual character in short url 
        shorturl += map[n%62]; 
        n = n/62; 
 		end
    # Reverse shortURL to complete base conversion 
    shorturl.reverse!
  end

  # To get the decimal format of the base 62 number.
	def get_id_from_short_url shortURL
	    id = 0 # initialize result 

	    # A simple base conversion logic 
	    (0...shortURL.size).each do |i| 
	        if ('a' <= shortURL[i] && shortURL[i] <= 'z') 
	          id = id*62 + shortURL[i].ord - 'a'.ord; 
	        end

	        if ('A' <= shortURL[i] && shortURL[i] <= 'Z') 
	          id = id*62 + shortURL[i].ord - 'A'.ord + 26; 
	        end

	        if ('0' <= shortURL[i] && shortURL[i] <= '9') 
	          id = id*62 + shortURL[i].ord - '0'.ord + 52;
	        end 
	    end

	    id
	end

	def beautify_url url
		url.strip!
		sanitized_url = url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
		sanitized_url.slice!(-1) if sanitized_url[-1] == "/"
		sanitized_url = "http://#{sanitized_url}"
		sanitized_url
	end

  def json_response(object, status = :ok)
    render json: object, status: status
  end

end
