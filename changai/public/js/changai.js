// Copyright (c) 2025, ERpGulf and contributors
// For license information, please see license.txt
$(document).ready(function () {
            if (!$('#chat-window').length) {
                $('body').append(`
                    <div id="chat-window" style="display: none;">
                        <div id="chat-header">
                            <div class="chat-header-container">
                                <span># changai</span>
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="black" class="bi bi-robot" viewBox="0 0 16 16">
                                    <path d="M6 12.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5M3 8.062C3 6.76 4.235 5.765 5.53 5.886a26.6 26.6 0 0 0 4.94 0C11.765 5.765 13 6.76 13 8.062v1.157a.93.93 0 0 1-.765.935c-.845.147-2.34.346-4.235.346s-3.39-.2-4.235-.346A.93.93 0 0 1 3 9.219zm4.542-.827a.25.25 0 0 0-.217.068l-.92.9a25 25 0 0 1-1.871-.183.25.25 0 0 0-.068.495c.55.076 1.232.149 2.02.193a.25.25 0 0 0 .189-.071l.754-.736.847 1.71a.25.25 0 0 0 .404.062l.932-.97a25 25 0 0 0 1.922-.188.25.25 0 0 0-.068-.495c-.538.074-1.207.145-1.98.189a.25.25 0 0 0-.166.076l-.754.785-.842-1.7a.25.25 0 0 0-.182-.135"/>
                                    <path d="M8.5 1.866a1 1 0 1 0-1 0V3h-2A4.5 4.5 0 0 0 1 7.5V8a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1v1a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-1a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1v-.5A4.5 4.5 0 0 0 10.5 3h-2zM14 7.5V13a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V7.5A3.5 3.5 0 0 1 5.5 4h5A3.5 3.5 0 0 1 14 7.5"/>
                                </svg>
                            </div>
                            <button id="close-chat">✖</button>
                        </div>
                        <div id="chat-messages" class="no-scrollbar"></div>
                        <div id="chat-input-container">
                            <input type="text" id="chat-input" placeholder="Type a message...">
                            <button id="send-button">➤</button>
                        </div>
                    </div>
                `);
                if (!$('#floating-chat-button').length) {
                    $('body').append(`
                        <div id="floating-chat-button">
                            <i class="fa fa-comments"></i>
                        </div>
                    `);
    
                    $('#floating-chat-button').on('click', function() {
                        toggleChatWindow();
                    });
                }
                let chatOpen = localStorage.getItem("chatOpen");
                if (chatOpen === "true") {
                    $('#chat-window').show();
                }
                $('#close-chat').on('click', function() {
                    console.log("Hiding Chat Window...");
                    $('#chat-window').fadeOut();
                    localStorage.setItem("chatOpen", "false");
                });
                $('#send-button').on('click', function() {
                    sendMessage();
                });
                $('#chat-input').on('keypress', function(event) {
                    if (event.which === 13) {
                        sendMessage();
                    }
                });
                loadChatHistory();
                setTimeout(() => {
                    scrollToBottom();
                }, 300);
            }
        });

