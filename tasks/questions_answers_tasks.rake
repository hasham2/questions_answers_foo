
require 'fileutils'

namespace :questions_answers do
   
  def generate_migration
    puts "==============================================================================="
    puts "ruby script/generate migration create_questions_answers_data"
    puts %x{ruby script/generate migration create_questions_answers_data}
    puts "================================DONE==========================================="
  end
  
  def migration_source_file         
    File.join(File.dirname(__FILE__), "../assets", "migrate", "create_questions_answers_data.rb")
  end

  def write_migration_content
    puts "==============================================================================="
    puts "copying code to newly generated migration"
    copy_to_path = File.join(RAILS_ROOT, "db", "migrate")
    migration_filename = 
      Dir.entries(copy_to_path).collect do |file|
        number, *name = file.split("_")
        file if name.join("_") == "create_questions_answers_data.rb"
      end.compact.first
    migration_file = File.join(copy_to_path, migration_filename)
    File.open(migration_file, "wb"){|f| f.write(File.read(migration_source_file))}
    puts "================================DONE==========================================="
  end
    
  def do_setup
    begin      
      generate_migration
      write_migration_content            
      puts "Please run the task 'rake db:migrate' to complete installation"      
    rescue StandardError => e
      p e
    end
  end
   
  desc "Creates data tables to hold Questions and Answers related data "
  task :install do     
     do_setup
  end
end
