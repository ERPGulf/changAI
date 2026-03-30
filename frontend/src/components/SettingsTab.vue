<template>
  <div class="flex flex-col gap-4">
    <div class="rounded-xl bg-brand-50 p-4 text-black">
      <h3 class="text-sm font-semibold">Speech Settings</h3>
      <p class="mt-1 text-xs leading-relaxed text-gray-700">These controls apply only inside this chatbot box for the current browser.</p>
    </div>

    <div class="rounded-xl border border-gray-200 bg-white p-4">
      <div class="flex items-start justify-between gap-4">
        <div>
          <p class="text-sm font-semibold text-black">Auto Read Replies</p>
          <p class="mt-1 text-xs text-gray-600">Automatically read bot replies aloud.</p>
        </div>
        <button
          class="rounded-full px-3 py-1.5 text-xs font-semibold text-white"
          :class="autoReadEnabled ? 'bg-emerald-600' : 'bg-gray-400'"
          @click="$emit('toggleAutoRead')"
        >
          {{ autoReadEnabled ? 'Enabled' : 'Disabled' }}
        </button>
      </div>
    </div>

    <div class="rounded-xl border border-gray-200 bg-white p-4">
      <div class="flex items-start justify-between gap-4">
        <div>
          <p class="text-sm font-semibold text-black">Use Amazon Polly</p>
          <p class="mt-1 text-xs text-gray-600">Use Polly when available, otherwise browser speech will be used.</p>
          <p class="mt-2 text-[11px] text-gray-500">Availability: {{ pollyAvailabilityLabel }}</p>
          <p v-if="settings?.aws_region" class="mt-1 text-[11px] text-gray-500">Region: {{ settings.aws_region }}</p>
          <p v-if="ttsConfig?.voiceId" class="mt-1 text-[11px] text-gray-500">Voice: {{ ttsConfig.voiceId }}</p>
        </div>
        <button
          class="rounded-full px-3 py-1.5 text-xs font-semibold text-white"
          :class="ttsConfig?.usePolly ? 'bg-emerald-600' : 'bg-gray-400'"
          :disabled="!ttsConfig?.pollyAvailable"
          @click="$emit('togglePollyPreference')"
        >
          {{ ttsConfig?.usePolly ? 'Enabled' : 'Disabled' }}
        </button>
      </div>
      <p v-if="!ttsConfig?.enableVoiceChat" class="mt-3 text-xs text-amber-700">Voice chat is disabled in ChangAI Settings.</p>
      <p v-else-if="!ttsConfig?.pollyAvailable" class="mt-3 text-xs text-amber-700">Polly is not available for this site. Browser speech will be used.</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  autoReadEnabled: {
    type: Boolean,
    required: true,
  },
  ttsConfig: {
    type: Object,
    required: true,
  },
  settings: {
    type: Object,
    default: null,
  },
})

defineEmits(['toggleAutoRead', 'togglePollyPreference'])

const pollyAvailabilityLabel = computed(() => {
  if (!props.ttsConfig?.enableVoiceChat) return 'Voice disabled on server'
  return props.ttsConfig?.pollyAvailable ? 'Available' : 'Unavailable'
})
</script>