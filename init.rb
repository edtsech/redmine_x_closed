require 'redmine'
require 'rubygems'
require 'delayed_job'
require File.dirname(__FILE__) + '/lib/issue_closed.rb'

Redmine::Plugin.register :redmine_issue_closed do
  name 'Redmine Issue Closed plugin'
  author 'Equelli'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  project_module "issue_closed" do
    permission :run_autoclose, { :issue => :update }
  end
end