class AdminShipment < Upmin::Model
  # Singular methods like `action` and `attribute` don't overwrite existing values, they just append to the existing ones.
  attribute :status

  # Singular methods like `action` and `attribute` don't overwrite existing values, they just append to the existing ones.
  action :update_shipment
  action :pretend_to_work

  # Configuration
  items_per_page 20
  if defined?(DataMapper)
    sort_order :id.desc
  else
    sort_order 'id DESC'
  end


  def status
    return "TestStatus"

    # We are working to get Widgets added, that would make sharing ways to render data easier. For example, you might want to use a progress bar widget, or a shipment tracking widget.
    # return Upmin::Widget::ProgressBar.new(model.status, model.tracking_states)
  end

  def pretend_to_work(tps_reports)
    puts tps_reports
    return "102301401"
  end

end
