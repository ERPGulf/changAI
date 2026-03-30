<template>
  <div class="flex gap-1.5 border-b border-slate-200/85 bg-white/90 px-2 py-2 backdrop-blur-sm">
    <button
      v-for="tab in tabs"
      :key="tab.id"
      class="group min-w-0 flex-1 h-9 appearance-none rounded-lg border border-transparent bg-transparent px-2 text-xs font-semibold transition-all duration-200 focus:outline-none"
      :class="modelValue === tab.id ? 'border-brand-200 bg-brand-50 text-brand-600 shadow-sm' : 'text-slate-500 hover:border-slate-200 hover:bg-slate-50 hover:text-slate-700'"
      @click="$emit('update:modelValue', tab.id)"
    >
      <span class="inline-flex items-center gap-1.5">
        <span
          class="h-1.5 w-1.5 rounded-full transition-colors duration-200"
          :class="modelValue === tab.id ? 'bg-brand-500' : 'bg-slate-300 group-hover:bg-slate-400'"
        ></span>
        {{ tab.label }}
      </span>
    </button>
  </div>
</template>

<script setup>
defineProps({
  modelValue: {
    type: String,
    required: true,
  },
})

defineEmits(['update:modelValue'])

const tabs = [
  { id: 'chat', label: 'Chats' },
  { id: 'debug', label: 'Debug' },
  { id: 'support', label: 'Support' },
  { id: 'settings', label: 'Settings' },
]
</script>
