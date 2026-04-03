const IS_DEV = import.meta.env.DEV

export const API = {
  PIPELINE: 'changai.changai.api.v2.text2sql_pipeline_v2.run_text2sql_pipeline',
  SUPPORT: 'changai.changai.api.v2.text2sql_pipeline_v2.support_bot',
  SETTINGS: 'changai.changai.api.v2.text2sql_pipeline_v2.get_frontend_settings',
  TTS: 'changai.changai.api.v2.text2sql_pipeline_v2.synthesize_tts',
}

export function frappeCall(method, args = {}, mode = 'actual') {
  if (mode === 'test') {
    return Promise.resolve({ Bot: `[TEST MODE] ${JSON.stringify(args)}` })
  }

  if (!window.frappe || !window.frappe.call) {
    if (IS_DEV) {
      console.warn('[DEV] frappe.call not available in actual mode')
    }
    return Promise.reject(new Error('Frappe API is unavailable in actual mode.'))
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

export function runPipeline(userQuestion, chatId, mode = 'actual', requestId = null) {
  return frappeCall(API.PIPELINE, {
    user_question: userQuestion,
    chat_id: chatId,
    request_id: requestId,
  }, mode)
}

export function runPipelineCancelable(userQuestion, chatId, mode = 'actual', requestId = null) {
  if (mode === 'test') {
    return {
      promise: Promise.resolve({
        Bot: `[TEST MODE] ${JSON.stringify({
          user_question: userQuestion,
          chat_id: chatId,
          request_id: requestId,
        })}`
      }),
      cancel: () => false,
    }
  }

  if (!window.frappe || !window.frappe.call) {
    return {
      promise: Promise.reject(new Error('Frappe API is unavailable in actual mode.')),
      cancel: () => false,
    }
  }

  let requestHandle = null
  let settled = false

  const promise = new Promise((resolve, reject) => {
    requestHandle = window.frappe.call({
      method: API.PIPELINE,
      args: {
        user_question: userQuestion,
        chat_id: chatId,
        request_id: requestId,
      },
      callback(r) {
        settled = true
        resolve(r.message)
      },
      error(err) {
        settled = true
        reject(err)
      },
    })
  })

  const cancel = () => {
    if (settled) return false
    if (!requestHandle || typeof requestHandle.abort !== 'function') return false
    requestHandle.abort()
    settled = true
    return true
  }

  return { promise, cancel }
}

export function callSupportBot(message, mode = 'actual') {
  return frappeCall(API.SUPPORT, { message }, mode)
}

export function getSettingsDetails(mode = 'actual') {
  return frappeCall(API.SETTINGS, {}, mode)
}

export function synthesizeTTS(text, voiceId = 'Joanna', mode = 'actual') {
  return frappeCall(API.TTS, {
    text,
    voice_id: voiceId,
  }, mode)
}
