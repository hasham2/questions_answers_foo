class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user
  has_and_belongs_to_many :intrests
  
  validates_presence_of :title, :message => " cant be empty"
  
  cattr_reader :per_page
  @@per_page = 5
  
end
