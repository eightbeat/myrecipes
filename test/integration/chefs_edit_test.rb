require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(name: "taro", email: "taro@example.com",
            password: "password", password_confirmation: "password")
  end

  test "reject an invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {name: " ", email: " " } }
    assert_template "chefs/edit"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: {name: "taro1", email: "taro1@example.com" } }
    assert_redirected_to @chef #show template
    assert_not flash.empty?
    @chef.reload
    assert_match "taro1", @chef.name
    assert_match "taro1@example.com", @chef.email
  end
end
