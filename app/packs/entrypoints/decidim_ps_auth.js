// Images
require.context("../images", true)

import TomSelect from "tom-select/dist/cjs/tom-select.popular"

const initPsAuthTomSelect = () => {
  document.querySelectorAll(".js-ps-auth-authorizables-select").forEach((element) => {
    if (element.tomselect) return

    new TomSelect(element, {
      plugins: ["remove_button"],
      create: false,
      persist: false
    })
  })
}

document.addEventListener("DOMContentLoaded", initPsAuthTomSelect)
document.addEventListener("turbo:load", initPsAuthTomSelect)

