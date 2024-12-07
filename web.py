from flask import Flask, render_template
from services.driver import start_application, stop_application, quit_application  # Import your console app's functions

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start')
def start():
    start_application()
    return 'start'

@app.route('/stop')
def stop():
    stop_application()
    return 'stop'

@app.route('/quit')
def quit():
    quit_application()
    return 'quit'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
