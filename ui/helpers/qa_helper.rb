module QaHelper
  
  def user_qa_attribute
     if (defined? VIEW_QA_USER_ATTRIBUTE)
      VIEW_QA_USER_ATTRIBUTE
     else
      "login" 
     end  
  end
  
  def intrest_link(intrest)
    link_txt = "<a href='/qa/answer_questions?cat=#{intrest.id}'>"
    unless intrest.parent_id.blank?
      parent_intrest = Intrest.find(intrest.parent_id)
      unless parent_intrest.parent_id.blank?
        root_intrest = Intrest.find(parent_intrest.parent_id)
        link_txt << root_intrest.name
        link_txt << ">"
      end
      link_txt << parent_intrest.name
      link_txt << ">"
    end
    link_txt << intrest.name
    link_txt << "</a>"
    return link_txt
  end
  
  def show_question_intrests(intrests)
    txt = ""
    i = 0    
    intrests.each do |int|
      if i > 0
        txt << " and "
        txt << intrest_link(int)
      else
        txt << intrest_link(int)
      end  
      i += 1
    end
    return txt
  end
  
end
