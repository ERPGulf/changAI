const IS_DEV = import.meta.env.DEV

export const API = {
  PIPELINE: 'changai.changai.api.v2.text2sql_pipeline_v2.run_text2sql_pipeline',
  SUPPORT: 'changai.changai.api.v2.text2sql_pipeline_v2.support_bot',
}

export function frappeCall(method, args = {}) {
  if (IS_DEV && (!window.frappe || !window.frappe.call)) {
    console.warn('[DEV] frappe.call not available, returning mock response')
    return Promise.resolve({ Bot: `[DEV MOCK] Response to: ${JSON.stringify(args)}` })
  }
  return new Promise((resolve, reject) => {
    window.frappe.call({
      method,
      args,
      callback(r) {
        resolve(r.message)
      },
      error(err) {
        reject(err)
      },
    })
  })
}

export function runPipeline(userQuestion, chatId) {
  return frappeCall(API.PIPELINE, {
    user_question: userQuestion,
    chat_id: chatId,
  })
}

export function callSupportBot(message) {
  return frappeCall(API.SUPPORT, { message })
}
