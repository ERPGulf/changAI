<template>
  <div class="messageCon" :class="message.role === 'user' ? 'user-message' : 'bot-message'">
    <BotIcon v-if="message.role !== 'user'" />

    <div v-if="message.role !== 'user'" class="message-text-container">
      <div v-if="isLoadingStatus" class="typing-loader" role="status" aria-live="polite" :aria-label="loaderLabel">
        <span class="typing-dot"></span>
        <span class="typing-dot"></span>
        <span class="typing-dot"></span>
      </div>
      <p v-else class="message-text" v-html="message.text"></p>
    </div>

    <p v-else class="message-text">{{ message.text }}</p>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import BotIcon from './BotIcon.vue'

const props = defineProps({
  message: {
    type: Object,
    required: true,
  },
  autoReadEnabled: {
    type: Boolean,
    default: false,
  },
})

const isSpeaking = ref(false)

const speechSupported = computed(() => (
  typeof window !== 'undefined' &&
  'speechSynthesis' in window &&
  'SpeechSynthesisUtterance' in window
))

function getSpeakableText(raw) {
  if (typeof raw !== 'string') return ''
  if (!raw.includes('<')) return raw.trim()

  const parser = new DOMParser()
  const doc = parser.parseFromString(raw, 'text/html')
  return (doc.body.textContent || '').replace(/\s+/g, ' ').trim()
}

function stopSpeech() {
  if (!speechSupported.value) return
  window.speechSynthesis.cancel()
  isSpeaking.value = false
}

function speakText(text) {
  if (!speechSupported.value || !text) return

  window.dispatchEvent(new CustomEvent('changai-tts-stop'))
  window.speechSynthesis.cancel()

  const utterance = new SpeechSynthesisUtterance(text)
  utterance.rate = 1
  utterance.pitch = 1
  utterance.onend = () => {
    isSpeaking.value = false
  }
  utterance.onerror = () => {
    isSpeaking.value = false
  }

  isSpeaking.value = true
  window.speechSynthesis.speak(utterance)
}

function handleGlobalStop() {
  isSpeaking.value = false
}

function isPlaceholderStatus(text) {
  return text === 'Thinking...' || text === 'Sending to support...'
}

const normalizedMessageText = computed(() => getSpeakableText(props.message?.text || ''))

const isLoadingStatus = computed(() => (
  props.message?.role !== 'user' && isPlaceholderStatus(normalizedMessageText.value)
))

const loaderLabel = computed(() => (
  normalizedMessageText.value === 'Sending to support...' ? 'Sending to support' : 'Thinking'
))

watch(
  () => props.message.text,
  (newText, oldText) => {
    if (!props.autoReadEnabled) return
    if (props.message.role === 'user') return

    const speakable = getSpeakableText(newText)
    if (!speakable || isPlaceholderStatus(speakable)) return

    const oldSpeakable = getSpeakableText(oldText || '')
    if (speakable === oldSpeakable) return

    speakText(speakable)
  },
)

onMounted(() => {
  if (typeof window !== 'undefined') {
    window.addEventListener('changai-tts-stop', handleGlobalStop)
  }
})

onBeforeUnmount(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('changai-tts-stop', handleGlobalStop)
  }
  if (isSpeaking.value) {
    stopSpeech()
  }
})
</script>
