class SessionActivation < ActiveRecord::Base
  LIMIT = 1

  attr_accessible :session_id, :user_id
  
  def self.active?(id)
    id && where(session_id: id).exists?
  end

  def self.activate(id)
    activation = create!(session_id: id)
    purge_old
    activation
  end

  def self.deactivate(id)
    return unless id
    where(session_id: id).delete_all
  end

  # For some reason using #delete_all causes the order/offset to be ignored
  def self.purge_old
    order("created_at desc").offset(LIMIT).destroy_all
  end

  def self.exclusive(id)
    where("session_id != ?", id).delete_all
  end
end