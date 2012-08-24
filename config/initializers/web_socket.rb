require 'em-websocket'

class ActionController::Base
  
  protected
  
  def web_socket_start
    Thread.new do
      EventMachine.run {
        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
          
          ws.onopen do
            @ws = ws
            ws_onopen
          end
          
          ws.onmessage do |message|
            @message = message
            ws_onmessage
          end
          
          ws.onclose do
            ws_onclose
            @ws, @message = []
          end
        end
      }
    end
  end
  
  def ws_onopen
  end
  
  def ws_onmessage
  end
  
  def ws_onclose
  end
end
