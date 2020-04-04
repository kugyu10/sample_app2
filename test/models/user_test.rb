require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "qwertyui9", password_confirmation: "qwertyui9"
    )

  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end


  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com" #length 256
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do

    valid_addresses = %w[
      user@example.com
      User@foo.COM
      A_USE-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do

    valid_addresses = %w[
      user@example,com
      User_at_foo.COM
      user.name@example.
      foo@bar_baz.jp
      foo@bar+baz.com
      double@dot..com
    ]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addressses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAmPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " " *8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" *7
    assert_not @user.valid?
  end


end
