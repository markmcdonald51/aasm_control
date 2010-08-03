module AASM_Controls::AasmAppStates
  def self.included(recipient)

    # so since were including this we might as well include this into the 
    # restful controller named the same as the recipient.
    # Should fix this to allow work options to pass in controller_name
    begin
      cntl_class = (recipient.class_name.pluralize + "Controller").constantize
      cntl_class.send :include, AASM_Controls::AasmController 
     
    end
    
    table_name = recipient.to_s.tableize
    
    recipient.class_eval do   
      include AASM
      
      aasm_column :state
      aasm_initial_state :pending
      aasm_state :pending #, :enter => :email_admin
      aasm_state :public
      aasm_state :suspended
      aasm_state :subscriber

      aasm_event :suspend do
        transitions :to => :suspended, 
          :from => [:pending, :public, :subscriber]
      end
      
      aasm_event :make_public do
        transitions :to => :public, 
          :from => [:pending, :suspended, :subscriber]
      end
      
      aasm_event :subscriber_only do
        transitions :to => :subscriber, 
          :from => [:pending, :public, :suspended]
      end
      
      named_scope :pending,    :conditions => "#{table_name}.state = 'pending'"
      named_scope :public,     :conditions => "#{table_name}.state = 'public'"
      named_scope :subscriber, :conditions => "#{table_name}.state = 'subscriber'"
      named_scope :suspended,  :conditions => "#{table_name}.state = 'suspended'"
      
    end
  end    
end 


=begin

      aasm_column :state
      aasm_initial_state :pending
      aasm_state :pending #, :enter => :email_admin
      aasm_state :active
      aasm_state :suspended
      aasm_state :privileged

      aasm_event :suspend do
        transitions :to => :suspended, 
          :from => [:pending, :active, :privileged]
      end
      
      aasm_event :activate do
        transitions :to => :active, 
          :from => [:pending, :suspended, :privileged]
      end
      
      aasm_event :privileged do
        transitions :to => :privileged, 
          :from => [:pending, :active, :suspended]
      end
      
      named_scope :pending,    :conditions => "#{table_name}.state = 'pending'"
      named_scope :active,     :conditions => "#{table_name}.state = 'active'"
      named_scope :privileged,    :conditions => "#{table_name}.state = 'privileged'"
      named_scope :suspended,  :conditions => "#{table_name}.state = 'suspended'"
=end            
