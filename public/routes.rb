Rails.application.routes.draw do

  get 'cancel_request' => 'requests#cancel_request', as: "cancel_request"

end