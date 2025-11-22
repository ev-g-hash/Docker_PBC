document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const submitBtn = document.getElementById('submitBtn');
    const spinner = document.getElementById('spinner');
    
    // Показываем спиннер и блокируем кнопку
    spinner.classList.remove('d-none');
    submitBtn.disabled = true;
    
    fetch('/forms/', {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Показываем модальное окно с успешным сообщением
            showSuccessModal(data.message);
            
            // Автоматически закрываем модал и редиректим через 3 секунды
            setTimeout(() => {
                window.location.href = '/';
            }, 3000);
        } else {
            // Обработка ошибок
            if (data.errors) {
                Object.keys(data.errors).forEach(field => {
                    const errorElement = document.getElementById(`${field}-error`);
                    const inputElement = document.getElementById(`id_${field}`);
                    if (errorElement && inputElement) {
                        errorElement.textContent = data.errors[field][0];
                        inputElement.classList.add('is-invalid');
                    }
                });
            }
        }
    }) 
    .catch(error => {
        console.error('Error:', error);
        alert('Произошла ошибка. Попробуйте позже.');
    })
    .finally(() => {
        spinner.classList.add('d-none');
        submitBtn.disabled = false;
    });
});

function showSuccessModal(message) {
    // Создаем модальное окно
    const modalHtml = `
        <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h5 class="modal-title text-success" id="successModalLabel">
                            <i class="bi bi-check-circle-fill me-2"></i>Заявка отправлена!
                        </h5>
                    </div>
                    <div class="modal-body text-center">
                        <p class="lead">${message}</p>
                        <p class="text-muted">Вы будете перенаправлены на главную страницу через 3 секунды...</p>
                    </div>
                    <div class="modal-footer border-0 justify-content-center">
                        <button type="button" class="btn btn-primary" onclick="redirectToHome()">
                            Перейти сейчас
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Добавляем модал в DOM
    document.body.insertAdjacentHTML('beforeend', modalHtml);
    
    // Показываем модал
    const modal = new bootstrap.Modal(document.getElementById('successModal'));
    modal.show();
    
    // Удаляем модал из DOM после закрытия
    document.getElementById('successModal').addEventListener('hidden.bs.modal', function () {
        this.remove();
    });
}

function redirectToHome() {
    window.location.href = '/';
}