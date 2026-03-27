const SESSION_KEY = 'changai_chat_id'

export function getOrCreateChatId() {
  let chatId = sessionStorage.getItem(SESSION_KEY)
  if (!chatId) {
    chatId = `session_${Date.now()}_${crypto.randomUUID()}`
    sessionStorage.setItem(SESSION_KEY, chatId)
  }
  return chatId
}
