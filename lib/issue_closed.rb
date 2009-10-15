module IssueClosed
  module IssueStatus
    def self.first_closed
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
end