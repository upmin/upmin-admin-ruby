# == Schema Information
#
# Table name: shipments
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  price             :decimal(, )
#  carrier           :string(255)
#  tracking_code     :string(255)
#  delivered         :boolean
#  est_delivery_date :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class Shipment < ActiveRecord::Base
  belongs_to :order

  upmin_attributes :status, :price, :carrier, :est_delivery_date

  def status
    # Using a random value to pretend that we are looking up unique values.
    return tracking_states[rand(tracking_states.length)]
  end

  def tracking_states
    return [:preparing, :awaiting_pickup, :in_transit, :out_for_delivery, :delivered]
  end

  def cancel
    return true
  end

  def update_shipment(length, width, height, weight, perishable = false)
    # Do some work - this is a demo so no work is done.
    return "Shipment successfully updated with the following: length=#{length}, width=#{width}, height=#{height}, weight=#{weight}, perishable=#{perishable}"
  end

end
