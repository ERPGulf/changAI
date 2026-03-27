<template>
  <div class="tab_box">
    <button
      v-for="tab in tabs"
      :key="tab.id"
      class="tab_btn"
      :class="{ active: modelValue === tab.id }"
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
