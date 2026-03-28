<template>
  <div
    class="flex w-full gap-1.5"
    :class="message.role === 'user' ? 'flex-col items-end' : 'items-start'"
  >
    <BotIcon v-if="message.role !== 'user'" />

    <div v-if="message.role !== 'user'" class="flex min-w-0 max-w-[calc(100%-2.5rem)] flex-1 flex-col max-[600px]:max-w-[calc(100%-2.25rem)]">
      <div
        v-if="isLoadingStatus"
        class="inline-flex min-h-9.5 min-w-16 items-center justify-center gap-2 rounded-[10px_10px_10px_3px] bg-brand-50 px-4 py-3"
        role="status"
        aria-live="polite"
        :aria-label="loaderLabel"
      >
        <span class="h-2 w-2 animate-dot-wave rounded-full bg-brand-500 [animation-delay:0ms]"></span>
        <span class="h-2 w-2 animate-dot-wave rounded-full bg-brand-500 [animation-delay:200ms]"></span>
        <span class="h-2 w-2 animate-dot-wave rounded-full bg-brand-500 [animation-delay:400ms]"></span>
      </div>
      <div
        v-else
        class="w-fit max-w-full overflow-x-auto whitespace-pre-line rounded-[10px_10px_10px_3px] bg-brand-50 px-4 py-3 text-xs leading-relaxed wrap-anywhere text-black"
        v-html="message.text"
      ></div>
    </div>

    <p
      v-else
      class="w-fit max-w-[85%] whitespace-pre-line rounded-[13px_13px_3px_13px] bg-brand-500 px-4 py-3 text-[11px] leading-relaxed wrap-anywhere text-white max-[600px]:max-w-[88%]"
    >
      {{ message.text }}
    </p>
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
