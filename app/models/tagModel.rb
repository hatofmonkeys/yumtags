require 'rubygems'
require 'mongo_mapper'
require 'joint'

class TagModel
  include MongoMapper::Document
  plugin Joint

  key :tag, String, :required => true
  key :status, String, :default => "pending"
  #files in the repo dir that are have .rpm in the name
  key :files, Array, :default => lambda { Dir.entries($repo_dir).inject([]) { |result, element| File.file?("#{$repo_dir}/#{element}") && element.include?(".rpm") ? result.push(element) : result } }
  attachment :filelists
  attachment :other
  attachment :primary
  attachment :repomd

  def createrepo()
    #Create the list of files for the repo data
    rpmlist = File.open("#{$repo_dir}/rpmlist","w")
    self.files.each do |file|
      rpmlist.puts(file)
    end

    #create the repo
    system("createrepo -i #{$repo_dir}/rpmlist #{$repo_dir}")
    rpmlist.close

    files = %w{filelists.xml.gz other.xml.gz primary.xml.gz repomd.xml}
    handles = []

    #populate the model
    files.each do |file|
      fh = File.open("#{$repo_dir}/repodata/#{file}")
      #TODO: make this less waft
      eval("self.#{file.split(".")[0]} = fh")
      handles.push fh
    end

    self.status = "ready"

    #save the model
    begin
      self.save
    rescue
      @message = "Unable to save into Database"
    end

    handles.each do |handle|
      handle.close
    end

  end
end