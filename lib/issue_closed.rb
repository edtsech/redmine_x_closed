module IssueClosed
  class DelayedClose < Struct.new(:issue_id)
    def perform
      issue = Issue.find issue_id
      if issue.status.state == false
        issue.status = IssueStatus.find_by_state true
        issue.save
      end
    end    
  end
      
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
            status_before_update != @issue.status
            
            to_destroy_id = @issue.delayed_job_id
            delayed_job_id = nil
            
            if @issue.status.state == false
              job = Delayed::Job.enqueue DelayedClose.new(@issue.id), 0, 7.days.from_now
              delayed_job_id = job.id
            end
              
            @issue.delayed_job_id = delayed_job_id            
            @issue.save            
            Delayed::Job.destroy to_destroy_id unless to_destroy_id == nil
            
          end
        end
      end
    end    
  end
end

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
