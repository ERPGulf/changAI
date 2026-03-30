<template>
  <div>
    <p v-if="logs.length === 0" class="rounded-lg bg-brand-50 px-4 py-3 text-xs text-black">No debug data yet.</p>
    <div v-for="(log, i) in logs" :key="i" class="mb-3 min-w-0 overflow-x-auto rounded-lg bg-gray-100 p-2 text-[11px]">
      <pre class="whitespace-pre-wrap wrap-anywhere text-[11px] leading-relaxed text-black">{{ formatLog(log) }}</pre>
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

// Keys whose values must never be shown in the UI — dropped entirely from output
const SENSITIVE_KEYS = new Set([
  'gemini_json_content',
  'private_key',
  'private_key_id',
  'client_secret',
  'client_id',
  'aws_access_key',
  'aws_secret_key',
  'api_key',
  'token',
  'access_token',
  'refresh_token',
  'password',
  'secret',
  'authorization',
  'embed_version_id',
  'llm_version_id',
  'entity_retriever',
  'retriever',
  'deploy_url',
  'support_api_url',
  'get_ticket_details_url',
])

function sanitize(value, depth = 0) {
  if (depth > 10 || value === null || value === undefined) return value
  if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') return value
  if (Array.isArray(value)) return value.map(item => sanitize(item, depth + 1))
  if (typeof value === 'object') {
    const out = {}
    for (const [k, v] of Object.entries(value)) {
      if (!SENSITIVE_KEYS.has(k.toLowerCase())) {
        out[k] = sanitize(v, depth + 1)
      }
    }
    return out
  }
  return value
}

function formatLog(log) {
  return safeStringify(sanitize(log))
}
</script>
