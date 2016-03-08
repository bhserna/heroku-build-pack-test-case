$ = require("jquery")

$(document).on "click", ".js-order-toggle", (e) ->
  e.preventDefault()
  $(".order-v2").toggleClass("order-v2--closed")
  $(".order-v2").toggleClass("order-v2--open")

$(document).on "change", ".js-dish-selector", (e) ->
  updateOrder()

$(document).on "click", ".js-confirm-order", (e) ->
  e.preventDefault()
  form = $("#order_form")
  form.find("#order_confirmed").val("1")
  updateOrder()

$(document).on "submit", ".js-confirm-user-info", (e) ->
  e.preventDefault()
  updateOrder()

$(window).resize(setOrderHeight)

$ ->
  setOrderHeight()

setOrderHeight = ->
  $(".order-v2").css(maxHeight: $(window).height())
  $(".order").css(maxHeight: $(window).height())

openOrder = ->
  $("#current_order").removeClass("order-v2--closed")
  $("#current_order").addClass("order-v2--open")

updateOrder = ->
  form = $("#order_form")
  order = $("#current_order")
  userInfo = $("#user_info")

  data = [
    form.serialize(),
    userInfo.serialize()
  ].join "&"

  $.ajax
    url: form.attr("action")
    method: form.attr("method")
    data: data
    success: (html) ->
      $html = $(html)
      form.replaceWith $html.find("#order_form")
      order.html $html.find("#current_order").html()
      openOrder()
      setOrderHeight()

