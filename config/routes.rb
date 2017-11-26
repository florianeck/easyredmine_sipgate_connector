get "/sipgate/auth" => "sipgate_connector#auth", as: :sipgate_auth
get "/sipgate/callback" => "sipgate_connector#callback", as: :sipgate_callback