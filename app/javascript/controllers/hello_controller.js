import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    const inputs = document.querySelectorAll(".input");

    inputs.forEach(input => {
        input.value = ""; // Устанавливает значение каждого input в пустую строку
    });

    const modal = new bootstrap.Modal(document.getElementById('OrderSended'));

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

    $('.my-datepicker').datepicker({
      dateFormat: 'dd-MM-yyyy',
      inline: true,
      minDate: new Date(), // Устанавливает сегодняшнюю дату как минимальную
      onRenderCell: function (date, cellType) {
        if (cellType == 'day') {
          var day = date.getDay();
          // Дни недели в JavaScript начинаются с 0 (воскресенье) до 6 (суббота),
          // поэтому воскресенье это 0, а среда - 3.
          if (day != 0 && day != 3) {
            return {
              disabled: true // делаем день недоступным для выбора
            };
          }
        }
      }
    });

    $("#order-form").submit(function(event) {
      event.preventDefault(); // Предотвращает стандартное поведение формы
      var data = $(this).serialize(); // Сериализует данные формы

      $.ajax({
        type: "POST",
        url: '/create_order',
        data: data,
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
          $('#loadWrapper').show();
        },
        success: function(response) {
          // Скрывает анимацию загрузки
          $('#loadWrapper').hide();
          // Показывает модальное окно

          modal.show();
        },
        error: function(error) {
          console.error('Произошла ошибка', error);
          // Скрывает анимацию загрузки при ошибке
          $('#loadWrapper').hide();
          // Здесь можете добавить логику для отображения сообщения об ошибке
        }
      });
    });
  }
}



