<!-- ChatForm.vue -->
<template>
  <form class="chat-form" @submit.prevent="handleFormSubmit">
    <input
      ref="inputRef"
      type="text"
      placeholder="Message..."
      class="message-input"
      required
    />
    <button class="material-symbols-rounded" type="submit">arrow_upward</button>
  </form>
</template>

<script setup>
import { ref } from 'vue'
const props = defineProps({
  setChatHistory: Function,
})

const inputRef = ref(null)
const handleFormSubmit = () => {
  const userMessage = inputRef.value?.value.trim()
  if (!userMessage) return
  props.setChatHistory(userMessage)
  inputRef.value.value = ''
}
</script>
