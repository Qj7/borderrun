import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    const inputs = document.querySelectorAll(".input");
    const modal = new bootstrap.Modal(document.getElementById('OrderSended'));


    if (localStorage.getItem('showModalAfterReload') === 'true') {
      $('#OrderSended').modal('show');
      localStorage.removeItem('showModalAfterReload'); // Удаляем флаг
    }

    inputs.forEach(input => {
        input.value = "";
    });

    if (this.data.get("showAdValue") === "true") {
      const adModal = new bootstrap.Modal(document.getElementById('adModal'));
      adModal.show();
    }

    function focusFunc() {
      let parent = this.parentNode;
      parent.classList.add("focus");
    }

    function blurFunc() {
      let parent = this.parentNode;
      if (this.value == "") {
        parent.classList.remove("focus");
      }
    }

    inputs.forEach((input) => {
      input.addEventListener("focus", focusFunc);
      input.addEventListener("blur", blurFunc);
    });

    $.fn.datepicker.dates = {
      en: {
        days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sonntag"],

        daysShort: ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"],

        daysMin: ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"],
      }
    }

    ;(function ($) { $.fn.datepicker.language['en'] = {
      days: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      daysShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      daysMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      months: ['January','February','March','April','May','June', 'July','August','September','October','November','December'],
      monthsShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      today: 'Today',
      clear: 'Clear',
      dateFormat: 'mm/dd/yyyy',
      timeFormat: 'hh:ii aa',
      firstDay: 0
    }; })(jQuery);

    $('.my-datepicker').datepicker({
      dateFormat: 'dd-MM-yyyy',
      language: this.data.get("locale"),
      inline: true,
      minDate: new Date(), // Устанавливает сегодняшнюю дату как минимальную
      onRenderCell: function (date, cellType) {
        if (cellType == 'day') {
          var day = date.getDay();
          // Дни недели в JavaScript начинаются с 0 (воскресенье) до 6 (суббота),
          // поэтому воскресенье это 0, а среда - 3.
          // if (day != 0 && day != 3) {
          //   return {
          //     disabled: true // делаем день недоступным для выбора
          //   };
          // }
          if (day == 2 || day == 4) {
            return {
              disabled: true // делаем день недоступным для выбора
            };
          }
        }
      }
    });

    $("#order-form").submit(function(event) {
      event.preventDefault();
      var data = $(this).serialize();

      $.ajax({
        type: "POST",
        url: '/create_order',
        data: data,
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
          $('#loadWrapper').show();
        },
        success: function(response) {
          $('#loadWrapper').hide();
          localStorage.setItem('showModalAfterReload', 'true');
          location.reload();
          // modal.show();
        },
        error: function(error) {
          console.error('Произошла ошибка', error);
          $('#loadWrapper').hide();
        }
      });
    });

    $('.nickname').on('input', function(){
      var currentValue = $(this).val();
      if(currentValue.length > 0 && currentValue[0] !== '@'){
        $(this).val('@' + currentValue);
      }
    });
  }
}



