<template>
  <div
    class="motion-safe:animate-fade-rise flex w-full gap-1.5"
    :class="message.role === 'user' ? 'flex-col items-end' : 'items-start'"
  >
    <BotIcon v-if="message.role !== 'user'" />

    <div v-if="message.role !== 'user'" class="flex min-w-0 max-w-[calc(100%-2.5rem)] flex-1 flex-col max-[600px]:max-w-[calc(100%-2.25rem)]">
      <div
        v-if="isLoadingStatus"
        class="flex w-fit flex-col items-start gap-1"
      >
        <div
          class="chat-card inline-flex w-fit rounded-[10px_10px_10px_3px] px-3 py-2"
          role="status"
          aria-live="polite"
          :aria-label="loaderLabel"
        >
          <div class="inline-flex items-center gap-1.5">
            <span class="relative inline-flex h-4 w-4 shrink-0 items-center justify-center">
              <span class="absolute inset-0 rounded-full border border-transparent border-t-[#4b89ff] border-r-[#4b89ff]/70 animate-gemini-arc"></span>
              <svg viewBox="0 0 24 24" class="relative h-3 w-3 text-[#4b89ff] animate-gemini-spark" aria-hidden="true">
                <path fill="currentColor" d="M12 2.8c.52 3.22 1.6 5.66 3.22 7.28 1.62 1.62 4.06 2.7 7.28 3.22-3.22.52-5.66 1.6-7.28 3.22-1.62 1.62-2.7 4.06-3.22 7.28-.52-3.22-1.6-5.66-3.22-7.28-1.62-1.62-4.06-2.7-7.28-3.22 3.22-.52 5.66-1.6 7.28-3.22 1.62-1.62 2.7-4.06 3.22-7.28Z"/>
              </svg>
            </span>
            <span class="text-[8px] font-semibold tracking-[0.12em] uppercase text-[#3a67c9]">{{ loaderLabel }}</span>
          </div>
        </div>

        <button
          v-if="showCancelOnThinking"
          type="button"
          class="group ml-0.5 inline-flex items-center gap-1 text-[9px] font-semibold tracking-[0.07em] text-red-400 transition-all duration-200 hover:translate-x-0.5 hover:text-red-600 focus:outline-none active:scale-95"
          @click="emit('cancel')"
        >
          <svg viewBox="0 0 24 24" width="9" height="9" fill="none" stroke="currentColor" stroke-width="2.5" class="opacity-60 transition-all duration-200 group-hover:opacity-100 group-hover:rotate-90" aria-hidden="true">
            <path d="M18 6L6 18M6 6l12 12"/>
          </svg>
          Cancel
        </button>
      </div>
      <div
        v-else
        class="flex w-fit max-w-full flex-col items-start gap-2"
      >
        <div
          class="chat-card relative w-fit max-w-full whitespace-pre-line rounded-[10px_10px_10px_3px] px-4 py-3 text-xs leading-relaxed wrap-anywhere text-slate-900"
        >
          <div
            class="overflow-x-auto"
            :class="shouldCollapse && !isExpanded ? 'max-h-48 overflow-y-hidden' : ''"
            v-html="message.text"
          ></div>
          <div
            v-if="shouldCollapse && !isExpanded"
            class="pointer-events-none absolute inset-x-0 bottom-0 h-14 rounded-b-[10px] bg-gradient-to-t from-white via-white/92 to-white/0"
            aria-hidden="true"
          ></div>
        </div>

        <div
          v-if="shouldCollapse || showMuteButton"
          class="flex flex-wrap items-center gap-2"
        >
          <button
            v-if="shouldCollapse"
            type="button"
            class="inline-flex items-center rounded-full border border-slate-200 bg-white px-2.5 py-1 text-[10px] font-semibold uppercase tracking-[0.08em] text-slate-600 transition-colors duration-200 hover:border-brand-200 hover:text-brand-600"
            :title="isExpanded ? 'Collapse response' : 'Expand response'"
            :aria-label="isExpanded ? 'Collapse response' : 'Expand response'"
            @click="isExpanded = !isExpanded"
          >
            {{ isExpanded ? 'Collapse' : 'Expand' }}
          </button>

          <button
            v-if="showMuteButton"
            type="button"
            class="inline-flex h-8 w-8 items-center justify-center rounded-full border transition-colors duration-200"
            :class="isMuted ? 'border-red-200 bg-red-50 text-red-600 hover:border-red-300 hover:bg-red-100' : 'border-green-200 bg-green-50 text-green-600 hover:border-green-300 hover:bg-green-100'"
            :title="isMuted ? 'TTS muted' : 'TTS enabled'"
            :aria-label="isMuted ? 'TTS muted' : 'TTS enabled'"
            @click="toggleMute"
          >
            <svg
              viewBox="0 0 24 24"
              width="16"
              height="16"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              aria-hidden="true"
            >
              <path d="M11 5L6 9H3v6h3l5 4V5Z" />
              <path v-if="isMuted" d="M15 9l4 6" />
              <path v-if="isMuted" d="M19 9l-4 6" />
              <path v-else d="M15 10a3 3 0 0 1 0 4" />
              <path v-else d="M17.5 7.5a6 6 0 0 1 0 9" />
            </svg>
          </button>
        </div>
      </div>
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
import { computed, onBeforeUnmount, onMounted, ref, watch, watchEffect } from 'vue'
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
const emit = defineEmits(['cancel'])

const isSpeaking = ref(false)
const currentAudio = ref(null)
const isExpanded = ref(false)
const isMuted = ref(false)
const cancelVisible = ref(false)
let cancelDelayTimer = null

const CANCEL_DELAY_MS = 3000

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

function toggleMute() {
  isMuted.value = !isMuted.value
  if (isMuted.value) {
    stopSpeech()
  }
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

const isThinkingStatus = computed(() => normalizedMessageText.value === 'Thinking...')

const showCancelOnThinking = computed(() => (
  isLoadingStatus.value &&
  isThinkingStatus.value &&
  Boolean(props.message?.cancelable) &&
  cancelVisible.value
))

const shouldCollapse = computed(() => {
  if (props.message?.role === 'user' || isLoadingStatus.value) return false

  const plainText = normalizedMessageText.value
  const lineCount = plainText.split(/\n+/).filter(Boolean).length
  return plainText.length > 520 || lineCount > 8
})

const showMuteButton = computed(() => (
  shouldCollapse.value &&
  props.message?.role !== 'user' &&
  !isLoadingStatus.value &&
  props.ttsConfig?.enableVoiceChat
))

watch(
  () => props.message.text,
  async (newText, oldText) => {
    if (!props.autoReadEnabled) return
    if (props.message.role === 'user') return
    if (isMuted.value) return
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

watch(
  () => props.message.text,
  () => {
    isExpanded.value = false
    isMuted.value = false
  },
)

watchEffect(() => {
  if (isLoadingStatus.value && isThinkingStatus.value && props.message?.cancelable) {
    if (cancelDelayTimer) return
    cancelDelayTimer = setTimeout(() => {
      cancelVisible.value = true
    }, CANCEL_DELAY_MS)
  } else {
    cancelVisible.value = false
    if (cancelDelayTimer) {
      clearTimeout(cancelDelayTimer)
      cancelDelayTimer = null
    }
  }
})

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
  if (cancelDelayTimer) {
    clearTimeout(cancelDelayTimer)
    cancelDelayTimer = null
  }
})
</script>
