// Insert chatbot HTML template into body
document.addEventListener('DOMContentLoaded', () => {
    const chatbotHTML = `
  <button id="chatbot-toggler" class="chatbot-toggler">
    <svg class="icon icon-chat" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true">
        <path
        d="M4 4h16a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H8l-4 4v-4H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z"
        fill="currentColor" stroke="currentColor" stroke-width="2s"
        stroke-linecap="miter" stroke-linejoin="miter" />
    </svg>
  <!-- close (X) -->
    <svg class="icon icon-close" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true" fill="none">
        <path d="M6 6l12 12M18 6L6 18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
    </svg>
  </button>

  <div class="chatbot-popup" id="chatbot-popup">
    <div class="chat-header">
      <div class="header-info">
        <svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" viewBox="0 0 1024 1024">
          <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"/>
        </svg>
        <h2 class="logo-text">ChangAI</h2>
      </div>
      <button id="chatbot-arrowdown-btn">
  <svg xmlns="http://www.w3.org/2000/svg" height="24" width="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <path d="M6 9l6 6 6-6"/>
</svg>
</button>

    </div>
    <div class="tab_box">
      <button id="tab-chat" class="tab_btn active">Chat</button>
      <button id="tab-debug" class="tab_btn">Debug</button>
    </div>

    <div class="chat-body" id="chat-body">
      <div id="chat-messages"></div>
    </div>

    <div class="chat-footer">
      <form id="chat-form" class="chat-form" autocomplete="off">
        <input type="text" id="chat-input" class="message-input" placeholder="Message..." required />
        <button type="submit" id="chatbot-send-btn" title="Send">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor" aria-hidden="true">
            <path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.59 5.58L20 12l-8-8-8 8z"/>
        </svg>
        </button>


      </form>
    </div>
  </div>
  `;
    document.body.insertAdjacentHTML('beforeend', chatbotHTML);
    let activeTab = 'chat';
    const chatHistory = [];
    const debugLogs = [];
    const chatbotPopup = document.getElementById('chatbot-popup');
    const chatbotToggler = document.getElementById('chatbot-toggler');
    const tabChatBtn = document.getElementById('tab-chat');
    const closeBtn = document.getElementById('chatbot-arrowdown-btn');
    const tabDebugBtn = document.getElementById('tab-debug');
    const chatMessagesContainer = document.getElementById('chat-body');
    const chatForm = document.getElementById('chat-form');
    const chatInput = document.getElementById('chat-input');
    function renderMessages() {
        const container = document.getElementById('chat-messages');
        container.innerHTML = '';
        if (activeTab === 'chat') {
            const welcome = document.createElement('div');
            welcome.className = 'messageCon bot-message';
            welcome.innerHTML = `<div class="messageCon bot-message">
    <svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
      <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z" />
    </svg>
    <p class="message-text">Hello there 👋 I am ChangAI, your ERP assistant</p>
  </div>`;
            container.appendChild(welcome);
            chatHistory.forEach(msg => {
                const div = document.createElement('div');
                div.className = `messageCon ${msg.role === 'user' ? 'user-message' : 'bot-message'}`;
                if (msg.role === 'model') {
                    div.innerHTML = `
    <svg xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
      <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z" />
    </svg>
    <p class="message-text">${msg.text}</p>`;
                } else {
                    div.innerHTML = `<p class="message-text">${msg.text}</p>`;
                }
                container.appendChild(div);
            });
        }

        else if (activeTab === 'debug') {
            if (debugLogs.length === 0) {
                const p = document.createElement('p');
                p.className = 'message-text';
                p.textContent = 'No debug data yet.';
                container.appendChild(p);
            } else {
                debugLogs.forEach(log => {
                    const wrapper = document.createElement('div');
                    wrapper.className = 'debug-query';

                    const pre = document.createElement('pre');
                    pre.className = 'message-text';
                    pre.textContent = JSON.stringify(log, null, 2);

                    wrapper.appendChild(pre);
                    container.appendChild(wrapper);
                });
            }
        }

    }

    async function setChatHistory(message) {
        chatHistory.push({ role: 'user', text: message });
        renderMessages();
        scrollToBottom();

        // Add placeholder message
        const thinkingMsg = { role: 'model', text: 'Thinking...' };
        chatHistory.push(thinkingMsg);
        renderMessages();
        scrollToBottom();

        // Set warming message timeout
        const warmingTimeout = setTimeout(() => {
            if (thinkingMsg.text === 'Thinking...') {
                thinkingMsg.text = 'Model is warming up, please wait...⌛';
                renderMessages();
                scrollToBottom();
            }
        }, 12000);

        // Call bot response
        generateBotResponse(message, thinkingMsg, warmingTimeout);
    }

    async function generateBotResponse(userMsg, thinkingMsg, warmingTimeout) {
        try {
            const API_URL = await frappe.db.get_single_value("Settings", "backend_url");
            const reqOpts = {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Frappe-CSRF-Token": frappe.csrf_token
                },
                body: JSON.stringify({ qstn: userMsg }),
            };

            const res = await fetch(API_URL, reqOpts);
            const data = await res.json();

            if (!res.ok) throw new Error(data.message?.error || "Something went wrong!!");

            clearTimeout(warmingTimeout);

            if (data.message?.query_data) {
                thinkingMsg.text = data.message.query_data;
            } else {
                const res = await fetch(API_URL, reqOpts);
                const data = await res.json();
                thinkingMsg.text = data.message?.query_data;
            }
            debugLogs.push({
                user: userMsg,
                response: thinkingMsg.text,
                doctype: data.message?.doctype,
                top_fields: data.message?.top_fields,
                fields: data.message?.fields,
                query: data.message?.query,
                data: data.message?.data
            });

            renderMessages();
            scrollToBottom();

        } catch (error) {
            console.error("API Error:", error);

            clearTimeout(warmingTimeout);
            thinkingMsg.text = error.message;
            debugLogs.push({ user: userMsg, error: error.message });
            renderMessages();
            scrollToBottom();
        }
    }



    function scrollToBottom() {
        chatMessagesContainer.scrollTo({
            top: chatMessagesContainer.scrollHeight,
            behavior: 'smooth',
        });
    }

    function toggleChatbot(forceShow) {
        const shouldShow = typeof forceShow === 'boolean' ? forceShow : !chatbotPopup.classList.contains('show');

        if (shouldShow) {
            chatbotToggler.setAttribute('aria-pressed', 'true');
            chatbotPopup.classList.add('show');
            chatbotToggler.classList.add('show');

            // ✅ Call renderMessages here
            renderMessages();
            scrollToBottom();

        } else {
            chatbotToggler.setAttribute('aria-pressed', 'false');
            chatbotPopup.classList.remove('show');
            chatbotToggler.classList.remove('show');
        }
    }

    if (closeBtn) closeBtn.addEventListener('click', () => toggleChatbot(false));
    chatbotToggler.addEventListener('click', () => toggleChatbot());

    chatForm.addEventListener('submit', e => {
        e.preventDefault();
        const message = chatInput.value.trim();
        if (!message) return;
        chatInput.value = '';
        setChatHistory(message);
    });

    tabChatBtn.addEventListener('click', () => {
        activeTab = 'chat';
        tabChatBtn.classList.add('active');
        tabDebugBtn.classList.remove('active');
        renderMessages();
        scrollToBottom();
    });

    tabDebugBtn.addEventListener('click', () => {
        activeTab = 'debug';
        tabDebugBtn.classList.add('active');
        tabChatBtn.classList.remove('active');
        renderMessages();
        scrollToBottom();

    });

    // Initially hide chatbot popup
    toggleChatbot(false);
});
