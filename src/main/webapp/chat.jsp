<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Simple Chat System</title>

    <style>

        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        .chat-container {
            width: 700px;
            margin: 40px auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px #aaa;
            overflow: hidden;
        }

        .header {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .header h2 {
            margin: 0 0 8px 0;
        }

        .header p {
            margin: 0;
        }

        .user-section {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            background-color: #fafafa;
        }

        .user-section label {
            font-weight: bold;
            margin-right: 10px;
        }

        #receiver {
            padding: 8px;
            width: 200px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .chat-area {
            height: 400px;
            overflow-y: auto;
            padding: 15px;
            background-color: #f8f8f8;
        }

        .message-row {
            margin-bottom: 12px;
            display: flex;
        }

        .my-message {
            justify-content: flex-end;
        }

        .other-message {
            justify-content: flex-start;
        }

        .message-box {
            max-width: 65%;
            padding: 10px;
            border-radius: 8px;
            word-wrap: break-word;
        }

        .my-message .message-box {
            background-color: #d9fdd3;
            text-align: right;
        }

        .other-message .message-box {
            background-color: #eeeeee;
            text-align: left;
        }

        .sender {
            font-weight: bold;
            margin-bottom: 4px;
        }

        .message-text {
            margin-bottom: 5px;
        }

        .message-time {
            font-size: 11px;
            color: #777;
        }

        .input-section {
            display: flex;
            padding: 15px;
            border-top: 1px solid #ddd;
            background-color: white;
        }

        #message {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        .send-button {
            margin-left: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #333;
            color: white;
            cursor: pointer;
            font-size: 15px;
        }

        .send-button:hover {
            background-color: #555;
        }

        .logout-section {
            text-align: center;
            padding: 15px;
            border-top: 1px solid #ddd;
        }

        .logout-button {
            color: #333;
            text-decoration: none;
        }

        .logout-button:hover {
            text-decoration: underline;
        }

    </style>

</head>

