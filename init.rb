require 'redmine'
require File.dirname(__FILE__) + '/lib/issue_closed.rb'

Redmine::Plugin.register :redmine_issue_closed do
  name 'Redmine Issue Closed plugin'
  author 'Equelli'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end
