# AASMControls

module AASM_Controls 
  def self.included(base)  
    base.send :extend, ClassMethods 
  end  
  
  module ClassMethods 
    def acts_as_aasm_controls
      send :include, AASM_Controls::AasmAppStates 
    end  
  end  
  
end 

ActiveRecord::Base.send :include, AASM_Controls  
ActionView::Base.send :include, AASM_Controls::AASM_ControlsHelper
