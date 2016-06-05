class Faq < ActiveRecord::Base
  belongs_to :faq_group

  validates_presence_of :faq_group_id, :question, :answer
end
