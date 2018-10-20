class SetCurrentMembershipsConfirmed < ActiveRecord::Migration[5.2]
  def change
    memberships = Membership.all

    memberships.each do |m|
      m.confirmed = true
      m.save
    end
  end
end
