class AddStateToIssueStatus < ActiveRecord::Migration  
  
  def self.up
    add_column :issue_statuses, :state, :boolean
    #include GLoc
    #include Redmine::DefaultData::Loader
    #puts l(:default_issue_status_resolved)
    #IssueStatus.find_by_name(l(:default_issue_status_resolved)).toggle_attribute(:is_resolved)
  end

  def self.down
    remove_column :issue_statuses, :state
  end
end