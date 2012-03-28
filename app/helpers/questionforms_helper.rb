module QuestionformsHelper
  def draw_text_field(p_question_id, p_value_number,p_size,p_default_value, p_value)
     text_field_tag "value_"+p_value_number+"["+p_question_id.to_s+"][]",(p_value.try(:strip) or p_default_value) , :size=>p_size 
  end
  
  def draw_text_area(p_question_id, p_value_number,p_size,p_default_value, p_value)
    text_area_tag("value_"+p_value_number+"["+@question.id.to_s+"][]",(p_value.try(:strip) or p_default_value),:size => p_size) 
  end
  

end
