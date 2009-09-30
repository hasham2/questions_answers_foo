# Include hook code here
  
  def class_exists?(name)
    begin
      true if Kernel.const_get(name)
    rescue NameError
      false
    end
  end
  
  puts "WARNING: User model does not exist. Questions and Answers functionality will not work" unless class_exists? "User"
  
  require File.dirname(__FILE__) + '/lib/questions_answers'  

  controller_path = File.join(File.dirname(__FILE__), 'ui', 'controllers')
  helper_path = File.join(File.dirname(__FILE__), 'ui', 'helpers')
  $LOAD_PATH << controller_path
  $LOAD_PATH << helper_path
    
  # For Rails 2.2 
  if defined? ActiveSupport::Dependencies
    ActiveSupport::Dependencies.load_paths << controller_path
    ActiveSupport::Dependencies.load_paths << helper_path
  else
    Dependencies.load_paths << controller_path
    Dependencies.load_paths << helper_path
  end    
  config.controller_paths << controller_path
  require 'questions_answers_routing'