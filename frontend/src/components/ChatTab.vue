<template>
  <div>
    <div class="flex items-start gap-1.5">
      <BotIcon />
      <p class="max-w-[75%] whitespace-pre-line rounded-[10px_10px_10px_3px] bg-brand-50 px-4 py-3 text-xs leading-relaxed text-black">
        Hello there &#x1F44B; I am ChangAI, your ERP assistant
      </p>
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
