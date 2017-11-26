get "/sipgate/auth"       => "sipgate_connector#auth",      as: :sipgate_auth
get "/sipgate/callback"   => "sipgate_connector#callback",  as: :sipgate_callback

post "/sipgate/make_call" => "sipgate_connector#make_call", as: :sipgate_make_call