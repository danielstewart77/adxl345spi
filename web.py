import os
from flask import Flask, render_template, request
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QPushButton
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtCore import QUrl
import sys
import threading
from services.driver import start_application, stop_application, quit_application  # Import your functions

# Flask API
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')  # Ensure 'index.html' is in the templates folder

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

def run_flask():
    """Run the Flask app."""
    app.run(host="0.0.0.0", port=5000, debug=False)

# GUI Application
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("RedOak Instruments")
        self.setGeometry(0, 0, 1920, 1080)  # Set fullscreen dimensions
        self.showFullScreen()

        # Create close button
        self.close_button = QPushButton("X")
        self.close_button.setStyleSheet("font-size: 16px; font-weight: bold")  # Optional styling
        self.close_button.clicked.connect(self.close)  # Connect click event to close method

        # Web component
        layout = QVBoxLayout()
        web_view = QWebEngineView()
        web_view.setUrl(QUrl("http://127.0.0.1:5000/"))  # Flask API endpoint

        container = QWidget()
        layout.addWidget(web_view)
        container.setLayout(layout)
        self.setCentralWidget(container)

def run_gui():
    """Run the PyQt5 GUI."""
    qt_app = QApplication(sys.argv)
    main_window = MainWindow()
    main_window.show()
    sys.exit(qt_app.exec_())

# Main function
if __name__ == "__main__":
    # Run Flask in a separate thread
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()

    # Run the GUI
    run_gui()
