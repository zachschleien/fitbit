class FitbitApiController < ApplicationController

  before_filter :authenticate_user!
  require 'csv'
  
  def data_request
    client = current_user.fitbit_client
    output_filename = ''
    case params[:resource]
        when 'daily_activity_summary'; output = client.activity_time_series(resource: 'calories', start_date: params[:date], period: '1d')
            output_filename = 'daily_activity_summary'
        when 'sleep'; output = client.sleep_logs(params[:date])
            output_filename = 'sleep'
        when 'activities/steps'; output = client.activity_time_series(resource: 'steps', start_date: params[:date], period: '1d')
            output_filename = 'steps'
        when 'weight'; output = client.weight_logs(start_date: params[:date])
            output_filename = 'weight'
    end


    output.each do |key, value|
        output[key] = value.to_json if value.class.in?([Array, Hash])
    end

    # Determine filename based on value of params[:resource]
    filename = params[:resource].split('/').last

    # Write data to CSV
    require 'json_converter'
    converter = JsonConverter.new

    csv = converter.generate_csv(output.to_json, true, '')
    
    send_data csv, :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{output_filename}.csv"

    # Render the JSON anyway
    # render json: output
     # send_file('/Users/Zach/Desktop/' + output_filename, type: 'text/csv', disposition: 'attachment', filename: 'contacts.csv')

     # send_data converter, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;output_filename=#{output_filename}.csv"

    # send_data(output_filename,
    #   :type => 'text/csv; charset=utf-8; header=present',
    #   :filename => output)

    # send_data output_filename,
    #    :type => 'text/csv; charset=iso-8859-1; header=present',
    #    :disposition => "attachment; filename=converter.csv" 

    # File.open('/Users/Zach/Desktop/FitgemOAuth2Rails/' + output_filename, 'r') do |f|
    #   send_data f.read, type: 'text/csv', disposition: 'attachment', filename: 'contacts.csv'
    # end
    # File.delete('/Users/Zach/Desktop/FitgemOAuth2Rails/' + output_filename)


    
  end
end
