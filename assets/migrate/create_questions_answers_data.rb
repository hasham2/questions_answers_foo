require 'csv'

class CreateQuestionsAnswersData < ActiveRecord::Migration
def self.up
    create_table :questions do |t|
      t.integer :user_id
      t.string :title
      t.text :detail
      t.boolean :is_public
      t.boolean :is_closed
      t.timestamps
    end
    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.text :body
      t.string :links
      t.timestamps
    end
    create_table :intrests do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps
    end    
    create_table :intrests_questions, {:id => false} do |t|
      t.integer :intrest_id
      t.integer :question_id
    end
    datafile_path = File.join(RAILS_ROOT, "vendor", "plugins", "questions_answers", "assets")
    data_file = File.join(datafile_path, 'categories.csv')
    parsed_file = CSV::Reader.parse(File.read(data_file))
    
    #insert top level cats
    parsed_file.each do |row|       
        if row[2] == nil && row[1] == nil
            intr = Intrest.new(:name => row[0])
            intr.save
        end
    end
    
    #insert second level cats
    parsed_file.each do |row|
        if row[2] == nil 
            if row[1] != nil
                parent = Intrest.find_by_name(row[0])
                Intrest.create(:name => row[1], :parent_id => parent.id) if parent
            end            
        end
    end
    GC.start
    
    #insert third level cats
    parsed_file.each do |row|
        if row[2] != nil
            parent = Intrest.find_by_name(row[1])
            Intrest.create(:name => row[2], :parent_id => parent.id) if parent
        end                   
    end
    GC.start    
  end

  def self.down
    drop_table :intrests_questions
    drop_table :intrests
    drop_table :answers
    drop_table :questions
  end
end  