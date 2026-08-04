# frozen_string_literal: true

require "socket"
require "json"

# A minimal in-process SearXNG stand-in for integration tests. Answers the
# tool's `GET /search?q=...&format=json` request with canned JSON results, so
# call-level tests never touch the network.
class FakeSearxng
  attr_reader :port, :requests

  def initialize(results: [])
    @results = results
    @requests = []
    @server = TCPServer.new("127.0.0.1", 0)
    @port = @server.addr[1]
    @thread = Thread.new { serve }
  end

  def url
    "http://127.0.0.1:#{@port}"
  end

  def stop
    @server.close
    @thread.kill
  rescue IOError, Errno::EBADF
  end

  private

  def serve
    loop do
      client = @server.accept
      handle(client)
    end
  rescue IOError, Errno::EBADF, Errno::ECONNRESET
    # server closed
  end

  def handle(client)
    request_line = client.gets
    return client.close if request_line.nil?

    @requests << request_line.strip
    # Consume headers up to the blank line.
    while (line = client.gets)
      break if line == "\r\n" || line == "\n"
    end

    body = JSON.generate(results: @results)
    client.write(
      "HTTP/1.1 200 OK\r\n" \
      "Content-Type: application/json\r\n" \
      "Content-Length: #{body.bytesize}\r\n" \
      "Connection: close\r\n" \
      "\r\n" \
      "#{body}"
    )
    client.close
  rescue IOError, Errno::EPIPE, Errno::ECONNRESET
    client.close rescue nil
  end
end
