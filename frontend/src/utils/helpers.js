export function safeStringify(value) {
  try {
    return JSON.stringify(value, null, 2)
  } catch (e) {
    console.warn('safeStringify failed:', e)
    return String(value)
  }
}

export function getErrorText(err) {
  return (
    err?.message ||
    err?.responseJSON?.exception ||
    err?.responseJSON?.message ||
    err?.responseText ||
    String(err)
  )
}

export function normalizeBotText(bot) {
  if (typeof bot === 'string') return bot
  if (bot && typeof bot === 'object') {
    if (bot.error) return `⚠️ ${bot.error}`
    return bot.answer || bot.text || ''
  }
  return ''
}
