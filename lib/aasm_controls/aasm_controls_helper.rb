module AASM_Controls::AASM_ControlsHelper  
  def aasm_state_links(obj)   
    html =  content_tag(:span, "Current #{obj.class.to_s.titleize} Access: ") + 
      content_tag(:span, "#{obj.state.to_s.titleize}", :id=>'current_state', :class => obj.state)
      
    html +=  content_tag(:p, "Available Actions")

    obj.aasm_events_for_current_state.each do |state|    
      action_state = link_to("#{state.to_s.titleize}&nbsp;", 
        instance_eval("update_state_#{obj.class.to_s.underscore}_path(obj,
           :state => state)"), :class=>'state_change_link')
        
      html += content_tag(:span, action_state + " ")    
    end

    html_retuned = content_tag(:div, html, :class => "state_change", :id=>obj.dom_id)
    html_retuned 
     
  end
end
