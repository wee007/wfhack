class StoresController < ApplicationController

  def index
    @stores = Store.get
  end

end
