require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(name: "taro", email: "taro@example.com",
            password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(name: "jiro", email: "jiro@example.com",
            password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(name: "jiro1", email: "jiro1@example.com",
            password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {name: " ", email: " " } }
    assert_template "chefs/edit"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {name: "taro1", email: "taro1@example.com" } }
    assert_redirected_to @chef #show template
    assert_not flash.empty?
    @chef.reload
    assert_match "taro1", @chef.name
    assert_match "taro1@example.com", @chef.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {name: "taro1", email: "taro1@example.com" } }
    assert_redirected_to @chef #show template
    assert_not flash.empty?
    @chef.reload
    assert_match "taro1", @chef.name
    assert_match "taro1@example.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joe"
    updated_email = "joe@example.com"
    patch chef_path(@chef), params: { chef: { name: updated_name,
                                  email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "taro", @chef.name
    assert_match "taro@example.com", @chef.email
  end
end
