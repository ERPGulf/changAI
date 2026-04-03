<template>
  <div class="flex gap-1.5 border-b border-slate-200/80 px-2.5 pb-2.5 pt-1">
    <button
      v-for="tab in tabs"
      :key="tab.id"
      class="group min-w-0 flex-1 h-9 appearance-none rounded-lg border border-transparent bg-transparent px-2 text-xs font-semibold transition-all duration-200 focus:outline-none"
      :class="modelValue === tab.id ? 'border-white/30 bg-linear-to-r from-violet-300/36 via-indigo-300/30 to-sky-300/28 text-white shadow-[0_4px_10px_rgba(20,24,40,0.22)]' : 'text-white/80 hover:border-white/25 hover:bg-white/12 hover:text-white'"
      @click="$emit('update:modelValue', tab.id)"
    >
      <span class="inline-flex items-center gap-1.5">
        <span
          class="h-1.5 w-1.5 rounded-full transition-colors duration-200"
          :class="modelValue === tab.id ? 'bg-white' : 'bg-white/40 group-hover:bg-white/70'"
        ></span>
        {{ tab.label }}
      </span>
    </button>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: {
    type: String,
    required: true,
  },
  debugEnabled: {
    type: Boolean,
    default: false,
  },
})

defineEmits(['update:modelValue'])

const tabs = computed(() => {
  const allTabs = [
    { id: 'chat', label: 'Chats' },
    { id: 'debug', label: 'Debug' },
    { id: 'support', label: 'Support' },
    { id: 'settings', label: 'Settings' },
  ]

  return props.debugEnabled
    ? allTabs
    : allTabs.filter(tab => tab.id !== 'debug')
})
</script>