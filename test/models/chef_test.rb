require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(name: "taro", email: "taro@example.com")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.name = " "
    assert_not @chef.valid?
  end

  test "name should be less than 30 characters" do
    @chef.name = "a"*31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should not be too long" do
    @chef.email = "a" * 245 + "@example.com"
    assert_not @chef.valid?
  end

  test "email should be accept correct format" do
    valid_emails = %w[user@example.com first@yahoo.co]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "should reject invalid addresses" do
    invalid_emails = %w[taro@example taro@example,com]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "%w{invalids.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be case before hitting db" do
    mixed_email = "taro@Example.com"
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
end
