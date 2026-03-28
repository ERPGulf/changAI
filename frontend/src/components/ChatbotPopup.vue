<template>
  <div
    class="chatbot-popup flex flex-col overflow-hidden"
    :class="{
      show: isOpen,
      'mode-half': windowMode === 'half',
      'mode-full': windowMode === 'full',
    }"
  >
    <ChatHeader
      :windowMode="windowMode"
      :responseMode="responseMode"
      @close="$emit('close')"
      @resizeHalf="windowMode = 'half'"
      @resizeFull="windowMode = 'full'"
      @toggleResponseMode="$emit('toggleResponseMode')"
    />
    <TabBar v-model="localTab" />

    <div class="chat-body min-h-0 flex-1 overflow-y-auto p-3 sm:p-4" ref="chatBodyRef">
      <div>
        <ChatTab v-if="localTab === 'chat'" :messages="chatHistory" />
        <DebugTab v-else-if="localTab === 'debug'" :logs="debugLogs" />
        <SupportTab v-else-if="localTab === 'support'" :messages="supportHistory" />
      </div>
    </div>

    <div class="mt-auto border-t border-violet-100 bg-white p-3 pb-[calc(12px+env(safe-area-inset-bottom))] sm:p-4">
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
  responseMode: { type: String, required: true },
})

const emit = defineEmits(['close', 'submit', 'update:activeTab', 'toggleResponseMode'])

const chatBodyRef = ref(null)
const localTab = ref(props.activeTab)
const windowMode = ref('half')

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
