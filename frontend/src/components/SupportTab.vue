<template>
  <div class="flex flex-col gap-4 sm:gap-5">
    <p v-if="messages.length === 0" class="chat-card motion-safe:animate-fade-rise rounded-lg px-4 py-3 text-xs text-slate-900">Send a message to Support.</p>
    <ChatMessage v-for="(msg, i) in messages" :key="i" :message="msg" :autoReadEnabled="autoReadEnabled" :ttsConfig="ttsConfig" />
  </div>
</template>

<script setup>
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
  ttsConfig: {
    type: Object,
    required: true,
  },
})
</script>
