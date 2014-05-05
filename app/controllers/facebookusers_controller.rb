class FacebookusersController < ApplicationController
 def start
   redirect_to client.authorization.authorize_url(:redirect_uri => "http://#{request.env['HTTP_HOST']}/facebookusers/callback/" ,
      :client_id => '514601985316733',:scope => 'email')

  end

  def callback
    @access_token = client.authorization.process_callback(params[:code], :redirect_uri => "http://#{request.env['HTTP_HOST']}/facebookusers/callback/")
    session[:access_token] = @access_token
    @fb_user = client.selection.me.info!
    logger.warn("-----------------------------------------------------")
    logger.warn(@fb_user.inspect)
    user = User.find_or_create_by(email: @fb_user.email)
    session[:email] = @fb_user.email
    user.save(validate: false)
  
  end

  def sign_out
    session[:access_token] = nil
    session[:email] = nil
    redirect_to root_url
  end

  def invite_friend
  end
  
  protected

  def client
    @client ||= FBGraph::Client.new(:client_id => '514601985316733',:secret_id => '32247c021fd7e86b5daa1c2fca6e6f19' ,
      :token => session[:access_token])
  end
end
