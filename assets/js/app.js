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

Chart.defaults.global.defaultFontFamily = 'Cairo'
Chart.defaults.global.defaultFontStyle = 'bold'


let hooks = {}
hooks.BuoyChart = {
    mounted() {
        var waveDirections = []
        var waveCtx = document.getElementById('waveBuoyChart').getContext('2d');
        var waveChart = new Chart(waveCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    {
                    fill: true,
                    backgroundColor: "rgba(206, 130, 92, 0.3)",
                    label: "Wave Height (meters)",
                    yAxisID: "wh",
                    data: [],
                    borderColor: "rgba(206, 130, 92, 1)"
                    },
                    {
                    fill: true,
                    backgroundColor: "rgba(178, 230, 157, 0.2)",
                    label: "Wave Period (seconds)",
                    yAxisID: "wp",
                    data: [],
                    borderColor: "rgba(178, 250, 157, 1)"
                    },
                ]
            },
            options: {
                tooltips:{
                    mode: "label"
                },
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
                            },
                            tooltipFormat: 'MMM D h:mm a'
                        },
                        ticks: {
                            callback: function(value, index, values) {
                                return value + " " + waveDirections[index]
                            }
                        }
                    }],
                    yAxes: [
                        {
                            id: "wh",
                            type: "linear",
                            position: "left",
                            ticks: {
                                beginAtZero: true,
                                callback: function(value, index, values) {
                                    return value + " (m)"
                                }
                            }
                        },
                        {
                            id: "wp",
                            type: "linear",
                            position: "right",
                            ticks: {
                                beginAtZero: true,
                                callback: function(value, index, values) {
                                    return value + " (s)"
                                }
                            }
                        }
                    ]
                }
            }
        })
        
        var windDirections = []
        var windCtx = document.getElementById('windBuoyChart').getContext('2d');
        var windChart = new Chart(windCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [
                    {
                    fill: true,
                    backgroundColor: "rgba(206, 130, 92, 0.3)",
                    label: "Wind Speed (meters/second)",
                    yAxisID: "ws",
                    data: [],
                    borderColor: "rgba(206, 130, 92, 1)"
                    },
                    {
                    fill: true,
                    backgroundColor: "rgba(178, 230, 157, 0.2)",
                    label: "Max Wind Speed (meter/second)",
                    yAxisID: "mws",
                    data: [],
                    borderColor: "rgba(178, 250, 157, 1)"
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
                            },
                            tooltipFormat: 'MMM D h:mm a'
                        },
                        ticks: {
                            callback: function(value, index, values) {
                                return value + " " + windDirections[index]
                            }
                        }
                    }],
                    yAxes: [
                        {
                            id: "ws",
                            type: "linear",
                            position: "left",
                            ticks: {
                                beginAtZero: true,
                                callback: function(value, index, values) {
                                    return value + " (m/s)"
                                }
                            }
                        },
                        {
                            id: "mws",
                            type: "linear",
                            position: "right",
                            ticks: {
                                beginAtZero: true,
                                callback: function(value, index, values) {
                                    return value + " (m/s)"
                                }
                            }
                        }
                    ]
                }
            }
        })

        
        this.handleEvent("wind-chart-label", (chart_label) => {
            windChart.options.title.text = chart_label.label
            windChart.update()
        })

        this.handleEvent("chart-data", (data) => {
            
            const dates = data.data.map(x => x.date_time)

            //update wind data
            const windSpeed = data.data.map(x => {
                return x.mean_wind_speed})
            const maxWindSpeed = data.data.map(x => {
                return x.maximum_wind})
            const windDirection = data.data.map(x => {
                return x.wind_direction})
            windChart.data.datasets[0].data = windSpeed
            windChart.data.datasets[1].data = maxWindSpeed
            windDirections = windDirection
            windChart.data.labels = dates
            windChart.update()

            //update wave data
            const waveHeights = data.data.map(x => {
                return x.wave_height})
            const wavePeriod = data.data.map(x => {
                return x.wave_period})
            const waveDirection = data.data.map(x => {
                return x.wave_direction})
            waveChart.data.datasets[0].data = waveHeights
            waveChart.data.datasets[1].data = wavePeriod
            waveChart.data.labels = dates
            waveDirections = waveDirection
            waveChart.update()
        })
        
        this.handleEvent("wave-chart-label", (chart_label) => {
            waveChart.options.title.text = chart_label.label
            waveChart.update()
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

