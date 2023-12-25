# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "jquery", to: "jquery.min.js"
pin "jquery_ujs", to: "jquery_ujs.js"
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js"
pin 'datepicker', to: 'datepicker.js'
# pin_all_from "app/javascript/packs", under: "packs"

pin_all_from "app/javascript/controllers", under: "controllers"
