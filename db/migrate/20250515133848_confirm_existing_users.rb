class ConfirmExistingUsers < ActiveRecord::Migration[8.0]
  def up
    # Mark all existing users as confirmed
    User.update_all(confirmed_at: Time.current)
  end

  def down
    # reverse nahi hogi
  end
end
