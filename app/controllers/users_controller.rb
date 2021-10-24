class UsersController < ApplicationController
  log_action only: :create

  def create
    if resource.save
      @status = :success
      render :create
    else
      @status = :error
      render :new
    end
  end

  private

  attr_reader :resource

  def collection
    @collection ||= contest.users.order :id
  end

  def resource_params
    params.require(:user).permit \
      :name,
      :email,
      :region,
      :city,
      :institution,
      :contest_site,
      :grade,
      :registration_secret,
      registration_ips: []
  end

  def initialize_resource
    @resource = contest.users.build
  end

  def build_resource
    @resource = contest.users.build resource_params
  end

  def logger_values
    [
      ['reg secret', params.dig(:user, :registration_secret)],
      ['ip', params.dig(:user, :registration_ips)],
      ['name', params.dig(:user, :name)],
      ['usr secret', resource.secret],
      ['errors', resource.errors],
    ]
  end

  def handle_not_authorized
    redirect_to action: :new
  end
end
