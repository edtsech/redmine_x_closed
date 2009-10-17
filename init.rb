require 'redmine'
require File.dirname(__FILE__) + '/lib/issue_closed.rb'

Redmine::Plugin.register :redmine_issue_closed do
  name 'Redmine Issue Closed plugin'
  author 'Equelli'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  #permission :issue_closed, { :example => :say_hello }
  
  menu :project_menu, :issue_closed, { :controller => 'example', :action => 'say_hello' }, :caption => 'Sample'
  
  project_module "issue_closed" do
    permission :run_autoclose, { :issue => :update }
  end
end