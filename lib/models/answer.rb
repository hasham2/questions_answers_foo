class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  
  validates_presence_of :body, :message => " cant be empty"  
  validates_format_of :links, :with => /^(((http|https|ftp):\/\/)?)(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i, :message => " url format is incorrect"
  
  cattr_reader :per_page
  @@per_page = 5
  
end
