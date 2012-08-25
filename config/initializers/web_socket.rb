require 'em-websocket'

class ActionController::Base
  
  WS_OPTIONS = { :host => "0.0.0.0", :port => 8888 }
  
  protected
  
  def web_socket_start
    unless $thread && $thread.alive?
      $thread = Thread.new do
        EventMachine.run {
          EventMachine::WebSocket.start(WS_OPTIONS) do |ws_client|
            
            ws_client.onopen do
              @ws_client = ws_client
              ws_onopen
            end
            
            ws_client.onmessage do |ws_message|
              @ws_message = ws_message
              ws_onmessage
            end
            
            ws_client.onclose do
              ws_onclose
              @ws_client, @ws_message, @ws_error = []
            end
            
            ws_client.onerror do |ws_error|
              @ws_error = ws_error
              ws_onerror
            end
          end
        }
      end
    end
  end
  
  def web_socket_stop
    if $thread && $thread.alive?
      EventMachine::WebSocket.stop
      $thread = false
    end
  end
  
  def ws_onopen
  end
  
  def ws_onmessage
  end
  
  def ws_onclose
  end
  
  def ws_onerror
  end
  
  def ws_response(response)
    ws_response_base = {
      :status => :success,
      :action => '',
      :message => '',
      :data => ''
    }
    ws_response_base.merge(response).to_json
  end
end
