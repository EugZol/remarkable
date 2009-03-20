require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'assign_to' do
  include FunctionalBuilder

  describe 'messages' do
    before(:each) do
      @matcher = assign_to(:user).with('jose').with_kind_of(String)
    end

    it 'should contain a description message' do
      @matcher = assign_to(:user)
      @matcher.description.should == 'assign user'

      @matcher.with(1..2)
      @matcher.description.should == 'assign user with 1..2'

      @matcher.with_kind_of(String)
      @matcher.description.should == 'assign user with 1..2 and with kind of String'
    end

    it 'should set assigned_value? message' do
      build_response { @user = nil }
      @matcher = assign_to(:user)
      @matcher.matches?(@controller)
      @matcher.failure_message.should == 'Expected action to assign user'
    end

    it 'should set is_kind_of? message' do
      build_response { @user = 1 }
      @matcher.matches?(@controller)
      @matcher.failure_message.should == 'Expected assign user to be kind of String, got a Fixnum'
    end

    it 'should set is_equal_value? message' do
      build_response { @user = 'joseph' }
      @matcher.matches?(@controller)
      @matcher.failure_message.should == 'Expected assign user to be equal to "jose", got "joseph"'
    end
  end

  describe 'matcher' do
    before(:each) { build_response { @user = 'jose' } }

    it { should assign_to(:user) }
    it { should assign_to(:user).with('jose') }
    it { should assign_to(:user).with_kind_of(String) }

    it { should_not assign_to(:post) }
    it { should_not assign_to(:user).with('joseph') }
    it { should_not assign_to(:user).with_kind_of(Fixnum) }

    it { should assign_to(:post).with(nil) }
    it { should assign_to(:user){ 'jose' } }
    it { should assign_to(:user, :with => proc{ 'jose' }) }

    it { should_not assign_to(:user).with(nil) }
    it { should_not assign_to(:user){ 'joseph' } }
    it { should_not assign_to(:user, :with => proc{ 'joseph' }) }
  end

  describe 'macro' do
    before(:each) { build_response { @user = 'jose' } }

    should_assign_to :user
    should_assign_to :user, :with => 'jose'
    should_assign_to :user, :with_kind_of => String

    should_not_assign_to :post
    should_not_assign_to :user, :with => 'joseph'
    should_not_assign_to :user, :with_kind_of => Fixnum

    should_assign_to :post, :with => nil
    should_assign_to(:user){ 'jose' }
    should_assign_to :user, :with => proc{ 'jose' }

    should_not_assign_to :user, :with => nil
    should_not_assign_to(:user){ 'joseph' }
    should_not_assign_to :user, :with => proc{ 'joseph' }
  end

  describe 'macro stubs' do
    expects :new, :on => String, :with => 'ola', :returns => 'ola'

    it 'should run expectations by default' do
      String.should_receive(:should_receive).with(:new).and_return(@mock=mock('chain'))
      @mock.should_receive(:with).with('ola').and_return(@mock)
      @mock.should_receive(:exactly).with(1).and_return(@mock)
      @mock.should_receive(:times).and_return(@mock)
      @mock.should_receive(:and_return).with('ola').and_return('ola')

      assign_to(:user).matches?(@controller)
    end

    it 'should run stubs' do
      String.should_receive(:stub!).with(:new).and_return(@mock=mock('chain'))
      @mock.should_receive(:and_return).with('ola').and_return('ola')

      assign_to(:user, :with_stubs => true).matches?(@controller)
    end

  end
end
