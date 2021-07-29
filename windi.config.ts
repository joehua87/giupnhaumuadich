import colors from 'windicss/colors'
import { defineConfig } from 'windicss/helpers'
import pluginAspectRatio from 'windicss/plugin/aspect-ratio'
import pluginLineClamp from 'windicss/plugin/line-clamp'

export default defineConfig({
  extract: {
    include: [
      './apps/giupnhaumuadich_web/lib/**/*.{html,html.eex,html.leex,ex,sface}',
      './assets/**/*.{js,jsx,ts,tsx,vue,svelte}',
    ],
  },
  preflight: {
    safelist: 'a h1 h2 h3 p img table',
  },
  shortcuts: {
    'heading-1': 'text-gray-700 font-semibold text-2xl mb-4',
    'heading-2': 'text-gray-700 font-bold text-xl mb-2',
    'heading-3': 'text-gray-700 font-bold text-lg mb-1',
    money: 'font-semibold text-brand-700',
    card: 'rounded bg-gray-50 p-2',
    button:
      'border bg-brand-500 text-brand-50 hover:bg-brand-700 hover:shadow-lg px-2 rounded transition',
    'button-link': 'text-brand-500 hover:text-brand-700 transition',
    'button-outline':
      'border border-brand-500 text-brand-500 hover:text-brand-700 hover:border-brand-700 px-2 rounded transition',
  },
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
      },
    },
    extend: {
      boxShadow: {
        input: 'inset 0 1px 4px 1px rgba(0, 0, 0, 0.04)',
      },
      colors: {
        brand: colors.blue,
      },
      zIndex: {
        '-10': '-10',
      },
    },
    fontFamily: {
      sans: ['Roboto', 'var(--font-sans)', '-apple-system'],
      serif: ['Lora', 'var(--font-serif)', 'Cambria'],
      mono: ['Menlo', 'SFMono-Regular'],
    },
  },
  plugins: [pluginAspectRatio, pluginLineClamp],
})
