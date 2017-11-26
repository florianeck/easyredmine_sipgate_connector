class SipgateConnectorController < ApplicationController
  
  before_filter :require_login
  
  def auth
    redirect_to rusip_auth.auth_redirect_url
  end
  
  def callback
    if params[:code]
      
    end    
  end
  
  private 
  
  def rusip_auth
    @_rusip_auth ||= RuSip::Auth.new(
      EasyredmineSipgateConnector.client_id,
      EasyredmineSipgateConnector.client_secret,
      EasyredmineSipgateConnector.redirect_url,
      EasyredmineSipgateConnector.scope
    )
  end
  
end