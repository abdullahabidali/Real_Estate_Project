require "test_helper"

class AbilityTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @property = properties(:one)
    @other_property = properties(:two)
    @favorite = favorites(:one)
    @other_favorite = favorites(:two)
    @message = messages(:one)
    @other_message = messages(:two)
  end

  test "guest user can only read properties" do
    ability = Ability.new(nil)
    assert ability.can?(:read, Property)
    assert ability.cannot?(:manage, Property)
    assert ability.cannot?(:create, Property)
    assert ability.cannot?(:update, Property)
    assert ability.cannot?(:destroy, Property)
  end

  test "logged-in user can manage their own properties" do
    ability = Ability.new(@user)
    assert ability.can?(:manage, @property)
    assert ability.cannot?(:manage, @other_property)
  end

  test "logged-in user can manage their own favorites" do
    ability = Ability.new(@user)
    assert ability.can?(:manage, @favorite)
    assert ability.cannot?(:manage, @other_favorite)
  end

  test "logged-in user can manage their own messages" do
    ability = Ability.new(@user)
    assert ability.can?(:manage, @message)
    assert ability.cannot?(:manage, @other_message)
  end
end 