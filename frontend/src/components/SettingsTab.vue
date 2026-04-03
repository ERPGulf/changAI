<template>
  <div class="flex flex-col gap-4">
    <div class="chat-card motion-safe:animate-fade-rise rounded-xl p-4 text-slate-900">
      <h3 class="text-sm font-semibold tracking-[0.01em]">Speech Settings</h3>
      <p class="mt-1 text-xs leading-relaxed text-slate-600">These controls apply only inside this chatbot box for the current browser session.</p>
    </div>

    <div class="chat-card motion-safe:animate-fade-rise rounded-xl p-4">
      <div class="flex items-start justify-between gap-4">
        <div>
          <p class="text-sm font-semibold text-slate-900">Auto Read Replies</p>
          <p class="mt-1 text-xs text-slate-600">Automatically read bot replies aloud.</p>
        </div>
        <button
          class="group relative h-7 w-12 shrink-0 rounded-full border border-slate-200 transition-all duration-200"
          :class="autoReadEnabled ? 'bg-emerald-500/95' : 'bg-slate-300'"
          :aria-pressed="autoReadEnabled ? 'true' : 'false'"
          :title="autoReadEnabled ? 'Disable auto read' : 'Enable auto read'"
          @click="$emit('toggleAutoRead')"
        >
          <span
            class="absolute top-0.5 h-5.5 w-5.5 rounded-full bg-white shadow-sm transition-all duration-200"
            :class="autoReadEnabled ? 'left-[1.45rem]' : 'left-0.5'"
          ></span>
        </button>
      </div>
      <p class="mt-3 text-[11px] font-medium" :class="autoReadEnabled ? 'text-emerald-700' : 'text-slate-500'">
        {{ autoReadEnabled ? 'Auto read is active.' : 'Auto read is currently off.' }}
      </p>
    </div>

    <div class="chat-card motion-safe:animate-fade-rise rounded-xl p-4">
      <div class="flex items-start justify-between gap-4">
        <div>
          <p class="text-sm font-semibold text-slate-900">Use Amazon Polly</p>
          <p class="mt-1 text-xs text-slate-600">Use Polly when available; otherwise browser speech is used automatically.</p>
          <p class="mt-2 text-[11px] text-slate-500">Availability: {{ pollyAvailabilityLabel }}</p>
          <p v-if="settings?.aws_region" class="mt-1 text-[11px] text-slate-500">Region: {{ settings.aws_region }}</p>
          <p v-if="ttsConfig?.voiceId" class="mt-1 text-[11px] text-slate-500">Voice: {{ ttsConfig.voiceId }}</p>
        </div>
        <button
          class="relative h-7 w-12 shrink-0 rounded-full border border-slate-200 transition-all duration-200 disabled:cursor-not-allowed disabled:opacity-55"
          :class="(ttsConfig?.usePolly && ttsConfig?.enableVoiceChat && ttsConfig?.pollyAvailable) ? 'bg-emerald-500/95' : 'bg-slate-300'"
          :aria-pressed="(ttsConfig?.usePolly && ttsConfig?.enableVoiceChat && ttsConfig?.pollyAvailable) ? 'true' : 'false'"
          :disabled="!ttsConfig?.pollyAvailable || !ttsConfig?.enableVoiceChat"
          @click="$emit('togglePollyPreference')"
        >
          <span
            class="absolute top-0.5 h-5.5 w-5.5 rounded-full bg-white shadow-sm transition-all duration-200"
            :class="(ttsConfig?.usePolly && ttsConfig?.enableVoiceChat && ttsConfig?.pollyAvailable) ? 'left-[1.45rem]' : 'left-0.5'"
          ></span>
        </button>
      </div>
      <p v-if="!ttsConfig?.enableVoiceChat" class="mt-3 rounded-md bg-amber-50 px-2.5 py-2 text-xs text-amber-700">Voice chat is disabled in ChangAI Settings.</p>
      <p v-else-if="!ttsConfig?.pollyAvailable" class="mt-3 rounded-md bg-amber-50 px-2.5 py-2 text-xs text-amber-700">Polly is not available for this site. Browser speech will be used.</p>
    </div>
    <div class="chat-card motion-safe:animate-fade-rise rounded-xl p-4">
    <div class="flex items-start justify-between gap-4">
      <div>
        <p class="text-sm font-semibold text-slate-900">Enable Debug Tab</p>
        <p class="mt-1 text-xs text-slate-600">
          Show or hide the Debug tab inside this chatbot.
        </p>
        <p class="mt-2 text-[11px] font-medium" :class="debugEnabled ? 'text-emerald-700' : 'text-slate-500'">
          {{ debugEnabled ? 'Debug tab is active.' : 'Debug tab is currently off.' }}
        </p>
      </div>

      <button
        type="button"
        class="relative h-7 w-12 shrink-0 rounded-full border border-slate-200 transition-all duration-200"
        :class="debugEnabled ? 'bg-emerald-500/95' : 'bg-slate-300'"
        :aria-pressed="debugEnabled ? 'true' : 'false'"
        :title="debugEnabled ? 'Disable debug tab' : 'Enable debug tab'"
        @click="$emit('toggleDebug')"
      >
        <span
          class="absolute top-0.5 h-5.5 w-5.5 rounded-full bg-white shadow-sm transition-all duration-200"
          :class="debugEnabled ? 'left-[1.45rem]' : 'left-0.5'"
        ></span>
      </button>
    </div>
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
  debugEnabled: {
  type: Boolean,
  default: false,
},
})

defineEmits(['toggleAutoRead', 'togglePollyPreference', 'toggleDebug'])

const pollyAvailabilityLabel = computed(() => {
  if (!props.ttsConfig?.enableVoiceChat) return 'Voice disabled on server'
  return props.ttsConfig?.pollyAvailable ? 'Available' : 'Unavailable'
})
</script>