parties_legend = ->
  pnames = Object.keys(defaults)

  parties_div = document.createElement("div")
  parties_div.classList.add "parties"
  all_parties = gon.parties
  all_parties.forEach (party)->
    return unless party.name in pnames
    party_div = document.createElement("div")
    party_div.classList.add "party"
    party_div.setAttribute("party",party.name)
    # checkbox = $("<paper-button flex="" horizontal="" center-center="" layout="" role="button" tabindex="0">Garlic</paper-button>")
    checkbox = document.createElement("paper-button")
    checkbox.setAttribute "toggle", ""
    checkbox.setAttribute "party", party.name
    checkbox.classList.add "colored"
    checkbox.innerHTML = party.name.substring(0,30)

    # checkbox.setAttribute("checked", "true")
    # checkbox.setAttribute("type", "checkbox")
    checkbox.setAttribute("value", party.name)
    party_div.appendChild checkbox
    checkbox.addEventListener "click", (ev)->
      p = @getAttribute "party"
      alert "will now show #{p}"
    parties_div.appendChild party_div

  document.querySelector("body").appendChild parties_div

$(document).on "map_loaded", ->
  parties_legend()
