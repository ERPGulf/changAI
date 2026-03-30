<template>
  <div
    class="motion-safe:animate-fade-rise flex w-full gap-1.5"
    :class="message.role === 'user' ? 'flex-col items-end' : 'items-start'"
  >
    <BotIcon v-if="message.role !== 'user'" />

    <div v-if="message.role !== 'user'" class="flex min-w-0 max-w-[calc(100%-2.5rem)] flex-1 flex-col max-[600px]:max-w-[calc(100%-2.25rem)]">
      <div
        v-if="isLoadingStatus"
        class="chat-card inline-flex min-h-9.5 min-w-16 items-center justify-center gap-2 rounded-[10px_10px_10px_3px] px-4 py-3"
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
        class="chat-card w-fit max-w-full overflow-x-auto whitespace-pre-line rounded-[10px_10px_10px_3px] px-4 py-3 text-xs leading-relaxed wrap-anywhere text-slate-900"
        v-html="message.text"
      ></div>
    </div>

    <p
      v-else
      class="w-fit max-w-[85%] whitespace-pre-line rounded-[13px_13px_3px_13px] bg-gradient-to-br from-brand-500 to-brand-600 px-4 py-3 text-[11px] leading-relaxed wrap-anywhere text-white shadow-[0_14px_30px_-18px_rgba(109,79,194,0.85)] max-[600px]:max-w-[88%]"
    >
      {{ message.text }}
    </p>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import BotIcon from './BotIcon.vue'
import { synthesizeTTS } from '../utils/frappe.js'

const props = defineProps({
  message: {
    type: Object,
    required: true,
  },
  autoReadEnabled: {
    type: Boolean,
    default: false,
  },
  ttsConfig: {
    type: Object,
    default: () => ({
      enableVoiceChat: false,
      pollyAvailable: false,
      usePolly: true,
      voiceId: 'Joanna',
    }),
  },
})

const isSpeaking = ref(false)
const currentAudio = ref(null)

const speechSupported = computed(() => (
  typeof window !== 'undefined' &&
  'speechSynthesis' in window &&
  'SpeechSynthesisUtterance' in window
))

function emitTtsProvider(provider) {
  if (typeof window === 'undefined') return
  window.dispatchEvent(new CustomEvent('changai-tts-provider', {
    detail: { provider },
  }))
}

function getSpeakableText(raw) {
  if (typeof raw !== 'string') return ''
  if (!raw.includes('<')) return raw.trim()

  const parser = new DOMParser()
  const doc = parser.parseFromString(raw, 'text/html')
  return (doc.body.textContent || '').replace(/\s+/g, ' ').trim()
}

function stopSpeech() {
  if (speechSupported.value) {
    window.speechSynthesis.cancel()
  }
  if (currentAudio.value) {
    currentAudio.value.pause()
    currentAudio.value.src = ''
    currentAudio.value = null
  }
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
  emitTtsProvider('browser')
  window.speechSynthesis.speak(utterance)
}

async function speakTextWithPolly(text) {
  const ttsResponse = await synthesizeTTS(text, props.ttsConfig?.voiceId || 'Joanna')
  if (!ttsResponse?.ok || !ttsResponse?.audio_base64) {
    throw new Error(ttsResponse?.error || 'Polly synthesis failed')
  }

  window.dispatchEvent(new CustomEvent('changai-tts-stop'))
  stopSpeech()

  const mimeType = ttsResponse?.mime_type || 'audio/mpeg'
  const audio = new Audio(`data:${mimeType};base64,${ttsResponse.audio_base64}`)
  currentAudio.value = audio
  isSpeaking.value = true

  let providerEmitted = false
  audio.onplay = () => {
    providerEmitted = true
    emitTtsProvider('polly')
  }

  audio.onended = () => {
    if (currentAudio.value === audio) {
      currentAudio.value = null
    }
    isSpeaking.value = false
  }

  audio.onerror = () => {
    if (currentAudio.value === audio) {
      currentAudio.value = null
    }
    isSpeaking.value = false
  }

  await audio.play()
  if (!providerEmitted) {
    emitTtsProvider('polly')
  }
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
  async (newText, oldText) => {
    if (!props.autoReadEnabled) return
    if (props.message.role === 'user') return
    if (!props.ttsConfig?.enableVoiceChat) {
      emitTtsProvider('off')
      return
    }

    const speakable = getSpeakableText(newText)
    if (!speakable || isPlaceholderStatus(speakable)) return

    const oldSpeakable = getSpeakableText(oldText || '')
    if (speakable === oldSpeakable) return

    if (props.ttsConfig?.pollyAvailable && props.ttsConfig?.usePolly) {
      try {
        await speakTextWithPolly(speakable)
        return
      } catch (err) {
        console.warn('Polly TTS failed, falling back to browser speech:', err)
      }
    }

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
