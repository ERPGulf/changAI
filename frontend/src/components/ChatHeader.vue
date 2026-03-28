<template>
  <div class="flex items-center justify-between bg-brand-500 px-4 py-3 text-white sm:px-5">
    <div class="flex min-w-0 items-center gap-2.5">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="35"
        height="35"
        viewBox="0 0 1024 1024"
        class="h-8 w-8 shrink-0 rounded-full bg-white p-1.5 fill-brand-500"
      >
        <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"/>
      </svg>
      <h2 class="truncate text-sm font-semibold sm:text-base">ChangAI from ERPGulf</h2>
    </div>

    <div class="ml-2 flex items-center gap-1.5">
      <button
        class="hidden h-8 min-w-8 items-center justify-center rounded-md px-2 text-xs font-semibold text-white/90 transition-colors sm:flex"
        :class="windowMode === 'half' ? 'bg-white/20' : 'hover:bg-white/15'"
        title="Half screen"
        aria-label="Resize to half screen"
        @click="$emit('resizeHalf')"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <rect x="4" y="5" width="16" height="14" rx="2"/>
          <path d="M12 5v14"/>
        </svg>
      </button>

      <button
        class="hidden h-8 min-w-8 items-center justify-center rounded-md px-2 text-xs font-semibold text-white/90 transition-colors sm:flex"
        :class="windowMode === 'full' ? 'bg-white/20' : 'hover:bg-white/15'"
        title="Full screen"
        aria-label="Resize to full screen"
        @click="$emit('resizeFull')"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <rect x="4" y="5" width="16" height="14" rx="2"/>
          <path d="M8 8H6v2M16 8h2v2M8 16H6v-2M16 16h2v-2"/>
        </svg>
      </button>

      <button
        class="grid h-8 w-8 shrink-0 place-items-center rounded-full text-white transition-colors hover:bg-white/15 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/70"
        aria-label="Close chatbot"
        @click="$emit('close')"
      >
        <svg xmlns="http://www.w3.org/2000/svg" height="24" width="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M6 9l6 6 6-6"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup>
defineProps({
  windowMode: {
    type: String,
    required: true,
  },
})

defineEmits(['close', 'resizeHalf', 'resizeFull'])
</script>
