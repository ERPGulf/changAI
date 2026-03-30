<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue'
import ChatbotToggler from './components/ChatbotToggler.vue'
import ChatbotPopup from './components/ChatbotPopup.vue'
import { runPipeline, callSupportBot, getSettingsDetails } from './utils/frappe.js'
import { getOrCreateChatId } from './utils/session.js'
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

async function loadSettings() {
  if (isLoadingSettings.value || settings.value) return

  isLoadingSettings.value = true
  try {
    settings.value = await getSettingsDetails(responseMode.value)
    console.log('get_settings response:', settings.value)
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

  const thinkingMsg = reactive({ role: 'model', text: 'Thinking...' })
  chatHistory.value.push(thinkingMsg)
  await nextTick()
  scrollToBottom()

  try {
    const response = await runPipeline(message, getOrCreateChatId(), responseMode.value)
    thinkingMsg.text = normalizeBotText(response?.Bot)?.trim() || 'No response.'
    debugLogs.value.push({ user: message, response })
  } catch (err) {
    const errorText = getErrorText(err)
    console.error('ChangAI API Error:', err)
    thinkingMsg.text = '⚠️ Something went wrong. Please try again.'
    debugLogs.value.push({ user: message, error: errorText })
  }

  await nextTick()
  scrollToBottom()
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
  if (responseMode.value === 'actual') {
    loadSettings()
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
    @close="showChatbot = false"
    @submit="handleSubmit"
    @toggleAutoRead="toggleAutoRead"
  />
</template>
