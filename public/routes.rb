Rails.application.routes.draw do

  scope AppConfig[:public_proxy_prefix] do
    get  'cancel_request' => 'requests#cancel_request'
  end

end
