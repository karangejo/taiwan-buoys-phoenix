// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import Chart from 'chart.js'

let hooks = {}
hooks.liveBuoyChart = {
    mounted() {
        var ctx = this.el.getContext('2d')
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    {
                    label: "wave height",
                    yAxisID: "wh",
                    data: [],
                    borderColor: '#3F3FBF'
                    },
                    {
                    label: "wave period",
                    yAxisID: "wp",
                    data: [],
                    borderColor: '#3F3A66'
                    },
                ]
            },
            options: {
                resposive: true,
                maintainAspectRatio: false,
                title: {
                    display: true,
                    text: "A TITLE"
                },
                scales: {
                    xAxes: [{
                        type: 'time',
                        time: {
                            displayFormats: {
                                hour: 'MMM D h:mm a'
                            }
                        }
                    }],
                    yAxes: [
                        {
                            id: "wh",
                            type: "linear",
                            position: "left"
                        },
                        {
                            id: "wp",
                            type: "linear",
                            position: "right"
                        }
                    ]
                }
            }
        })

        this.handleEvent("chart-data", (data) => {
            console.log(data.data)
            const waveHeights = data.data.map(x => {
                return x.wave_height})
            const wavePeriod = data.data.map(x => {
                return x.wave_period})
            const dates = data.data.map(x => x.date_time)
            chart.data.datasets[0].data = waveHeights
            chart.data.datasets[1].data = wavePeriod
            chart.data.labels = dates
            chart.update()
        })
        
        this.handleEvent("chart-label", (chart_label) => {
            chart.options.title.text = chart_label.label
            chart.update()
        })
    }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

