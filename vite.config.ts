import { defineConfig } from 'vite'
import WindiCSS from 'vite-plugin-windicss'
import fs from 'fs'
import path from 'path'
// import reactRefresh from '@vitejs/plugin-react-refresh'

// import { svelte } from '@sveltejs/vite-plugin-svelte'
// import preprocess from 'svelte-preprocess'

const isProd = process.env.NODE_ENV === 'production'

export default defineConfig({
  // plugins: [svelte({ preprocess: preprocess() })],
  // rollupdedupe: ['svelte']
  plugins: [
    WindiCSS(),
    // reactRefresh(),
    // svelte({ preprocess: preprocess() as any }),
  ],
  base: isProd ? '/assets/' : undefined,
  optimizeDeps: {
    include: ['phoenix', 'phoenix_html', 'phoenix_live_view'],
  },
  server: {
    host: '0.0.0.0',
    https: isProd
      ? {}
      : {
          key: fs.readFileSync(
            'apps/giupnhaumuadich_web/priv/cert/test+4-key.pem',
          ),
          cert: fs.readFileSync(
            'apps/giupnhaumuadich_web/priv/cert/test+4.pem',
          ),
        },
  },
  resolve: {
    alias: {
      '~': path.resolve('assets'),
    },
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
