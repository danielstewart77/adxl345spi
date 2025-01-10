import os
import threading
import webview
from flask import Flask, render_template
from services.driver import start_application, stop_application, quit_application  # Import your functions

# Flask API
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')  # Ensure 'index.html' is in the templates folder

@app.route('/start')
def start():
    os.chdir('/opt/redoak/')  # Change to the correct directory
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

def run_flask():
    """Run the Flask app."""
    app.run(host="0.0.0.0", port=5000, debug=False)

def run_gui():
    """Run the pywebview GUI."""
    webview.create_window(
        title="RedOak Instruments",
        url="http://127.0.0.1:5000/",
        width=1920,
        height=1080,
        frameless=True
    )
    webview.start(gui='gtk')

if __name__ == "__main__":
    # Run Flask in a separate thread
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()

    # Run the GUI
    run_gui()