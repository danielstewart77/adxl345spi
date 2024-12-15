from flask import Flask, jsonify
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtCore import QUrl  # Import QUrl
import sys
import threading

# Flask API
app = Flask(__name__)

@app.route("/api/data", methods=["GET"])
def get_data():
    return jsonify({"message": "Hello, World!"})

# GUI Application
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("My App")
        self.setGeometry(0, 0, 1920, 1080)  # Set fullscreen dimensions
        self.setWindowFlag(True)
        self.showFullScreen()

        # Web component
        layout = QVBoxLayout()
        web_view = QWebEngineView()
        web_view.setUrl(QUrl("http://127.0.0.1:5000/"))  # Use QUrl

        container = QWidget()
        layout.addWidget(web_view)
        container.setLayout(layout)
        self.setCentralWidget(container)

def run_flask():
    app.run(host="127.0.0.1", port=5000, debug=False)

def run_gui():
    app = QApplication(sys.argv)
    main_window = MainWindow()
    main_window.show()
    sys.exit(app.exec_())

# Main function
if __name__ == "__main__":
    # Run Flask in a separate thread
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()

    # Run the GUI
    run_gui()
