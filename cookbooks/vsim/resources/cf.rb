actions :takeover, :giveback, :mode, :service_enable
default_action :takeover

attribute :name, :kind_of => String, :required => true, :name_attribute => true
attribute :mode, :kind_of => String