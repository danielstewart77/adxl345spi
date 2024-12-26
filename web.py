import os
from flask import Flask, render_template, request
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QPushButton, QLabel, QHBoxLayout
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

class TitleBar(QWidget):
    def __init__(self, parent):
        super().__init__(parent)
        self.setFixedHeight(30)  # Set a fixed height for the title bar
        self.setStyleSheet("background-color: #333; color: white;") # Example styling

        self.title_label = QLabel("My App") # Title Label
        self.title_label.setStyleSheet("padding-left:10px;")

        self.close_button = QPushButton("X")
        self.close_button.setStyleSheet("background-color: #ff5555; border: none; font-weight: bold; padding: 5px;")
        self.close_button.clicked.connect(parent.close)

        layout = QHBoxLayout()
        layout.addWidget(self.title_label) # Add Title
        layout.addStretch(1) # Add Stretch so the title is on the left and button on the right
        layout.addWidget(self.close_button)
        self.setLayout(layout)

# GUI Application
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.FramelessWindowHint) # Remove window frame
        self.setWindowTitle("My App")
        self.setGeometry(0, 0, 1920, 1080)
        self.setStyleSheet("background-color: #222;") # Example styling

        self.title_bar = TitleBar(self) # Create Title Bar

        # Web component
        self.web_view = QWebEngineView()
        self.web_view.setUrl(QUrl("http://127.0.0.1:5000/"))

        # Main Layout
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(0, 0, 0, 0) # Remove Margins
        main_layout.setSpacing(0) # Remove Spacing
        main_layout.addWidget(self.title_bar)
        main_layout.addWidget(self.web_view)

        central_widget = QWidget()
        central_widget.setLayout(main_layout)
        self.setCentralWidget(central_widget)

    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            self.m_drag = True
            self.m_DragPosition = event.globalPos() - self.frameGeometry().topLeft()
            event.accept()

    def mouseMoveEvent(self, event):
        if self.m_drag:
            self.move(event.globalPos() - self.m_DragPosition)
            event.accept()

    def mouseReleaseEvent(self, event):
        self.m_drag = False

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
