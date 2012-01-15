#!/usr/bin/ruby
require 'rubygems'
require 'eventmachine'
require File.join(File.dirname(__FILE__),'../../config/init.rb')
require File.join(File.dirname(__FILE__),'../models/tagModel')

 module YumtagsStompClient
   include EM::Protocols::Stomp

   def connection_completed
     connect
     subscribe $stomp_create_queue
   end

   def receive_msg msg
     if msg.command == "MESSAGE"
       #Create the repo
       #TODO : some deferring cleverness here
       t = TagModel.where(:tag => msg.body).first
       t.createrepo
     end
   end

   def unbind
     #We're only here to connect, so wait, and try again!
     sleep 5
     self.reconnect($stomp_server, $stomp_port.to_i)
   end

 end

EM.run{
  EM.connect($stomp_server, $stomp_port, YumtagsStompClient)
}