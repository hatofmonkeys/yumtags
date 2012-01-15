require 'sinatra/base'
require 'erb'
require 'sinatra'
require 'uuidtools'
require 'stomp'
require File.join(File.dirname(__FILE__),'models/tagModel')

class Yumtags < Sinatra::Base
    
  #expose the repo
  set :static, true
  set :public_folder, $repo_dir

  helpers do
    def create
      tag = UUIDTools::UUID.timestamp_create().to_s
      t = TagModel.new(
        :tag => tag,
        #files in the repo dir that are have .rpm in the name
        :files => Dir.entries($repo_dir).inject([]) { |result, element| File.file?("#{$repo_dir}/#{element}") && element.include?(".rpm") ? result.push(element) : result }
        )

      #TODO: Give this the good transactions, not the bad transactions
      begin
          t.save
        rescue
          @message ||= "Unable to save into Database"
      end

      unless @message
        begin
        Timeout::timeout(4) do
          stomp = Stomp::Client.new("", "", $stomp_server, $stomp_port)
          stomp.publish($stomp_create_queue, tag)
          stomp.close
        end
        rescue Timeout::Error
           @message = "Couldn't add the tag to the creation queue"
        end
      end

      return tag

    end

  end

  #TODO: Sortout out this RESTless mess
  get '/' do
      erb :home
  end
  
  post '/', :provides => :html do
    newtag = create()
    @message ||= "Tag created: #{newtag}"
    erb :home
  end

  post '/', :provides => :json do
    content = {:tag => create()}.to_json
    @message || [202, {'Content-Type' => 'application/json'}, content ]
  end

  #If the client hasn't negotiated, throw them some htmls
  post '/', do
    newtag = create()
    @message ||= "Tag created: #{newtag}"
    erb :home
  end

  #redirect the rpms in tags to the base repo
  get '/*/*.rpm' do
    redirect "/#{params[:splat][1]}.rpm"
  end

  #GET the tag's json
  get %r{/([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})$} do
    t = TagModel.where(:tag => params[:captures].first).first()
    t.to_json
  end


  #hand out the tagged repodata
  # eg. http://localhost:4000/7c317608-29a9-11e1-b7e2-0800277424a0/repodata/primary.xml.gz
  get %r{/([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})/repodata/([a-z]+)\..*} do
    t = TagModel.where(:tag => params[:captures].first).first()
    file = eval "t.#{params[:captures][1]}"
    [200, {'Content-Type' => file.content_type}, [file.read]]
  end

end