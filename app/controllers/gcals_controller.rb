class GcalsController < ApplicationController
  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:authorization] = response
    redirect_to calendars_path
  end

  # def calendars
  #   begin
  #     client = Signet::OAuth2::Client.new(client_options)
  #     client.update!(session[:authorization])
  #     service = Google::Apis::CalendarV3::CalendarService.new
  #     service.authorization = client
  #     @calendar_list = service.list_calendar_lists
  #   rescue Google::Apis::AuthorizationError, Signet::AuthorizationError
  #     # FIXME: refresh_token 未実装
  #     redirect_to gcal_redirect_path
  #   end
  # end

  # def events
  #   begin
  #     client = Signet::OAuth2::Client.new(client_options)
  #     client.update!(session[:authorization])
  #     service = Google::Apis::CalendarV3::CalendarService.new
  #     service.authorization = client
  #     @event_list = service.list_events(params[:calendar_id])
  #   rescue Google::Apis::AuthorizationError, Signet::AuthorizationError
  #     # FIXME: refresh_token 未実装
  #     redirect_to gcal_redirect_path
  #   end
  # end

  # def new_event
  #   begin
  #     client = Signet::OAuth2::Client.new(client_options)
  #     client.update!(session[:authorization])
  #     service = Google::Apis::CalendarV3::CalendarService.new
  #     service.authorization = client
  #     today = Date.today
  #     event = Google::Apis::CalendarV3::Event.new({
  #       start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
  #       end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
  #       summary: 'New event!'
  #     })
  #     service.insert_event(params[:calendar_id], event)
  #     redirect_to events_url(calendar_id: params[:calendar_id])
  #   rescue Google::Apis::AuthorizationError, Signet::AuthorizationError
  #     # FIXME: refresh_token 未実装
  #     redirect_to gcal_redirect_path
  #   end
  # end

  private

  def client_options
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: gcal_callback_url
    }
  end
end
