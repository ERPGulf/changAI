import { createApp } from 'vue'
import App from './App.vue'
import './tailwind.css'

function initChangAIChatbot() {
  if (document.getElementById('changai-chatbot-root')) return

  const mountEl = document.createElement('div')
  mountEl.id = 'changai-chatbot-root'
  document.body.appendChild(mountEl)

  createApp(App).mount(mountEl)
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initChangAIChatbot)
} else {
  initChangAIChatbot()
}
