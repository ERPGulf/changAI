<template>
  <div class="relative w-full">
    <form
      class="group flex min-h-11 items-center gap-2 rounded-full border border-slate-200/90 bg-white/95 px-3 shadow-[0_12px_26px_-20px_rgba(15,23,42,0.7)] transition-all duration-250 focus-within:-translate-y-0.5 focus-within:border-brand-200 focus-within:shadow-[0_18px_30px_-20px_rgba(13,110,253,0.5)] focus-within:ring-2 focus-within:ring-brand-500/25"
      style="border-radius: 9999px;"
      autocomplete="off"
      @submit.prevent="handleSubmit"
      @click.stop
      @mousedown.stop
      @keydown.stop
      @keyup.stop
    >
      <input
        ref="inputRef"
        type="text"
        v-model="messageText"
        class="h-11 w-full border-none bg-transparent text-sm font-medium text-slate-800 placeholder:text-slate-400 focus:outline-none disabled:cursor-not-allowed disabled:opacity-50"
        :placeholder="disabled ? 'Waiting for response...' : placeholder"
        :disabled="disabled"
        required
        @keydown.stop
        @keyup.stop
        @keypress.stop
        @input.stop
      />

      <button
        type="button"
        class="grid h-8 w-8 shrink-0 appearance-none place-items-center rounded-full border border-transparent text-slate-600 transition-all duration-200 hover:-translate-y-0.5 hover:border-slate-200 hover:bg-slate-100 hover:text-slate-900 focus:outline-none disabled:cursor-not-allowed disabled:opacity-40"
        style="border-radius: 9999px;"
        :class="isListening ? 'border-red-200 bg-red-100 text-red-600 shadow-[0_10px_20px_-18px_rgba(220,38,38,0.9)] hover:bg-red-100 hover:text-red-600' : ''"
        :title="micButtonTitle"
        :aria-label="micButtonTitle"
        :disabled="disabled || !recognitionSupported || requestingMic"
        @click="toggleVoiceInput"
      >
        <!-- Stop icon while listening -->
        <svg v-if="isListening && !requestingMic" viewBox="0 0 24 24" width="16" height="16" fill="currentColor" aria-hidden="true">
          <rect x="6" y="6" width="12" height="12" rx="2"/>
        </svg>
        <!-- Mic icon when idle -->
        <svg v-else-if="!requestingMic" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <path d="M12 3a3 3 0 0 0-3 3v6a3 3 0 0 0 6 0V6a3 3 0 0 0-3-3z"/>
          <path d="M19 10v2a7 7 0 0 1-14 0v-2"/>
          <path d="M12 19v3"/>
        </svg>
        <!-- Spinner while requesting permission -->
        <svg v-else viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true" class="animate-spin">
          <circle cx="12" cy="12" r="9" opacity="0.3"/>
          <path d="M21 12a9 9 0 0 1-9 9"/>
        </svg>
      </button>

      <button
        type="submit"
        title="Send"
        class="grid h-8 w-8 shrink-0 appearance-none place-items-center rounded-full border-0 bg-gradient-to-br from-brand-500 to-brand-600 text-white shadow-[0_10px_24px_-16px_rgba(109,79,194,0.85)] transition-all duration-200 hover:-translate-y-0.5 hover:from-brand-600 hover:to-violet-700 focus:outline-none disabled:cursor-not-allowed disabled:opacity-40"
        style="border-radius: 9999px;"
        :disabled="disabled || !messageText.trim()"
      >
        <svg viewBox="0 0 24 24" width="16" height="16" fill="currentColor" aria-hidden="true">
          <path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.59 5.58L20 12l-8-8-8 8z"/>
        </svg>
      </button>
    </form>

    <StatusToast
      :visible="toastVisible"
      :message="toastMessage"
      :type="toastType"
      :dismissible="toastType !== 'listening'"
      @close="hideToast"
    />
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import StatusToast from './StatusToast.vue'

