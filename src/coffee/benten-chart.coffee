window.onload = () ->
  header = new Vue
    el: '#header'
    data:
      title: 'Benten Chart'
      dateMs: Date.now()
    computed:
      year: () ->
        new Date(@dateMs).getFullYear()
      month: () ->
        new Date(@dateMs).getMonth() + 1
      ym: () ->
        date = new Date(@dateMs)
        m = date.getMonth()+1
        if m < 10
          m = '0' + m;
        "#{date.getFullYear()}年#{m}月"
    methods:
      nextMonth: () ->
        date = new Date(@dateMs)
        date.setMonth(date.getMonth()+1)
        @dateMs = date.getTime()
        updateOrders(main)
        renderChart()
      prevMonth: () ->
        date = new Date(@dateMs)
        date.setMonth(date.getMonth()-1)
        @dateMs = date.getTime()
        updateOrders(main)
        renderChart()

  main = new Vue
    el: '#main'
    data:
      master: []
      menus: []
      orders: []
      user: null
    computed:
      ordersCount:
        $get: () ->
          @orders.length
      sums:
        $get: ()->
          Enumerable.From(@orders)
            .GroupBy("$.user",
              null,
              "{ user: $, count: $$.Count(), sum: $$.Sum('$.price')}")
            .OrderByDescending("$.count")
            .ToArray()
    methods:
      onToggleCheck: (e) ->
        checkClicked(main)
        renderMenuChart()
        @user = null
      onSelectUser: (sum) ->
        @user = sum.user
        renderUserChart @user

  menuPieChart = null
  showsMenuChart = true

  renderChart = ->
    if showsMenuChart
      renderMenuChart()
    else
      renderUserChart(main.user)

  renderMenuChart = ->
    renderPieChart '注文の種類', sumMenus(main.orders)
    showsMenuChart = true

  renderUserChart = (user) ->
    renderPieChart "#{user}さんの注文", sumUser(user, main.orders)
    showsMenuChart = false

  renderPieChart = (text, data) ->
    #$('#menuPieChart').highcharts
    menuPieChart = new Highcharts.Chart
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

  isSameMonth = (date1, date2) ->
    date1.getFullYear() == date2.getFullYear() &&
      date1.getMonth() == date2.getMonth()

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

  checkClicked = (demo) ->
    checked = $("input[id^=check]").toEnumerable()
      .Select("$.attr('checked') == 'checked'")
      .ToArray()
    for c, i in checked
      demo.menus[i].checked = c
    updateOrders demo

  updateOrders = (demo) ->
    checkedMenu = Enumerable.From(demo.menus)
      .Where("$.checked == true")
      .Select("$.name")
      .ToArray()
    date = new Date(header.dateMs)
    demo.orders = Enumerable.From(demo.master)
      .Where((x) -> isSameMonth(date, new Date(x.date)))
      .Where((x) -> checkedMenu.indexOf(x.menu) >= 0)
      .ToArray()

  calcSums = (orders) ->
    Enumerable.From(orders)
      .GroupBy("$.user",
        null,
        "{ user: $, count: $$.Count(), sum: $$.Sum('$.price')}")
      .OrderByDescending("$.count")
      .ToArray()

  getMenu = (orders) ->
    Enumerable.From(orders)
      .Distinct("$.menu")
      .OrderByDescending("$.price")
      .Select((x) ->
        name: x.menu
        price: x.price
        checked: true
      )
      .ToArray()

  # for debug in early days
  loadOrdersDemo = (demo) ->
    $.getJSON "/orders.json", (json) ->
      demo.master = json
      demo.orders = json
      demo.menus = getMenu json
      renderMenuChart demo.orders

  loadOrders = (main) ->
    $.ajax
      type: 'GET'
      url: "/* @echo BENTEN_API_ORDERS_URL */"
      dataType: 'jsonp'
      jsonpCallback: 'callback'
      success: (json) ->
        main.master = json
        main.orders = json
        main.menus = getMenu json
        renderMenuChart main.orders
      error: (res, status, err) ->
        alert status

  loadOrders(main)
