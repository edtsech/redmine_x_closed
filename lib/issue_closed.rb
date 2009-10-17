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
    def self.included base
      base.class_eval do
        
        alias _list list

        def index
          list
        end
        
        def list
          collect_issue_statuses
          render :template => 'issue_statuses/issue_closed_list'
        end
        
        def update_issue_closed
          (statuses = IssueStatus.all).each do |status|
            case status.id
            when params[:closed].to_i
              status.state = true
            when params[:resolved].to_i
              status.state = false
            else
              status.state = nil
            end
            status.save!
          end
          redirect_to :action => :list
        end
      protected
        def collect_issue_statuses
          @issue_status_pages, @issue_statuses = paginate :issue_statuses, :per_page => 25, :order => "position"
        end
      end
   end
  end

  module IssuesController 
    def self.included base
      base.class_eval do
        alias _edit edit
        
        def edit
          status_before_update = @issue.status
          _edit
          if request.post? and \
            not (@issue.project.enabled_modules.detect { |enabled_module| enabled_module.name == 
              'issue_closed' }) == nil and \
            status_before_update != @issue.status and \
            @issue.status.state == false
            
            ###
          end
        end
      end
    end    
  end
  
  module Issue
    base.class_eval do
      
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
  IssuesController.send :include, IssueClosed::IssuesController
end
