Rails.application.routes.draw do

  get      'urls/show_short_urls', to: 'urls#show_short_urls' 

  post		 'urls/create_shorturl', to: 'urls#create_shorturl' # params[:long_url]

  get     'urls/get_longurl/:short_url', to: 'urls#get_longurl', as: 'get_longurl' # params[:short_url]
  
  delete 	 'urls/delete_short_url/:short_url', to: 'urls#delete_short_url', as: 'delete_longurl' #params[:short_url]

end
