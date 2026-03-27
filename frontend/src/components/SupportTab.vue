<template>
  <div>
    <p v-if="messages.length === 0" class="message-text">Send a message to Support.</p>
    <ChatMessage v-for="(msg, i) in messages" :key="i" :message="msg" />
  </div>
</template>

<script setup>
import ChatMessage from './ChatMessage.vue'

defineProps({
  messages: {
    type: Array,
    required: true,
  },
})
</script>
