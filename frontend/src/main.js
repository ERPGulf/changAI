import { createApp } from 'vue'
import App from './App.vue'
import './tailwind.css'

function resolveStylesheetHref() {
  const linkFromHead = document.querySelector('link[href*="/assets/changai/dist/changai-chatbot.css"]')
  if (linkFromHead?.href) return linkFromHead.href

  const scriptTag = Array.from(document.scripts).find((script) => script.src?.includes('/assets/changai/dist/changai-chatbot.js'))
  if (!scriptTag?.src) return null

  return scriptTag.src.replace(/changai-chatbot\.js(\?.*)?$/, 'changai-chatbot.css$1')
}

function ensureShadowStyles(shadowRoot) {
  const href = resolveStylesheetHref()

  if (!href) {
    const devStyles = Array.from(document.querySelectorAll('style[data-vite-dev-id]'))
    if (devStyles.length) {
      devStyles.forEach((styleNode) => {
        const clone = document.createElement('style')
        clone.dataset.changaiShadowDevStyle = '1'
        clone.textContent = styleNode.textContent || ''
        shadowRoot.appendChild(clone)
      })
    }
    return Promise.resolve()
  }

  if (shadowRoot.querySelector('link[data-changai-shadow-style="1"]')) return Promise.resolve()

  return new Promise((resolve) => {
    const link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = href
    link.dataset.changaiShadowStyle = '1'
    link.onload = () => resolve()
    link.onerror = () => resolve()
    shadowRoot.appendChild(link)

    // Avoid blocking mount forever if the browser does not fire load/error.
    setTimeout(resolve, 1200)
  })
}

async function initChangAIChatbot() {
  if (document.getElementById('changai-chatbot-host')) return

  const host = document.createElement('div')
  host.id = 'changai-chatbot-host'
  document.body.appendChild(host)

  const shadowRoot = host.attachShadow({ mode: 'open' })
  await ensureShadowStyles(shadowRoot)

  const mountEl = document.createElement('div')
  mountEl.id = 'changai-chatbot-root'
  shadowRoot.appendChild(mountEl)

  createApp(App).mount(mountEl)

  // Prevent keyboard events generated inside the shadow DOM from bubbling out
  // into the host page (e.g. ERPNext / Frappe shortcut handlers registered on
  // document). stopPropagation() here keeps every keydown/keyup/keypress
  // contained within the shadow tree so host-page shortcuts are never triggered
  // while the user is interacting with the chatbot.
  function _stopKeyboardEscape(e) { e.stopPropagation() }
  mountEl.addEventListener('keydown', _stopKeyboardEscape)
  mountEl.addEventListener('keyup',   _stopKeyboardEscape)
  mountEl.addEventListener('keypress', _stopKeyboardEscape)
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initChangAIChatbot)
} else {
  initChangAIChatbot()
}
