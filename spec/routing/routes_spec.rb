require 'spec_helper'

describe CustomerConsole::Application do
  context "routing" do
    it "routes product click throughs" do
      expect(:get => "/products/100/redirection").to route_to(
        :controller => "products",
        :action => "redirection",
        :id => "100"
      )
    end

    it "routes centre scoped product click throughs" do
      expect(:get => "/bondijunction/products/100/redirection").to route_to(
        :controller => "products",
        :action => "redirection",
        :id => "100",
        :centre_id => "bondijunction"
      )
    end
  end
end