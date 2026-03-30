<template>
  <button
    class="fixed bottom-5 right-5 z-9999 grid h-12 w-12 appearance-none place-items-center rounded-full border border-white/20 bg-gradient-to-br from-brand-500 to-brand-600 text-white shadow-[0_20px_36px_-20px_rgba(109,79,194,0.85)] transition-all duration-250 hover:-translate-y-0.5 hover:from-brand-600 hover:to-violet-700 hover:shadow-[0_22px_40px_-22px_rgba(109,79,194,1)] focus:outline-none max-[600px]:bottom-3 max-[600px]:right-3 max-[600px]:h-13 max-[600px]:w-13"
    style="border-radius: 9999px;"
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
