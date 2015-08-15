actions :setup_iscsi, :setup_mediator_disk
default_action :setup_iscsi

attribute :name, :kind_of => String, :required => true, :name_attribute => true
