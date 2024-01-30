// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import 'jquery';
import 'jquery_ujs';
import 'popper';
import 'bootstrap';
import 'datepicker';

// window.onload = function() {
//   var loadWrapper = document.getElementById('loadWrapper');
//   loadWrapper.style.display = 'none';
// };

// document.addEventListener('turbo:before-render', function() {
//   loadWrapper.style.display = 'block';
// });

// document.addEventListener('turbo:load', function() {
//   loadWrapper.style.display = 'none';
// });

// document.addEventListener('turbo:render', function() {
//   loadWrapper.style.display = 'none';
// });

$(window).on('load', function() {
    var loadWrapper = document.getElementById('loadWrapper');
    loadWrapper.style.display = 'none';
});

document.getElementsByTagName('source').addEventListener('ended', function() {
  this.currentTime = 1;
}, false);