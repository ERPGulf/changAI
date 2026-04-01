<script setup>
import { ref, reactive, nextTick, onMounted, onBeforeUnmount } from 'vue'
import ChatbotToggler from './components/ChatbotToggler.vue'
import ChatbotPopup from './components/ChatbotPopup.vue'
import { runPipelineCancelable, callSupportBot, getSettingsDetails } from './utils/frappe.js'
import { getOrCreateChatId, getPollyPreference, setPollyPreference } from './utils/session.js'
import { normalizeBotText, getErrorText, safeStringify } from './utils/helpers.js'

const showChatbot = ref(false)
const activeTab = ref('chat')
const chatHistory = ref([])
const debugLogs = ref([])
const supportHistory = ref([])
const popupRef = ref(null)
const responseMode = ref('actual')
const autoReadEnabled = ref(true)
const settings = ref(null)
const isLoadingSettings = ref(false)
const ttsConfig = ref({
  enableVoiceChat: false,
  pollyAvailable: false,
  usePolly: true,
  voiceId: 'Joanna',
})
const activeTtsProvider = ref('off')
const cancelPendingChatRequest = ref(null)

function updateProviderFromSettings() {
  if (!ttsConfig.value.enableVoiceChat) {
    activeTtsProvider.value = 'off'
    return
  }
  activeTtsProvider.value = ttsConfig.value.usePolly ? 'polly' : 'browser'
}

function handleTtsProviderEvent(event) {
  const provider = event?.detail?.provider
  if (provider === 'polly' || provider === 'browser' || provider === 'off') {
    activeTtsProvider.value = provider
  }
}

async function loadSettings() {
  if (isLoadingSettings.value || settings.value) return

  isLoadingSettings.value = true
  try {
    settings.value = await getSettingsDetails(responseMode.value)
    ttsConfig.value = {
      enableVoiceChat: Boolean(settings.value?.enable_voice_chat),
      pollyAvailable: Boolean(settings.value?.polly_enabled),
      usePolly: Boolean(settings.value?.polly_enabled) && getPollyPreference(),
      voiceId: settings.value?.polly_voice_id || 'Joanna',
    }
    updateProviderFromSettings()
    debugLogs.value.push({ type: 'settings', settings: settings.value })
  } catch (err) {
    const errorText = getErrorText(err)
    console.error('Settings API Error:', err)
    debugLogs.value.push({ type: 'settings', error: errorText })
  } finally {
    isLoadingSettings.value = false
  }
}

function toggleChatbot() {
  showChatbot.value = !showChatbot.value
}

function scrollToBottom() {
  popupRef.value?.scrollToBottom()
}

function toggleAutoRead() {
  autoReadEnabled.value = !autoReadEnabled.value
}

function togglePollyPreference() {
  const nextValue = !ttsConfig.value.usePolly
  ttsConfig.value = {
    ...ttsConfig.value,
    usePolly: nextValue && ttsConfig.value.pollyAvailable,
  }
  setPollyPreference(ttsConfig.value.usePolly)
  updateProviderFromSettings()
}

async function handleSubmit(message) {
  if (activeTab.value === 'support') {
    await handleSupportSubmit(message)
  } else {
    await handleChatSubmit(message)
  }
}

async function handleChatSubmit(message) {
  if (responseMode.value === 'actual') {
    await loadSettings()
  }

  chatHistory.value.push({ role: 'user', text: message })
  await nextTick()
  scrollToBottom()

  const thinkingMsg = reactive({ role: 'model', text: 'Thinking...', cancelable: true })
  chatHistory.value.push(thinkingMsg)
  await nextTick()
  scrollToBottom()

  let cancelled = false
  const request = runPipelineCancelable(message, getOrCreateChatId(), responseMode.value)
  cancelPendingChatRequest.value = () => {
    if (cancelled) return
    cancelled = true
    request.cancel()
    thinkingMsg.text = 'Cancelled by user.'
    thinkingMsg.cancelable = false
    debugLogs.value.push({ user: message, cancelled: true })
    cancelPendingChatRequest.value = null
  }

  try {
    const response = await request.promise
    if (cancelled) return
    thinkingMsg.cancelable = false
    thinkingMsg.text = normalizeBotText(response?.Bot)?.trim() || 'No response.'
    debugLogs.value.push({ user: message, response })
  } catch (err) {
    if (cancelled) return
    thinkingMsg.cancelable = false
    const errorText = getErrorText(err)
    console.error('ChangAI API Error:', err)
    thinkingMsg.text = '⚠️ Something went wrong. Please try again.'
    debugLogs.value.push({ user: message, error: errorText })
  } finally {
    if (!cancelled) {
      cancelPendingChatRequest.value = null
    }
  }

  await nextTick()
  scrollToBottom()
}

function handleCancelResponse() {
  cancelPendingChatRequest.value?.()
}

async function handleSupportSubmit(message) {
  supportHistory.value.push({ role: 'user', text: message })
  await nextTick()
  scrollToBottom()

  const thinkingMsg = reactive({ role: 'model', text: 'Sending to support...' })
  supportHistory.value.push(thinkingMsg)
  await nextTick()
  scrollToBottom()

  try {
    const response = await callSupportBot(message, responseMode.value)
    thinkingMsg.text = response ? safeStringify(response) : 'Support request sent successfully.'
  } catch (err) {
    console.error('Support API Error:', err)
    thinkingMsg.text = '⚠️ Failed to reach support. Please try again.'
  }

  await nextTick()
  scrollToBottom()
}

onMounted(() => {
  if (typeof window !== 'undefined') {
    window.addEventListener('changai-tts-provider', handleTtsProviderEvent)
  }

  if (responseMode.value === 'actual') {
    loadSettings()
  }
})

onBeforeUnmount(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('changai-tts-provider', handleTtsProviderEvent)
  }
})
</script>

<template>
  <ChatbotToggler :isOpen="showChatbot" @toggle="toggleChatbot" />
  <ChatbotPopup
    ref="popupRef"
    :isOpen="showChatbot"
    v-model:activeTab="activeTab"
    :chatHistory="chatHistory"
    :debugLogs="debugLogs"
    :supportHistory="supportHistory"
    :autoReadEnabled="autoReadEnabled"
    :ttsConfig="ttsConfig"
    :activeTtsProvider="activeTtsProvider"
    :settings="settings"
    @close="showChatbot = false"
    @submit="handleSubmit"
    @cancelResponse="handleCancelResponse"
    @toggleAutoRead="toggleAutoRead"
    @togglePollyPreference="togglePollyPreference"
  />
</template>
