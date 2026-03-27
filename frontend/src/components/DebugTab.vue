<template>
  <div>
    <p v-if="logs.length === 0" class="message-text">No debug data yet.</p>
    <div v-for="(log, i) in logs" :key="i" class="debug-query">
      <pre class="message-text">{{ formatLog(log) }}</pre>
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