defineProps({
  placeholder: {
    type: String,
    default: 'Message...',
  },
  disabled: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['submit'])
const messageText = ref('')
const inputRef = ref(null)
const isListening = ref(false)
const recognitionSupported = ref(false)
const requestingMic = ref(false)
const micPermissionGranted = ref(false)
const toastVisible = ref(false)
const toastMessage = ref('')
const toastType = ref('info')
const micUnavailableReason = ref('Voice input is unavailable in this browser/context.')

let recognition = null
let toastTimer = null
const toastKey = ref('')
const submitOnVoiceStop = ref(false)

const micButtonTitle = computed(() => {
  if (requestingMic.value) return 'Requesting microphone permission...'
  if (!recognitionSupported.value) return 'Voice input is unavailable in this browser/context'
  return isListening.value ? 'Stop voice input' : 'Start voice input'
})

function getSpeechRecognitionCtor() {
  if (typeof window === 'undefined') return null
  return window.SpeechRecognition || window.webkitSpeechRecognition || null
}

function initSpeechRecognition() {
  const SpeechRecognitionCtor = getSpeechRecognitionCtor()
  const hasSecureContext = typeof window !== 'undefined' ? window.isSecureContext : false
  const hasMediaDevices = typeof navigator !== 'undefined' && Boolean(navigator.mediaDevices?.getUserMedia)
  recognitionSupported.value = Boolean(SpeechRecognitionCtor && hasSecureContext && hasMediaDevices)

  if (!hasSecureContext) {
    micUnavailableReason.value = 'Voice input requires HTTPS (or localhost).'
  } else if (!hasMediaDevices || !SpeechRecognitionCtor) {
    micUnavailableReason.value = 'Voice input is not supported in this browser.'
  }

  if (!SpeechRecognitionCtor) return
  if (!recognitionSupported.value) return

  recognition = new SpeechRecognitionCtor()
  recognition.continuous = true
  recognition.interimResults = true
  recognition.lang = (typeof navigator !== 'undefined' && navigator.language) || 'en-US'

  recognition.onstart = () => {
    isListening.value = true
    showToast('Listening... Tap mic to stop', 'listening', { persistent: true, key: 'listening' })
  }

  recognition.onend = () => {
    isListening.value = false
    if (toastKey.value === 'listening') {
      hideToast()
    }

    if (submitOnVoiceStop.value) {
      submitOnVoiceStop.value = false
      handleSubmit()
    }
  }

  recognition.onerror = (event) => {
    isListening.value = false
    submitOnVoiceStop.value = false
    if (event?.error === 'not-allowed' || event?.error === 'service-not-allowed') {
      showToast('Microphone permission denied. Please allow microphone access in browser settings.', 'error')
      return
    }

    if (event?.error === 'audio-capture') {
      showToast('No microphone detected. Please connect a microphone and try again.', 'error')
      return
    }

    if (event?.error === 'no-speech') {
      showToast('No speech detected. Try speaking a bit louder.', 'info')
      return
    }

    showToast('Voice input failed. Please try again.', 'error')
  }

  recognition.onresult = (event) => {
    let transcript = ''
    for (let i = event.resultIndex; i < event.results.length; i += 1) {
      transcript += event.results[i][0].transcript
    }
    messageText.value = transcript.trimStart()
  }
}

function toggleVoiceInput() {
  if (!recognitionSupported.value || !recognition) {
    showToast(micUnavailableReason.value, 'error')
    return
  }

  if (isListening.value) {
    submitOnVoiceStop.value = true
    recognition.stop()
    return
  }

  startVoiceInput()
}

async function ensureMicPermission() {
  if (micPermissionGranted.value) return true
  if (!navigator.mediaDevices?.getUserMedia) {
    showToast('Microphone API is unavailable in this browser.', 'error')
    return false
  }

  requestingMic.value = true
  showToast('Requesting microphone permission...', 'info', { persistent: true, key: 'requesting' })

  try {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    stream.getTracks().forEach((track) => track.stop())
    micPermissionGranted.value = true
    return true
  } catch (err) {
    if (err?.name === 'NotAllowedError' || err?.name === 'SecurityError') {
      showToast('Microphone permission denied. Please allow it and try again.', 'error')
    } else if (err?.name === 'NotFoundError') {
      showToast('No microphone found on this device.', 'error')
    } else {
      showToast('Unable to access microphone. Please check browser permissions.', 'error')
    }
    return false
  } finally {
    requestingMic.value = false
    if (toastKey.value === 'requesting') {
      hideToast()
    }
  }
}

async function startVoiceInput() {
  const allowed = await ensureMicPermission()
  if (!allowed || !recognition) return

  submitOnVoiceStop.value = false
  inputRef.value?.focus()
  recognition.start()
}

function showToast(message, type = 'info', options = {}) {
  const { duration = 4200, persistent = false, key = '' } = options
  toastMessage.value = message
  toastType.value = type
  toastKey.value = key
  toastVisible.value = true

  if (toastTimer) clearTimeout(toastTimer)
  if (!persistent) {
    toastTimer = setTimeout(() => {
      toastVisible.value = false
      toastKey.value = ''
    }, duration)
  }
}

function hideToast() {
  toastVisible.value = false
  toastKey.value = ''
  if (toastTimer) {
    clearTimeout(toastTimer)
    toastTimer = null
  }
}

function handleSubmit() {
  const text = messageText.value.trim()
  if (!text) return

  if (isListening.value && recognition) {
    recognition.stop()
  }

  emit('submit', text)
  messageText.value = ''
}

onMounted(() => {
  initSpeechRecognition()
})

onBeforeUnmount(() => {
  if (recognition && isListening.value) {
    submitOnVoiceStop.value = false
    recognition.stop()
  }

  hideToast()
})
</script>
