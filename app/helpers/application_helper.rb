module ApplicationHelper
  def remove_auth_control_nav
    @no_auth_controls = true
  end

  def no_auth_controls?
    @no_auth_controls
  end
end
