require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(name: "taro", email: "taro@example.com",
            password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(name: "jiro", email: "jiro@example.com",
            password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(name: "jiro1", email: "jiro1@example.com",
            password: "password", password_confirmation: "password", admin: true)
  end

  test "should get  listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.name.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.name.capitalize
  end

  test "should delete chef" do
    sign_in_as(@admin_user, "password")
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end

  test "associated recipes should be destroyed" do
    @chef.save
    @chef.recipes.create!(name: "test", description: "test description")
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end
end
