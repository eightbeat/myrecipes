require 'test_helper'

class ChefsTestTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(name: "taro", email: "taro@example.com",
            password: "password", password_confirmation: "password")
    @recipe = Recipe.create!(name: "vegetable soute", description: "great vegetable soute, add vegetable and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken soute", description: "great chicken dish")
    @recipe2.save
  end

  test "should get chefs show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.name, response.body
  end
end
