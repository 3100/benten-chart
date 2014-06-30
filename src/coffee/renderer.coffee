class Renderer
  constructor: ->
    @menuPieChart = null
    @showsMenuChart = true

  renderChart: (main) ->
    if @showsMenuChart
      @renderMenuChart main.orders
    else
      @renderUserChart main.user, main.orders

  renderMenuChart: (orders) ->
    renderPieChart '注文の種類', sumMenus(orders)
    @showsMenuChart = true

  renderUserChart: (user, orders) ->
    renderPieChart "#{user}さんの注文", sumUser(user, orders)
    @showsMenuChart = false

  # private
  renderPieChart = (text, data) ->
    @menuPieChart = new Highcharts.Chart
      chart:
        renderTo: 'menuPieChart'
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
      title:
        text: text
      tooltip:
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      plotOptions:
        pie:
          allowPointSelect: true
          cursor: 'pointer'
          dataLabels:
            enabled:true
          showInLegend: true
      series:[
        type: 'pie'
        name: '比率'
        data: data
      ]

  # private staticみたいなのにしたい
  sumMenus = (orders) ->
    Enumerable.From(orders)
      .GroupBy("$.menu", null,
        "{ y: $$.Count(), name: $}")
      .OrderByDescending("$.y")
      .ToArray()

  sumUser = (user, orders) ->
    Enumerable.From(orders)
      .Where((x) -> x.user == user)
      .GroupBy("$.menu", null,
        "{ y: $$.Count(), name: $}")
      .OrderByDescending("$.y")
      .ToArray()
