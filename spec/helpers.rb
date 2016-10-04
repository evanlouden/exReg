module Helpers
  def sign_in_as(user)
    visit unauthenticated_root_path
    click_link "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
end
