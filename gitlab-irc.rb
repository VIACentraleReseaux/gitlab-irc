require 'rubygems'
require 'sinatra'
require 'json'
require 'socket'

# IRC Config
IRC_HOST = 'irc.server.fr'
IRC_PORT = 6667
IRC_CHANNEL = '#channel'
# !! Channel must be with mode n disabled to allow extern messages !!
IRC_NICK = 'GitLabBot'
IRC_REALNAME = 'GitLabBot'

$socket = TCPSocket.open(IRC_HOST, IRC_PORT)
$socket.puts("NICK #{IRC_NICK}")
$socket.puts("USER #{IRC_NICK} #{IRC_NICK} #{IRC_NICK}  #{IRC_REALNAME}")

Thread.new do
        while line = $socket.gets
               line = line.split
               if line[0] == 'PING'
                        $socket.puts("PONG "+line[1] )
               end
        end
end

post '/commit' do
    json = JSON.parse(request.env["rack.input"].read)
    $socket.puts "NOTICE #{IRC_CHANNEL} :New Commits for '" + json['repository']['name'] + "'"

    json['commits'].each do |commit|
            $socket.puts "NOTICE #{IRC_CHANNEL} :by #{commit['author']['name']} | #{commit['message']} | #{commit['url']}"
    end
end

