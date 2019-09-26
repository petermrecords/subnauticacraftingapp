class ApplicationController < ActionController::Base
  def index
    render html: '<h1>Hello world</h1>', layout: 'application'
  end
end
