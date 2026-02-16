class HomeController < ApplicationController
  def index
  end

  def search
    address = params[:address]
    redirect_to root_path and return if address.blank?

    forecast = WeatherService.new(params[:address]).fetch

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("result-display",
          partial: "forecast_result",
          locals: { forecast: forecast })
      end
    end
  end
end
