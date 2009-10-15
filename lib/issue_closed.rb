module IssueClosed
  module IssueStatus
    def self.closed
      find(:first, :conditions =>["is_closed=?", true], :order => 'position').id
    end
  end
 
  module IssueResolved
    def resolved?
      self.status.is_resolved?
    end
  end
end

class IssueStatus
  include IssueClosed::IssueStatus
end

class Issue
  include IssueResolved::Issue
  
  alias _after_save after_save
  
  def after_save
    _after_save
#    if self.resolved?
#      Delayed::Job.enqueue(QuestionJob.new(self))
#    end
  end
end