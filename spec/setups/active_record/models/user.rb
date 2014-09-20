# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  email          :string(255)
#  stripe_card_id :string(255)
#  admin          :boolean
#  created_at     :datetime
#  updated_at     :datetime
#
require 'digest/md5'

class User < ActiveRecord::Base
  has_many :orders

  validates :email, format: { with: /.+@.+(.).+/, message: "not a valid email" }

  before_save :downcase_email

  upmin_actions :reset_password, :issue_coupon, :issue_free_shipping_coupon

  def avatar_url
    hash = Digest::MD5.hexdigest(email)
    return "http://www.gravatar.com/avatar/#{hash}"
  end

  def reset_password
    # Email the user with a password reset link
    return "#{name} has been emailed at #{email} with a password reset link."
  end

  def issue_coupon(percent = 20)
    if percent == 20
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
