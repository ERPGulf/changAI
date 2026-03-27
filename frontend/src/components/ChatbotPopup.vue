<template>
  <div class="chatbot-popup" :class="{ show: isOpen }">
    <ChatHeader @close="$emit('close')" />
    <TabBar v-model="localTab" />

    <div class="chat-body" ref="chatBodyRef">
      <div>
        <ChatTab v-if="localTab === 'chat'" :messages="chatHistory" />
        <DebugTab v-else-if="localTab === 'debug'" :logs="debugLogs" />
        <SupportTab v-else-if="localTab === 'support'" :messages="supportHistory" />
      </div>
    </div>

    <div class="chat-footer">
      <ChatForm
        :placeholder="localTab === 'support' ? 'Message Support...' : 'Message...'"
        @submit="(text) => $emit('submit', text)"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, watch, nextTick } from 'vue'
import ChatHeader from './ChatHeader.vue'
import TabBar from './TabBar.vue'
import ChatTab from './ChatTab.vue'
import DebugTab from './DebugTab.vue'
import SupportTab from './SupportTab.vue'
import ChatForm from './ChatForm.vue'

const props = defineProps({
  isOpen: { type: Boolean, required: true },
  activeTab: { type: String, required: true },
  chatHistory: { type: Array, required: true },
  debugLogs: { type: Array, required: true },
  supportHistory: { type: Array, required: true },
})

const emit = defineEmits(['close', 'submit', 'update:activeTab'])

const chatBodyRef = ref(null)
const localTab = ref(props.activeTab)

watch(() => props.activeTab, (val) => { localTab.value = val })
watch(localTab, (val) => { emit('update:activeTab', val) })

defineExpose({
  scrollToBottom() {
    nextTick(() => {
      const el = chatBodyRef.value
      if (el) el.scrollTo({ top: el.scrollHeight, behavior: 'smooth' })
    })
  },
})
</script>
