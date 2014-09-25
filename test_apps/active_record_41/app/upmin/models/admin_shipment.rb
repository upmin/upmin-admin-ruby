class AdminShipment < Upmin::AdminModel

  attribute :status
  actions :update_shipment

  def status
    return "TestStatus"
    # return Upmin::Widget::ProgressBar.new(model.status, model.tracking_states)
  end

end
