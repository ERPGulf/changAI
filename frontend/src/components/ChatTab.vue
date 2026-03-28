<template>
  <div>
    <div class="messageCon bot-message">
      <BotIcon />
      <p class="message-text">Hello there &#x1F44B; I am ChangAI, your ERP assistant</p>
    </div>
    <ChatMessage v-for="(msg, i) in messages" :key="i" :message="msg" :autoReadEnabled="autoReadEnabled" />
  </div>
</template>

<script setup>
import BotIcon from './BotIcon.vue'
import ChatMessage from './ChatMessage.vue'

defineProps({
  messages: {
    type: Array,
    required: true,
  },
  autoReadEnabled: {
    type: Boolean,
    default: false,
  },
})
</script>
