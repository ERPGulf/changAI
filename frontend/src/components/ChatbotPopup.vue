<template>
  <div
    :class="popupClasses"
  >
    <ChatHeader
      :windowMode="windowMode"
      :autoReadEnabled="autoReadEnabled"
      @close="$emit('close')"
      @resizeDefault="windowMode = 'default'"
      @resizeHalf="windowMode = 'half'"
      @resizeFull="windowMode = 'full'"
      @toggleAutoRead="$emit('toggleAutoRead')"
    />
    <TabBar v-model="localTab" />

    <div class="min-h-0 flex-1 overflow-x-hidden overflow-y-auto bg-white p-4 max-[900px]:p-3.5 max-[600px]:p-3" ref="chatBodyRef">
      <div class="min-w-0">
        <ChatTab v-if="localTab === 'chat'" :messages="chatHistory" :autoReadEnabled="autoReadEnabled" />
        <DebugTab v-else-if="localTab === 'debug'" :logs="debugLogs" />
        <SupportTab v-else-if="localTab === 'support'" :messages="supportHistory" :autoReadEnabled="autoReadEnabled" />
      </div>
    </div>

    <div class="border-t border-violet-100 bg-white p-3 pb-[calc(12px+env(safe-area-inset-bottom))] sm:p-4">
      <ChatForm
        :placeholder="localTab === 'support' ? 'Message Support...' : 'Message...'"
        @submit="(text) => $emit('submit', text)"
      />
    </div>
  </div>
</template>

<script setup>
import { computed, ref, watch, nextTick } from 'vue'
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
  autoReadEnabled: { type: Boolean, required: true },
})

const emit = defineEmits(['close', 'submit', 'update:activeTab', 'toggleAutoRead'])

const chatBodyRef = ref(null)
const localTab = ref(props.activeTab)
const windowMode = ref('default')

const popupClasses = computed(() => {
  const base = 'fixed z-[9999] flex min-h-0 flex-col overflow-hidden bg-white shadow-[0_0_128px_rgba(0,0,0,0.1),0_32px_64px_-48px_rgba(0,0,0,0.5)] transition-all duration-150 ease-out origin-bottom-right'
  const state = props.isOpen
    ? 'pointer-events-auto opacity-100 translate-x-0 translate-y-0 scale-100'
    : 'pointer-events-none opacity-0 translate-x-1/2 translate-y-full scale-0'

  if (windowMode.value === 'full') {
    return [
      base,
      state,
      'inset-0 h-screen w-screen max-h-screen max-w-screen rounded-none origin-center',
    ]
  }

  if (windowMode.value === 'half') {
    return [
      base,
      state,
      'bottom-[74px] right-5 h-[min(86vh,860px)] w-[min(50vw,860px)] rounded-2xl',
      'max-[900px]:bottom-[78px] max-[900px]:right-3 max-[900px]:h-[min(86vh,760px)] max-[900px]:w-[min(70vw,760px)] max-[900px]:rounded-[14px]',
      'max-[600px]:inset-0 max-[600px]:h-screen max-[600px]:w-screen max-[600px]:max-h-screen max-[600px]:max-w-screen max-[600px]:rounded-none max-[600px]:pb-[env(safe-area-inset-bottom)]',
    ]
  }

  return [
    base,
    state,
    'bottom-[74px] right-5 h-[min(560px,72vh)] w-[min(360px,calc(100vw-40px))] rounded-2xl',
    'max-[900px]:bottom-[78px] max-[900px]:right-3 max-[900px]:h-[min(70vh,540px)] max-[900px]:w-[min(360px,calc(100vw-24px))] max-[900px]:rounded-[14px]',
    'max-[600px]:inset-0 max-[600px]:h-screen max-[600px]:w-screen max-[600px]:max-h-screen max-[600px]:max-w-screen max-[600px]:rounded-none max-[600px]:pb-[env(safe-area-inset-bottom)]',
  ]
})

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
