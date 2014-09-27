class User
  include DataMapper::Resource

  property :id, Serial, key: true

  property :name, String
  property :email, String, format: :email_address
  property :stripe_card_id, String
  property :admin, Boolean

  property :created_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }
  property :updated_at, DateTime, required: true, default: lambda { |r, p| Time.now.to_datetime }

  has n, :orders

  before :save, :downcase_email


  def avatar_url
    hash = Digest::MD5.hexdigest(email)
    return "http://www.gravatar.com/avatar/#{hash}"
  end

  def reset_password
    # Email the user with a password reset link
    return "#{name} has been emailed at #{email} with a password reset link."
  end

  def issue_coupon(percent = 20)
    if percent.to_i == 20
      return "CPN_FJALDKF01Z1"
    else
      return "CPN_12838501ADN"
    end
  end

  def issue_free_shipping_coupon
    return "CPN_AJDOCKA81A0"
  end

  def downcase_email
    self.email = email.downcase
  end
end
