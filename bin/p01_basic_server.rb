require 'webrick'


server = WEBrick::HTTPServer.new(:Port => 3000) 

trap('INT') do 
	server.shutdown
end

server.mount_proc("/") do |request, response|
	path = request.path 
	response.content_type = "text/text"
	response.body = "#{path}"  
end


server.start 
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
