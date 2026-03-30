const SESSION_KEY = 'changai_chat_id'
const POLLY_PREFERENCE_KEY = 'changai_polly_enabled'

export function getOrCreateChatId() {
  let chatId = sessionStorage.getItem(SESSION_KEY)
  if (!chatId) {
    chatId = `session_${Date.now()}_${crypto.randomUUID()}`
    sessionStorage.setItem(SESSION_KEY, chatId)
  }
  return chatId
}

export function getPollyPreference() {
  const stored = localStorage.getItem(POLLY_PREFERENCE_KEY)
  if (stored === null) return true
  return stored === 'true'
}

export function setPollyPreference(enabled) {
  localStorage.setItem(POLLY_PREFERENCE_KEY, String(Boolean(enabled)))
}
