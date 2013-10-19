class HomeController < ApplicationController
  before_action :set_location, only: :index

  # GET /
  def index
    hash = build_conditions
    order = "updated_at desc, language, full_name"
    @projects = Project.where(hash).order(order).offset(0).limit(50)
    @title = "Home"
  end

  # GET /about
  def about
    @title = "About"
  end

  # PUT /location/change
  def change_city
    location = Location.new_string(params[:location])
    session[:ip_city] = location.city
    session[:ip_region] = location.region
    session[:ip_country] = location.country
    redirect_to "/"
  rescue Exception => e
    log_error_and_redirect_to(e, "/")
  end


  protected
    def build_conditions
      if session[:ip_city].blank?
        hash = {visible: true}
      else
        hash = {city: session[:ip_city], visible: true}
      end
      hash
    end
end
