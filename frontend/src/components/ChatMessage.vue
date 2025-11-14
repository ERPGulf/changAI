<!-- ChatMessage.vue -->
<script setup>
import ChatbotIcon from './ChatbotIcon.vue'

const props = defineProps({
  chat: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <div class="messageCon" :class="`${chat.role === 'model' ? 'bot' : 'user'}-message`">
    <ChatbotIcon v-if="chat.role === 'model'" />
    <p class="message-text">{{ chat.text }}</p>
  </div>
</template>

