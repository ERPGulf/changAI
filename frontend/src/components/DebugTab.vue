<template>
  <div>
    <p v-if="logs.length === 0" class="rounded-lg bg-brand-50 px-4 py-3 text-xs text-black">No debug data yet.</p>
    <div v-for="(log, i) in logs" :key="i" class="mb-3 overflow-x-auto rounded-lg bg-gray-100 p-2 text-[11px]">
      <pre class="whitespace-pre-wrap text-[11px] leading-relaxed text-black">{{ formatLog(log) }}</pre>
    </div>
  </div>
</template>

<script setup>
import { safeStringify } from '../utils/helpers.js'

defineProps({
  logs: {
    type: Array,
    required: true,
  },
})

function formatLog(log) {
  return safeStringify(log)
}
</script>
