<script setup>
import ChatMessage from './components/ChatMessage.vue';
import ChatbotHeader from './components/ChatbotHeader.vue';
import ChatForm from './components/ChatForm.vue';
import ChatbotIcon from './components/ChatbotIcon.vue';
import { ref, watch, nextTick } from 'vue'

const chatBodyRef = ref(null) 
const showChatbot=ref(false)
const chatHistory = ref([])
const activeTab = ref("chat")
const debugLogs = ref([])
const generateBotResponse = async (history, userMsg) => {
const updateHistory = (text) => {
  chatHistory.value = [
    ...chatHistory.value.filter(msg => msg.text !== "Thinking..."),
    { role: "model", text }
  ]
}

  const requestOptions = {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      qstn: userMsg,
    })
  }

  try {
    const response = await fetch(import.meta.env.VITE_API_URL, requestOptions)
    const data = await response.json()


    if (!response.ok) {
      console.error("Backend Error Response:", data)
      throw new Error(data.message?.error || "Something went wrong!!")
        }
        let responseText = "";

        if (data.message?.response) {
            responseText = data.message.response;
        } else if (data.message?.query_data) {
            responseText = data.message.query_data;
        } else {
            responseText = "No valid response from server.";
        }
    updateHistory(responseText);
    debugLogs.value.push({
                user: userMsg,
                response: responseText,
                doctype: data.message?.doctype,
                top_fields: data.message?.top_fields,
                fields: data.message?.fields,
                query: data.message?.query,
                data: data.message?.data
    })
    await scrollToBottom();

  } catch (error) {
    console.error("API Error:", error)
    chatHistory.value = [
    ...chatHistory.value.filter(msg => msg.text !== "Thinking..."),
    {
      role: "model",
      text: error
    }
  ]
      debugLogs.value.push({
      user: userMsg,
      error: error.message
    })
  }
}

const setChatHistory = async (message) => {
  chatHistory.value.push({
    role: 'user',
    text: message
  })
await nextTick();            // wait for the message to render
scrollToBottom(); 
setTimeout(() => {
    chatHistory.value.push({
      role: 'model',
      text: 'Thinking...'
    })
    scrollToBottom(); 
    generateBotResponse([...chatHistory.value, { role: 'user', text: message }], message)
  }, 600)
}

const scrollToBottom = async () => {
  await nextTick()
  if (chatBodyRef.value) {
    chatBodyRef.value.scrollTo({
      top: chatBodyRef.value.scrollHeight,
      behavior: 'smooth'
    })
  }
}


</script>
<template>
  <div :class="['app-container', { 'show-chatbot': showChatbot }]">

  <button @click="showChatbot = !showChatbot" id="chatbot-toggler">
        <span v-if="!showChatbot" class="material-symbols-rounded">mode_comment</span>
        <span v-else class="material-symbols-rounded">close</span>
  </button>
    <div class="chatbot-popup">
      <!-- ChatBot Header --> 
        <ChatbotHeader :showChatbot="showChatbot" @toggle="showChatbot = !showChatbot" />
        <div class="tab_box">
          <button class="tab_btn"     
          :class="{ active: activeTab === 'chat' }"
          @click="activeTab = 'chat'"
          >
          Chat
        </button>
          <button class="tab_btn"
          :class="{ active: activeTab === 'debug' }"
          @click="activeTab = 'debug'"
          >Debug</button>
        </div>
      <div class="chat-body" ref="chatBodyRef">
        <div v-if="activeTab === 'chat'">
          <div class="messageCon bot-message">
            <ChatbotIcon />
            <p class="message-text">
              Hello there!<br/> Iam ChangAI, your AI assistant.
            </p>
          </div>
          <ChatMessage
            v-for="(msg, index) in chatHistory"
            :key="index"
            :chat="msg"
          /> 
</div>
        <div v-else-if="activeTab === 'debug'">
            <div v-if="debugLogs.length > 0">
            <div v-for="(log, index) in debugLogs" :key="index" class="debug-query">
            <pre class="message-text">{{ JSON.stringify(log, null, 2) }}</pre>
            </div>
            </div>
            <p v-else class="message-text">No debug data yet.</p>
            </div>
</div> 

        <!-- ChatBot Footer -->
         <div class="chat-footer" >
          <ChatForm :setChatHistory="setChatHistory"/>
         </div>
        
    </div>
</div>
</template>
