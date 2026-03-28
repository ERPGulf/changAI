<template>
  <div class="messageCon" :class="message.role === 'user' ? 'user-message' : 'bot-message'">
    <BotIcon v-if="message.role !== 'user'" />
    <p v-if="message.role !== 'user'" class="message-text" v-html="message.text"></p>
    <p v-else class="message-text">{{ message.text }}</p>
  </div>
</template>

<script setup>
import BotIcon from './BotIcon.vue'

defineProps({
  message: {
    type: Object,
    required: true,
  },
})
</script>
