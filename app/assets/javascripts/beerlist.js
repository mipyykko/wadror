const beers = {}

beers.show = () => {
  $("#beertable tr:gt(0)").remove()
  const table = $("#beertable")

  beers.list.forEach(beer => table.append('<tr>'+
    `<td>${beer['name']}</td>`+
    `<td>${beer['style']['name']}</td>`+
    `<td>${beer['brewery']['name']}</td>`+
    '</tr>'
  ))
}

beers.sort_by_name = () => {
  beers.list.sort((a, b) => a.name.toUpperCase().localeCompare(b.name.toUpperCase()))
}

beers.sort_by_style = () => {
  beers.list.sort((a, b) => a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase()))
}

beers.sort_by_brewery = () => {
  beers.list.sort((a, b) => a.brewery.name.toUpperCase().localeCompare(b.brewery.name.toUpperCase()))
}

beers.reverse = () => beers.list.reverse()

document.addEventListener("turbolinks:load", () => {
  if ($("#beertable").length == 0) {
    return
  }
  
  $("#name").click(e => {
    e.preventDefault()
    beers.sort_by_name()
    beers.show()
  })

  $("#style").click(e => {
    e.preventDefault()
    beers.sort_by_style()
    beers.show()
  })

  $("#brewery").click(e => {
    e.preventDefault()
    beers.sort_by_brewery()
    beers.show()
  })

  $("#reverse").click(e => {
    e.preventDefault()
    beers.reverse()
    beers.show()
  })

  $.getJSON("beers.json", (beers_json) => {
    beers.list = beers_json
    beers.show()
  })
})