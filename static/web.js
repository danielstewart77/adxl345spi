// web.js

document.addEventListener('DOMContentLoaded', () => {
  const statusField = document.getElementById('status');

  document.getElementById('startButton').addEventListener('click', async () => {
    try {
      const response = await fetch('/start');
      if (response.ok) {
        statusField.textContent = 'Status: Started';
      }
    } catch (error) {
      console.error('Error starting:', error);
      statusField.textContent = 'Status: Error Starting';
    }
  });

  document.getElementById('stopButton').addEventListener('click', async () => {
    try {
      const response = await fetch('/stop');
      if (response.ok) {
        statusField.textContent = 'Status: Stopped';
      }
    } catch (error) {
      console.error('Error stopping:', error);
      statusField.textContent = 'Status: Error Stopping';
    }
  });

  document.getElementById('quitButton').addEventListener('click', async () => {
    try {
      const response = await fetch('/quit');
      if (response.ok) {
        console.error('Error quitting:', response.textContent);
        statusField.textContent = `Status: ${response.textContent}`;
      }
      else {
        statusField.textContent = `Status: ${response.textContent}`;
      }
    } catch (error) {
      console.error('Error quitting:', error);
      statusField.textContent = 'Status: Error Quitting';
    }
  });
});
