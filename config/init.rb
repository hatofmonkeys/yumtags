require 'rubygems'
require 'yaml'
require 'mongo_mapper'
require 'log_buddy'
require 'sinatra'

# Else read the local configuration
@config = YAML.load_file(File.join(File.dirname(__FILE__),"database.yaml"))
  
@environment = @config["environment"]

@db_host = @config[@environment]["host"]
@db_port = @config[@environment]["port"]
@db_name = @config[@environment]["database"]
@db_log = @config[@environment]["logfile"]

# Configure the environment badly

$stomp_server = "localhost"
$stomp_port = "61613"
$stomp_create_queue = "/queue/newtags"

# Repository directory
$repo_dir = File.expand_path('../../public/',__FILE__)
FileUtils.mkdir_p($repo_dir) unless File.exist?($repo_dir)

# Logger code: https://github.com/jnunemaker/mongomapper/blob/master/test/test_helper.rb
log_dir = File.expand_path('../../log/', __FILE__)
FileUtils.mkdir_p(log_dir) unless File.exist?(log_dir)
logger = Logger.new(log_dir + "/" + @db_log)

LogBuddy.init(:logger => logger)
MongoMapper.connection = Mongo::Connection.new(@db_host, @db_port, :logger => logger)
MongoMapper.database = @db_name

MongoMapper.connection.connect
