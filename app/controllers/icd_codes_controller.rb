class IcdCodesController < ApplicationController
  def search
    codes = IcdCode.search_by(params[:q]).limit(10)
    render json: codes.map { |c| { code: c.code, description: c.description } }
  end
end
