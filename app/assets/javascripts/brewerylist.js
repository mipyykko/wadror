const breweries = {}

active = (n) => n ? 'yes' : 'no'

breweries.show = () => {
  $("#brewerytable tr:gt(0)").remove()
  const table = $("#brewerytable")

  breweries.list.forEach(brewery => table.append('<tr>'+
    `<td>${brewery['name']}</td>`+
    `<td>${brewery['year']}</td>`+
    `<td>${brewery['beer_count']}</td>`+
    `<td>${active(brewery['active'])}</td>`+
    '</tr>'
  ))
}

breweries.sort_by_name = () => {
  breweries.list.sort((a, b) => a.name.toUpperCase().localeCompare(b.name.toUpperCase()))
}

breweries.sort_by_year = () => {
  breweries.list.sort((a, b) => a.year.localeCompare(b.year))
}

breweries.sort_by_beer_count = () => {
  breweries.list.sort((a, b) => a.beer_count.localeCompare(b.beer_count))
}

breweries.sort_by_active = () => {
  breweries.list.sort((a, b) => active(a.active).localeCompare(active(b.active)))
}

breweries.reverse = () => breweries.list.reverse()

document.addEventListener("turbolinks:load", () => {
  if ($("#brewerytable").length == 0) {
    return
  }
  
  $("#name").click(e => {
    e.preventDefault()
    breweries.sort_by_name()
    breweries.show()
  })

  $("#year").click(e => {
    e.preventDefault()
    breweries.sort_by_year()
    breweries.show()
  })

  $("#beer_count").click(e => {
    e.preventDefault()
    breweries.sort_by_beer_count()
    breweries.show()
  })

  $("#active").click(e => {
    e.preventDefault()
    breweries.sort_by_active()
    breweries.show()
  })

  $("#reverse").click(e => {
    e.preventDefault()
    breweries.reverse()
    breweries.show()
  })

  $.getJSON("breweries.json", (breweries_json) => {
    breweries.list = breweries_json
    breweries.show()
  })
})