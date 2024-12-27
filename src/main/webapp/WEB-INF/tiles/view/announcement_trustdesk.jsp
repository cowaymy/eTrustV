<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Header</title>
  <style>
    /* Styles for the popup modal */
    .popup-overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      z-index: 9999;
    }

    .popup {
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: white;
      padding: 20px;
      width: 80%;
      max-width: 600px;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      z-index: 10000;
    }

    .popup h2 {
      margin-top: 0;
      color: #333;
    }

    .popup p {
      line-height: 1.6;
      color: #555;
    }

    .popup a {
      color: #007BFF;
      text-decoration: none;
    }

    .popup a:hover {
      text-decoration: underline;
    }

    .popup button {
      background-color: #007BFF;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 4px;
      cursor: pointer;
    }

    .popup button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
  <!-- Popup modal -->
  <div class="popup-overlay" id="popupOverlay">
    <div class="popup">
      <h2>Important Announcement</h2>
      <p><strong>Transition to the New TrustDesk System</strong></p>
      <p>
        Effective <strong>January 2, 2025</strong>, all IT service requests will be managed exclusively through the new TrustDesk system. Please take note of the following key dates and actions required:
      </p>
      <ul>
        <li><strong>Immediately:</strong> Ensure that all open tickets in the current TrustDesk system are closed.</li>
        <li><strong>January 2, 2025:</strong> The current TrustDesk system will no longer accept new ticket submissions.</li>
        <li><strong>January 11, 2025:</strong> Access to the current TrustDesk system will be permanently disabled.</li>
      </ul>
      <p>
        To submit IT service requests in the new system, please use the following link: 
        <a href="https://works-my.coway.do/#/itsm/home" target="_blank">https://works-my.coway.do/#/itsm/home</a>.
      </p>
      <p>Thank you for your cooperation during this transition. If you have any questions or require assistance, please contact the IT Support team.</p>
      <button onclick="closePopup()">Close</button>
    </div>
  </div>

  <script>
    // Function to show the popup
    function showPopup() {
      document.getElementById('popupOverlay').style.display = 'block';
    }

    // Function to close the popup
    function closePopup() {
      document.getElementById('popupOverlay').style.display = 'none';
    }

    // Show the popup when the page loads
    window.onload = showPopup;
  </script>
</body>
</html>
