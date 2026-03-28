<template>
  <form class="chat-form" autocomplete="off" @submit.prevent="handleSubmit">
    <input
      ref="inputRef"
      type="text"
      class="message-input"
      :placeholder="placeholder"
      required
    />
    <button type="submit" id="chatbot-send-btn" title="Send">
      <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor" aria-hidden="true">
        <path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.59 5.58L20 12l-8-8-8 8z"/>
      </svg>
    </button>
  </form>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
  placeholder: {
    type: String,
    default: 'Message...',
  },
})

const emit = defineEmits(['submit'])
const inputRef = ref(null)

function handleSubmit() {
  const text = inputRef.value?.value.trim()
  if (!text) return
  emit('submit', text)
  inputRef.value.value = ''
}
</script>
