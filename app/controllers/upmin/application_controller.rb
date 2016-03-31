module Upmin
  class ApplicationController < ActionController::Base
    if ::Rails.version.to_i < 4
      protect_from_forgery
    else
      protect_from_forgery with: :exception
    end
  end
end