<body>

    <!-- Hidden field containing current logged-in user -->
    <input type="hidden"
           id="currentUser"
           value="<%= username %>">


    <div class="chat-container">


        <!-- Header -->

        <div class="header">

            <h2>Simple Chat System</h2>

            <p>
                Logged in as:
                <strong><%= username %></strong>
            </p>

        </div>


        <!-- Receiver selection -->

        <div class="user-section">

            <label for="receiver">
                Chat with:
            </label>

            <select id="receiver"
                    onchange="loadMessages()">

                <option value="">
                    Loading users...
                </option>

            </select>

        </div>


        <!-- Chat messages -->

        <div class="chat-area"
             id="chatArea">

            <p style="text-align:center; color:#888;">
                Select a user to view messages.
            </p>

        </div>


        <!-- Message input -->

        <div class="input-section">

            <input type="text"
                   id="message"
                   placeholder="Type your message..."
                   onkeypress="handleEnter(event)">

            <button type="button"
                    class="send-button"
                    onclick="sendMessage()">

                Send

            </button>

        </div>


        <!-- Logout -->

        <div class="logout-section">

            <a href="login.jsp"
               class="logout-button">

                Back to Login

            </a>

        </div>


    </div>


    <script>


        /*
         * Load users from GetUsersServlet
         */

        function loadUsers() {

            fetch("GetUsersServlet")

                .then(response => {

                    if (!response.ok) {
                        throw new Error(
                            "Unable to load users"
                        );
                    }

                    return response.json();

                })

                .then(users => {

                    const receiver =
                        document.getElementById(
                            "receiver"
                        );

                    receiver.innerHTML = "";


                    if (users.length === 0) {

                        const option =
                            document.createElement(
                                "option"
                            );

                        option.value = "";

                        option.textContent =
                            "No other users";

                        receiver.appendChild(
                            option
                        );

                        return;
                    }


                    users.forEach(user => {

                        const option =
                            document.createElement(
                                "option"
                            );

                        option.value = user;

                        option.textContent = user;

                        receiver.appendChild(
                            option
                        );

                    });


                    /*
                     * Load messages for the first user
                     */

                    loadMessages();

                })

                .catch(error => {

                    console.error(
                        "Error loading users:",
                        error
                    );

                    const receiver =
                        document.getElementById(
                            "receiver"
                        );

                    receiver.innerHTML =
                        '<option value="">' +
                        'Unable to load users' +
                        '</option>';

                });

        }


        /*
         * Load messages between current user
         * and selected receiver
         */

        function loadMessages() {

            const receiver =
                document.getElementById(
                    "receiver"
                ).value;

            const chatArea =
                document.getElementById(
                    "chatArea"
                );

            const currentUser =
                document.getElementById(
                    "currentUser"
                ).value;


            if (receiver === "") {

                chatArea.innerHTML =
                    '<p style="text-align:center; color:#888;">' +
                    'Select a user to view messages.' +
                    '</p>';

                return;
            }


            fetch(
                "GetMessagesServlet?receiver=" +
                encodeURIComponent(receiver)
            )

                .then(response => {

                    if (!response.ok) {

                        throw new Error(
                            "Unable to load messages"
                        );

                    }

                    return response.json();

                })

                .then(messages => {

                    chatArea.innerHTML = "";


                    /*
                     * No messages
                     */

                    if (messages.length === 0) {

                        chatArea.innerHTML =
                            '<p style="text-align:center; color:#888;">' +
                            'No messages yet. Start chatting!' +
                            '</p>';

                        return;
                    }


                    /*
                     * Display each message
                     */

                    messages.forEach(msg => {

                        const messageRow =
                            document.createElement(
                                "div"
                            );


                        const messageBox =
                            document.createElement(
                                "div"
                            );


                        messageRow.className =
                            "message-row";


                        messageBox.className =
                            "message-box";


                        /*
                         * Check whether message
                         * belongs to current user
                         */

                        if (msg.sender === currentUser) {

                            messageRow.classList.add(
                                "my-message"
                            );

                        } else {

                            messageRow.classList.add(
                                "other-message"
                            );

                        }


                        /*
                         * Sender name
                         */

                        const sender =
                            document.createElement(
                                "div"
                            );

                        sender.className =
                            "sender";

                        sender.textContent =
                            msg.sender;


                        /*
                         * Message text
                         */

                        const messageText =
                            document.createElement(
                                "div"
                            );

                        messageText.className =
                            "message-text";

                        messageText.textContent =
                            msg.message;


                        /*
                         * Message time
                         */

                        const messageTime =
                            document.createElement(
                                "div"
                            );

                        messageTime.className =
                            "message-time";

                        messageTime.textContent =
                            msg.message_time;


                        /*
                         * Add everything
                         */

                        messageBox.appendChild(
                            sender
                        );

                        messageBox.appendChild(
                            messageText
                        );

                        messageBox.appendChild(
                            messageTime
                        );

                        messageRow.appendChild(
                            messageBox
                        );

                        chatArea.appendChild(
                            messageRow
                        );

                    });


                    /*
                     * Scroll to latest message
                     */

                    chatArea.scrollTop =
                        chatArea.scrollHeight;

                })

                .catch(error => {

                    console.error(
                        "Error loading messages:",
                        error
                    );

                    chatArea.innerHTML =
                        '<p style="color:red; text-align:center;">' +
                        'Unable to load messages.' +
                        '</p>';

                });

        }


        /*
         * Send a message
         */

        function sendMessage() {

            const receiver =
                document.getElementById(
                    "receiver"
                ).value;


            const messageInput =
                document.getElementById(
                    "message"
                );


            const message =
                messageInput.value.trim();


            /*
             * Check receiver
             */

            if (receiver === "") {

                alert(
                    "Please select a user."
                );

                return;
            }


            /*
             * Check message
             */

            if (message === "") {

                alert(
                    "Please enter a message."
                );

                return;
            }


            /*
             * Prepare data
             */

            const data =
                new URLSearchParams();


            data.append(
                "receiver",
                receiver
            );


            data.append(
                "message",
                message
            );


            /*
             * Send AJAX request
             */

            fetch(
                "SendMessageServlet",
                {

                    method: "POST",

                    headers: {

                        "Content-Type":
                            "application/x-www-form-urlencoded"

                    },

                    body:
                        data.toString()

                }
            )

                .then(response => {

                    return response.json();

                })

                .then(result => {

                    if (result.success) {

                        /*
                         * Clear input
                         */

                        messageInput.value = "";


                        /*
                         * Reload messages
                         */

                        loadMessages();

                    } else {

                        alert(
                            result.message
                        );

                    }

                })

                .catch(error => {

                    console.error(
                        "Error sending message:",
                        error
                    );

                    alert(
                        "Unable to send message."
                    );

                });

        }


        /*
         * Press Enter to send
         */

        function handleEnter(event) {

            if (event.key === "Enter") {

                sendMessage();

            }

        }


        /*
         * Load users when page opens
         */

        window.onload = function() {

            loadUsers();

        };


        /*
         * Automatically refresh messages
         * every 3 seconds
         */

        setInterval(
            function() {

                const receiver =
                    document.getElementById(
                        "receiver"
                    ).value;

                if (receiver !== "") {

                    loadMessages();

                }

            },
            3000
        );


    </script>

</body>

</html>