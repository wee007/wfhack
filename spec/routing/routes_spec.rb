require 'spec_helper'

describe CustomerConsole::Application do
  context "routing" do
    it "routes click throughs" do
      expect(:get => "/bondijunction/products/100/redirection").to route_to(
        :controller => "products",
        :action => "redirection",
        :id => "100",
        :centre_id => "bondijunction"
      )
    end
  end
end