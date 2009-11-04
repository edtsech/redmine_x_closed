class AddDelayedJobIdToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :delayed_job_id, :integer 
  end

  def self.down
    remove_column :issues, :delayed_job_id
  end
end
