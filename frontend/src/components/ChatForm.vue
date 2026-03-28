<template>
  <form
    class="flex min-h-11 items-center gap-2 rounded-full border border-violet-200 bg-white px-3 shadow-sm transition-all focus-within:ring-2 focus-within:ring-brand-500/35"
    autocomplete="off"
    @submit.prevent="handleSubmit"
  >
    <input
      type="text"
      v-model="messageText"
      class="h-11 w-full border-none bg-transparent text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none"
      :placeholder="placeholder"
      required
    />
    <button
      type="submit"
      title="Send"
      class="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-brand-500 text-white transition-all hover:bg-brand-600 disabled:cursor-not-allowed disabled:opacity-40"
      :disabled="!messageText.trim()"
    >
      <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" aria-hidden="true">
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
const messageText = ref('')

function handleSubmit() {
  const text = messageText.value.trim()
  if (!text) return
  emit('submit', text)
  messageText.value = ''
}
</script>
