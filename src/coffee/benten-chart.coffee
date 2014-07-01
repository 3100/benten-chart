window.onload = () ->
  main = new Vue
    el: '#main'
    data:
      title: 'Benten Chart'
      dateMs: Date.now()
      master: []
      menus: []
      orders: []
      user: null
    computed:
      ordersCount: ->
        @orders.length
      ym: ->
        date = new Date(@dateMs)
        m = date.getMonth()+1
        if m < 10
          m = '0' + m;
        "#{date.getFullYear()}年#{m}月"
      sums: ->
        Enumerable.From(@orders)
          .GroupBy("$.user", null,
            "{ user: $, count: $$.Count(), sum: $$.Sum('$.price')}")
          .OrderByDescending("$.count")
          .ToArray()
    methods:
      onToggleCheck: (e) ->
        @checkClicked()
        @updateOrders()
        @user = null
        @renderMenuChart()
      onSelectUser: (sum) ->
        @user = sum.user
        @renderUserChart()
      onGoNextMonth: () ->
        @updateMonth 1
      onGoPrevMonth: () ->
        @updateMonth -1
      # HACK 以降のメソッドをprivateにできないものか
      checkClicked: ->
        checked = $("input[id^=check]").toEnumerable()
          .Select("$.attr('checked') == 'checked'")
          .ToArray()
        for c, i in checked
          @menus[i].checked = c
      loadOrders: ->
        $.ajax
          type: 'GET'
          url: "/* @echo BENTEN_API_ORDERS_URL */"
          dataType: 'jsonp'
          jsonpCallback: 'callback'
          success: (json) =>
            @master = json
            @updateMenus()
            @updateOrders()
            @renderMenuChart()
          error: (res, status, err) ->
            alert status
      renderChart: ->
        renderer.renderChart this
      renderMenuChart: ->
        renderer.renderMenuChart @orders
      renderUserChart: ->
        renderer.renderUserChart @user, @orders
      updateMonth: (diffMonth) ->
        date = new Date(@dateMs)
        date.setMonth(date.getMonth() + diffMonth)
        @dateMs = date.getTime()
        @updateOrders()
        @renderChart()
      updateMenus: ->
        @menus = Enumerable.From(@master)
          .Distinct("$.menu")
          .OrderByDescending("$.price")
          .Select((x) ->
            name: x.menu
            price: x.price
            checked: true
          )
          .ToArray()
      updateOrders: ->
        checkedMenu = Enumerable.From(@menus)
          .Where("$.checked == true")
          .Select("$.name")
          .ToArray()
        date = new Date(@dateMs)
        @orders = Enumerable.From(@master)
          .Where((x) -> isSameMonth(date, new Date(x.date)))
          .Where((x) -> checkedMenu.indexOf(x.menu) >= 0)
          .ToArray()
    isSameMonth = (date1, date2) ->
      date1.getFullYear() == date2.getFullYear() &&
        date1.getMonth() == date2.getMonth()

  renderer = new Renderer()
  main.loadOrders()
