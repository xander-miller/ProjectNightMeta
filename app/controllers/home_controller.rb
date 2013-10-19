class HomeController < ApplicationController
  before_action :set_location, only: :index

  def index
    hash = build_conditions
    order = "updated_at desc, language, full_name"
    @projects = Project.where(hash).order(order).offset(0).limit(50)
    @title = "Home"
  end

  def about
    @title = "About"
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
