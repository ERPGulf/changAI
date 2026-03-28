<template>
  <div class="grid grid-cols-3 border-b border-gray-200 bg-white">
    <button
      v-for="tab in tabs"
      :key="tab.id"
      class="h-11 px-2 text-xs font-semibold transition-colors"
      :class="modelValue === tab.id ? 'text-brand-600' : 'text-gray-500 hover:text-gray-700'"
      @click="$emit('update:modelValue', tab.id)"
    >
      {{ tab.label }}
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
]
</script>
