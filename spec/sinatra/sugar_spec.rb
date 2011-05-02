require File.expand_path(__FILE__ + "/../../spec_helper.rb")

describe Sinatra::Sugar do
  before { app :Sugar }
  it_should_behave_like 'sinatra'

  describe "register" do
    it "registers an extension only once" do
      extension = Module.new
      extension.should_receive(:registered).once.with(app)
      10.times { app.register extension }
    end
  end
end