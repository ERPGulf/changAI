import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue(), tailwindcss()],
  build: {
    outDir: resolve(__dirname, '../changai/public/dist'),
    emptyOutDir: true,
    cssCodeSplit: false,
    lib: {
      entry: resolve(__dirname, 'src/main.js'),
      name: 'ChangAIChatbot',
      formats: ['iife'],
      fileName: () => 'changai-chatbot.js',
    },
    rollupOptions: {
      output: {
        assetFileNames: (assetInfo) => {
          if (assetInfo.name && assetInfo.name.endsWith('.css')) {
            return 'changai-chatbot.css'
          }
          return '[name][extname]'
        },
      },
    },
  },
})
