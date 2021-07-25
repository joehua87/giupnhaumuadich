import { defineConfig } from 'vite'
import WindiCSS from 'vite-plugin-windicss'
// import reactRefresh from '@vitejs/plugin-react-refresh'

// import { svelte } from '@sveltejs/vite-plugin-svelte'
// import preprocess from 'svelte-preprocess'

export default defineConfig({
  // plugins: [svelte({ preprocess: preprocess() })],
  // rollupdedupe: ['svelte']
  plugins: [
    WindiCSS(),
    // reactRefresh(),
    // svelte({ preprocess: preprocess() as any }),
  ],
  base: process.env.NODE_ENV === 'production' ? '/assets/' : undefined,
  optimizeDeps: {
    include: ['phoenix', 'phoenix_html', 'phoenix_live_view'],
  },
  server: {
    host: '0.0.0.0',
  },
  build: {
    rollupOptions: {
      output: {
        entryFileNames: '[name].js',
        assetFileNames: '[name][extname]',
        chunkFileNames: '[name].js',
      },
      input: 'assets/app.ts',
    },
    outDir: 'apps/giupnhaumuadich_web/priv/static/assets',
  },
})
