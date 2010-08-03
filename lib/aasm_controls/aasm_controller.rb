module AASM_Controls::AasmController 
  def self.included(recipient)
    recipient.class_eval do            
      def update_state
        klass = self.class.to_s.gsub(/Controller$/, '').singularize.constantize        
        state = params[:state]
        @resource = klass.find(params[:id])
        if klass.aasm_events.keys.include?(state.to_sym)
          @resource.send("#{state}!")           
        end 
        render '/shared/update_state'        
      end
    end
  end      
end
