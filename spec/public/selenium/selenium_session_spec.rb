require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require "webrat/selenium/silence_stream"
require "webrat/selenium/selenium_session"

describe Webrat::SeleniumSession do
  
  before :each do
    Webrat.configuration.mode = :selenium
    @selenium = Webrat::SeleniumSession.new()
  end
  
  it "should provide a list yieldable exceptions without spec if spec isn't defined" do
    @selenium.should_receive(:lib_defined?).with(::Spec::Expectations::ExpectationNotMetError).and_return(false)
    @selenium.yieldable_exceptions.should == [::Selenium::CommandError, Webrat::WebratError]
  end
  
  it "should provide a list yieldable exceptions with rspec" do
    @selenium.should_receive(:lib_defined?).with(::Spec::Expectations::ExpectationNotMetError).and_return(true)
    @selenium.yieldable_exceptions.should == [::Spec::Expectations::ExpectationNotMetError, ::Selenium::CommandError, Webrat::WebratError]
  end
  
  it "should handle yieldable exceptions in the wait_for" do
    begin
      @selenium.wait_for(:timeout => 0.25) do
        raise Webrat::WebratError.new
      end
      fail("didn't throw")
    rescue Webrat::TimeoutError
    end
  end
  
end
