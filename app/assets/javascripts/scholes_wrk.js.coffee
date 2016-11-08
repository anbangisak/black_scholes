(($) ->
  $("#price_update").on "click", ->
    priceCal()
) jQuery

priceCal = ->
  $.ajax
    url: "/scholes/scholes-update-price"
    type: "POST",
    data: $("#scholes_price").serialize(),
    success: (data) ->
      $("#display_price").html ""
      $("#display_price").html data["display_price"]