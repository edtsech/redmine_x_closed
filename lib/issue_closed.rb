module IssueClosed
 module IssueStatus
   def self.first_closed
     find(:first, :conditions =>["is_closed=?", true], :order => 'position').id
   end
 end
end

class IssueStatus
  include IssueClosed::IssueStatus
end