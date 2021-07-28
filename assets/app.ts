// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import 'virtual:windi.css'
import './app.css'
import 'react-datepicker/dist/react-datepicker.css'

// import { renderApp } from './entry'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'
import { Socket } from 'phoenix'
import topbar from 'topbar'
import { LiveSocket, ViewHook } from 'phoenix_live_view'

declare global {
  interface Window {
    loginWithFacebook: () => void
    liveSocket: any
    source_products: { id: string; name: string; other_names: string[] }[]
  }
}
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute('content')

let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: {
    DiagnosisForm: {
      mounted(this: ViewHook) {
        import('~/containers/MedicalRecordForm').then((m) => {
          m.renderForm(this)
        })
      },
    },
    DoctorEditForm: {
      mounted(this: ViewHook) {
        this.pushEvent('load_entity', {}, ({ entity, categories }) => {
          import('~/containers/DoctorEditForm').then((m) => {
            m.renderDoctorEditForm(this, { entity, categories })
          })
        })
      },
    },
    CategoryEditForm: {
      mounted(this: ViewHook) {
        this.pushEvent('load_entity', {}, ({ entity }) => {
          import('~/containers/CategoryEditForm').then((m) => {
            m.renderCategoryEditForm(this, { entity })
          })
        })
      },
    },
  },
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', (info) => topbar.show())
window.addEventListener('phx:page-loading-stop', (info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

FB.init({
  appId: '573366700506831',
  cookie: true,
  xfbml: true,
  version: 'v11.0',
})

window.loginWithFacebook = () => {
  FB.login((response) => {
    console.log(response)
    const form = document.getElementById('facebook-login') as HTMLFormElement
    const tokenInput = form.querySelector(
      '[name=access_token]',
    ) as HTMLInputElement
    tokenInput.value = response.authResponse.accessToken
    form.submit()

    /*
    const token = document
      .querySelector('[name="csrf-token"]')
      ?.getAttribute('content')
    if (!token) {
      throw new Error('Cannot get token')
    }
    const { json } = await fetch(`/auth/facebook`, {
      headers: {
        accept: 'application/json',
        'content-type': 'application/json',
        'x-csrf-token': token,
      },
      credentials: 'same-origin',
      method: 'POST',
      body: JSON.stringify({ accessToken: authResponse.accessToken }),
    })
    */
  })
}
