# Generic class for querying the trading hours service
# Used on store map

class @TradingHours
  apiUrl: "/api/trading-hour/master/store_trading_hours/range.json"
  westfieldCentreId: westfield.centre.code

  constructor: ->
    @today = @getToday()

  getToday: =>
    d = new Date()
    curr_date = d.getDate()
    curr_month = d.getMonth() + 1
    curr_year = d.getFullYear()
    curr_date + "-" + curr_month + "-" + curr_year

  get: (params, callback)=>
    defaultParams =
      centre_id: @westfieldCentreId
      from: @today
      to: @today

    $.getJSON @apiUrl, $.extend({}, defaultParams, params), callback