function toggleChatWindow() {
    let chatWindow = $('#chat-window');
    let chatButton = $('#floating-chat-button');

    if (chatWindow.is(':visible')) {
        chatWindow.fadeOut(300, function() {
            chatButton.fadeIn(300);
        });
    } else {
        let buttonPosition = chatButton.offset();

        chatWindow.css({
            bottom: $(window).height() - buttonPosition.top - chatButton.outerHeight(),
            right: $(window).width() - buttonPosition.left - chatButton.outerWidth()
        });

        chatButton.fadeOut(200, function() {
            chatWindow.fadeIn(300).addClass('fadeIn');
        });
    }
}
$(document).on('click', '#close-chat', function() {
    console.log("Closing Chat...");
    $('#chat-window').fadeOut(300, function() {
        $('#floating-chat-button').fadeIn(300);
    });
});
function getFormattedTimestamp() {
    let now = new Date();
    let hours = now.getHours();
    let minutes = now.getMinutes();
    let ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12 || 12;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    let timeString = `${hours}:${minutes} ${ampm}`;
    let dateString = now.toLocaleDateString("en-GB", { day: 'numeric', month: 'long', year: 'numeric' });
    return { date: dateString, time: timeString };
}
function sendMessage() {
    let inputField = $('#chat-input');
    let message = inputField.val().trim();
    if (message === "") return;
    let timestamp = getFormattedTimestamp();
    let chatMessages = $('#chat-messages');
    let savedChat = localStorage.getItem("chatHistory");
    let messages = savedChat ? JSON.parse(savedChat) : [];
    let lastMessageDate = chatMessages.children(".chat-date:last").text();
    if (lastMessageDate !== timestamp.date) {
        chatMessages.append(`<div class="chat-date">${timestamp.date}</div>`);
        messages.push({ date: timestamp.date, type: "separator" });
    }
    chatMessages.append(`
        <div class="userchat-message user-message">
            <div class="chat-header-container">
                    <div class="chat-header">
                        <span class="message-username">Administrator</span>
                        <span class="timestamp">${timestamp.time}</span>
                    </div>
            </div>
            <div class="chat-message-container user-container">
                <p class="message-text">${message}</p>
            </div>
        </div>
    `);
    messages.push({
        sender: "Administrator",
        timestamp: timestamp.time,
        text: message,
        date: timestamp.date
    });

    localStorage.setItem("chatHistory", JSON.stringify(messages));
    inputField.val("");
    scrollToBottom();
    chatMessages.append(`
        <div id="typing-indicator" class="chat-message ai-message">
            <div class="chat-header">
                    <span class="message-username">Changai</span>
                    <span class="timestamp">${getFormattedTimestamp().time}</span>
            </div>
            <div class="typing-indicator">
                <span></span><span></span><span></span>
            </div>
        </div>
    `);
    scrollToBottom();
    frappe.call({
        method: "changai.public.python.changai.query_huggingface",
        args: { user_input: message },
        async: true,
        callback: function(response) {
            $('#typing-indicator').remove();
            if (response && response.message && response.message.success) {
                console.log("Raw Response from Model:", response.message.response);
                let aiTimestamp = getFormattedTimestamp();
                let chat_response = response.message.response
                .replace(/\\n/g, "<br>")
                // .replace(/\\"/g, '"')
                .replace(/\/\/.*/g, "")
                .trim();

                chatMessages.append(`
                    <div class="chat-message ai-message">
                        <div class="chat-header-container">
                            <div class="chat-header">
                                <span class="message-username">Changai</span>
                                <span class="timestamp">${getFormattedTimestamp().time}</span>
                            </div>
                        </div>
                        <div class="chat-message-container">
                            <p class="message-text">${chat_response}</p>
                        </div>
                    </div>
                `);
                messages.push({
                    sender: "Changai",
                    timestamp: aiTimestamp.time,
                    text: chat_response,
                    date: aiTimestamp.date
                });

                localStorage.setItem("chatHistory", JSON.stringify(messages));
            } else {
                console.error("Error in API Response:", response);
                chatMessages.append(`
                    <div class="chat-message error-message">
                        <p class="message-text">⚠️ Changai failed to respond. Please try again.</p>
                    </div>
                `);
            }
            scrollToBottom();
        },
        error: function(xhr, status, error) {
            console.error("API Call Failed:", error);
            chatMessages.append(`
                <div class="chat-message error-message">
                    <p class="message-text">🚨 Server error! Please refresh and try again.</p>
                </div>
            `);
        }
    });
} 
function saveChatHistory() {
    let messages = [];
    $('#chat-messages .userchat-message').each(function() {
        let messageDate = $(this).prev('.chat-date').text().trim();
        messages.push({
            sender: $(this).find('.message-username').text(),
            timestamp: $(this).find('.timestamp').text(),
            text: $(this).find('.message-text').text(),
            date: messageDate
        });
    });

    localStorage.setItem("chatHistory", JSON.stringify(messages));
}
function scrollToBottom() {
    let chatMessages = $('#chat-messages');
    chatMessages.animate({ scrollTop: chatMessages.prop("scrollHeight") }, 500); /* Smooth animation */
}

function loadChatHistory() {
    let savedChat = localStorage.getItem("chatHistory");
    if (savedChat) {
        let messages = JSON.parse(savedChat);
        let chatMessages = $('#chat-messages');
        chatMessages.html("");

        let lastDate = "";

        messages.forEach(msg => {
            if (!msg.sender || !msg.text || !msg.timestamp) {
                return;
            }
            if (msg.date !== lastDate) {
                chatMessages.append(`<div class="chat-date">${msg.date}</div>`);
                lastDate = msg.date;
            }
            let messageType = msg.sender.toLowerCase() === "administrator" ? "user-message" : "ai-message";
            let messageClass = msg.sender.toLowerCase() === "administrator" ? "userchat-message" : "chat-message";
            chatMessages.append(`
                <div class="${messageClass} ${messageType}">
                    <div class="message-header">
                        <span class="message-username">${msg.sender}</span>
                        <span class="timestamp">${msg.timestamp}</span>
                    </div>
                    <div class="chat-message-container ${messageType}">
                        <p class="message-text">${msg.text}</p>
                    </div>
                </div>
            `);
        });
        setTimeout(() => {
            $('.user-message .chat-message-container').css("background", "#DCF8C6");
            $('.ai-message .chat-message-container').css("background", "#FFFFFF");
            scrollToBottom();
        }, 50);
    }
}

