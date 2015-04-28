require 'rubygems'
require 'sinatra'
require 'json'
require 'socket'
require 'yaml'

config = YAML.load(File.read(File.expand_path("../config.yml", __FILE__)))

# IRC Config
IRC_HOST = config[:IRC][:Host]
IRC_PORT = config[:IRC][:Port]
IRC_CHANNEL = config[:IRC][:Channel]
# !! Channel must be with mode n disabled to allow extern messages !!
IRC_NICK = config[:IRC][:Nick]
IRC_REALNAME = config[:IRC][:RealName]

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
  $socket.puts "NOTICE #{IRC_CHANNEL} : #{json['total_commits_count']} new Commits for \x0306#{json['repository']['name']}\x0315  by #{2.chr} #{json['user_name']} #{15.chr} : #{json['repository']['homepage']}/compare/#{json['before'].slice(0,7)}...#{json['after'].slice(0,7)}"
  i = 0
  json['commits'].each do |commit|
    $socket.puts "NOTICE #{IRC_CHANNEL} :by #{2.chr + commit['author']['name'] + 15.chr } | \x0309#{commit['message']}\x0315 | #{json['repository']['homepage'] + "/commit/" + commit['id'].slice(0,7)}"
    i += 1
    if i == 3
      break
    end
  end
  if i < json['commits'].length
    $socket.puts "NOTICE #{IRC_CHANNEL} : ... And many others."
  end
end

