<template>
  <button
    class="fixed bottom-5 right-5 z-9999 grid h-12 w-12 place-items-center rounded-full bg-brand-500 text-white transition-all duration-200 hover:bg-brand-600 max-[600px]:bottom-3 max-[600px]:right-3 max-[600px]:h-13 max-[600px]:w-13"
    :aria-pressed="isOpen ? 'true' : 'false'"
    @click="$emit('toggle')"
  >
    <svg v-if="!isOpen" viewBox="0 0 24 24" width="20" height="20" aria-hidden="true">
      <path
        d="M4 4h16a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H8l-4 4v-4H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z"
        fill="currentColor" stroke="currentColor" stroke-width="2"
        stroke-linecap="miter" stroke-linejoin="miter" />
    </svg>
    <svg v-else viewBox="0 0 24 24" width="18" height="18" aria-hidden="true" fill="none">
      <path d="M6 6l12 12M18 6L6 18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
    </svg>
  </button>
</template>

<script setup>
defineProps({
  isOpen: {
    type: Boolean,
    required: true,
  },
})

defineEmits(['toggle'])
</script>
