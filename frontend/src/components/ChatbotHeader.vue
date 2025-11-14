<template>
    <div class="chat-header">
        <div class="header-info">
            <ChatbotIcon />
            <h2 class="logo-text">ChangAI</h2>
            </div>
            <button @click="emit('toggle')" class="material-symbols-rounded">keyboard_arrow_down</button>
    </div>
</template>

<script setup>
 import ChatbotIcon from './ChatbotIcon.vue';
 defineProps(['showChatbot'])
const emit = defineEmits(['toggle'])
</script>
