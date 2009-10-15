class AddIsResolvedToIssueStatus < ActiveRecord::Migration
  def self.up
    add_column :issue_statuses, :is_resolved, :boolean, :default => false
  end

  def self.down
    remove_column :issue_statuses, :is_resolved
  end
end