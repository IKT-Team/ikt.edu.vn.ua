class User < ApplicationRecord
  attr_accessor :registration_secret

  validates :name, :email, :city, :institution, :contest_site, :grade, presence: true
  validates :name, uniqueness: { scope: :contest }
  validate :registration_secret_must_be_valid, on: :create

  belongs_to :contest, inverse_of: :users
  has_many :solutions, inverse_of: :user
  has_many :results, inverse_of: :user

  before_create :assign_secret

  private

  def registration_secret_must_be_valid
    unless ActiveSupport::SecurityUtils.secure_compare registration_secret, contest.registration_secret
      errors.add :registration_secret, :invalid
    end
  end

  def assign_secret
    self.secret = [
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      format('%04d', SecureRandom.random_number(10_000)),
    ].join
  end
end
