<template>
  <div class="flex flex-col gap-4 sm:gap-5">
    <div class="motion-safe:animate-fade-rise flex w-full items-start gap-1.5">
      <BotIcon />
      <p class="w-fit max-w-[calc(100%-2.5rem)] whitespace-pre-line rounded-[10px_10px_10px_3px] bg-brand-50 px-4 py-3 text-xs leading-relaxed wrap-anywhere text-slate-900 max-[600px]:max-w-[calc(100%-2.25rem)]">
        Hello there &#x1F44B; I am ChangAI, your ERP assistant
      </p>
    </div>
    <ChatMessage
      v-for="(msg, i) in messages"
      :key="i"
      :message="msg"
      :autoReadEnabled="autoReadEnabled"
      :ttsConfig="ttsConfig"
    />
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
  ttsConfig: {
    type: Object,
    required: true,
  },
})
</script>
