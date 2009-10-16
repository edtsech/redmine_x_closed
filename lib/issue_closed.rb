module IssueClosed
  #module IssueStatus
  #  def self.closed
  #    find(:first, :conditions =>["is_closed=?", true], :order => 'position').id
  #  end
  #end
 
  #module IssueResolved
  #  def resolved?
  #    self.status.is_resolved?
  #  end
  #end
  
  module IssueStatusesController
    module InstanceMethods
    end
    
    def self.included base
      base.send :include, InstanceMethods
      base.class_eval do
        def index
          list
          render :template => 'issue_statuses/issue_closed_list' #'list' unless request.xhr?
        end
      end
   end
  end
end

#class IssueStatus
#  include IssueClosed::IssueStatus
#end

#class Issue
#  include IssueResolved::Issue
  
#  alias _after_save after_save
  
#  def after_save
#    _after_save
#    if self.resolved?  
#      Delayed::Job.enqueue(QuestionJob.new(self))
#    end
#  end
#end

require 'dispatcher'
  Dispatcher.to_prepare do 
    begin
      require_dependency 'application'
    rescue LoadError
      require_dependency 'application_controller'
    end

  IssueStatusesController.send :include, IssueClosed::IssueStatusesController
end
