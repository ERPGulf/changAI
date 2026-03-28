<template>
  <transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="translate-y-1 opacity-0"
    enter-to-class="translate-y-0 opacity-100"
    leave-active-class="transition duration-150 ease-in"
    leave-from-class="translate-y-0 opacity-100"
    leave-to-class="translate-y-1 opacity-0"
  >
    <div
      v-if="visible"
      class="pointer-events-none absolute -top-14 left-0 right-0 z-20 flex justify-center px-2"
      role="status"
      aria-live="polite"
    >
      <div
        class="pointer-events-auto flex max-w-[92%] items-start gap-2 rounded-lg px-3 py-2 text-xs shadow-lg ring-1"
        :class="toastClasses"
      >
        <span class="mt-0.5 h-2 w-2 shrink-0 rounded-full" :class="dotClasses"></span>
        <span>{{ message }}</span>
        <button
          v-if="dismissible"
          type="button"
          class="ml-1 appearance-none border-0 text-current/80 transition hover:text-current focus:outline-none"
          aria-label="Dismiss notification"
          @click="$emit('close')"
        >
          ×
        </button>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  visible: {
    type: Boolean,
    required: true,
  },
  message: {
    type: String,
    default: '',
  },
  type: {
    type: String,
    default: 'info',
  },
  dismissible: {
    type: Boolean,
    default: true,
  },
})

defineEmits(['close'])

const toastClasses = computed(() => {
  if (props.type === 'error') return 'bg-red-50 text-red-700 ring-red-200'
  if (props.type === 'listening') return 'bg-blue-50 text-blue-700 ring-blue-200'
  return 'bg-blue-50 text-blue-700 ring-blue-200'
})

const dotClasses = computed(() => {
  if (props.type === 'error') return 'bg-red-500'
  if (props.type === 'listening') return 'bg-blue-500 animate-pulse'
  return 'bg-blue-500'
})
</script>
