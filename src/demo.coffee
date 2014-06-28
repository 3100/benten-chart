window.onload = () ->
  demo = new Vue
    el: '#demo'
    data:
      title: 'Benten Chart'

  demo2 = new Vue
    el: '#demo2'
    data:
      master: []
      menus: []
      orders: []
      #sums: []
    computed:
      ordersCount:
        $get: () ->
          this.orders.length
      sums:
        $get: ()->
          #calcSums(this.orders)
          Enumerable.From(this.orders)
            .GroupBy("$.user",
              null,
              "{ user: $, count: $$.Count(), sum: $$.Sum('$.price')}")
            .OrderByDescending("$.count")
            .ToArray()
    methods:
      onToggleCheck: (e) ->
        checkClicked(demo2)

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
    demo.orders = Enumerable.From(demo.master)
      .Where((x) -> checkedMenu.indexOf(x.menu) >= 0)
      .ToArray()

  calcSums = (orders) ->
    Enumerable.From(orders)
      .GroupBy("$.user",
        null,
        "{ user: $, count: $$.Count(), sum: $$.Sum('$.price')}")
      .OrderByDescending("$.count")
      .ToArray()

  getMenu = (json) ->
    Enumerable.From(json)
      .Distinct("$.menu")
      .OrderByDescending("$.price")
      .Select((x) ->
        name: x.menu
        price: x.price
        checked: true
      )
      .ToArray()

  loadOrdersDemo = (demo) ->
    $.getJSON "/orders.json", (json) ->
      demo.master = json
      demo.orders = json
      demo.menus = getMenu json

  loadOrders = () ->
    $.ajax
      type: 'GET'
      url: "http://ipl-benten.herokuapp.com/api/orders"
      dataType: 'jsonp'
      jsonpCallback: 'callback'
      success: (json) ->
        len = json.length
        alert len
      error: (res, status, err) ->
        alert status

  loadOrdersDemo(demo2)
