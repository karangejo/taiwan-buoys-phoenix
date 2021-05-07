const Chart = require("chart.js");

var waveCtx = document.getElementById('waveBuoyChart').getContext('2d');
var waveChart = new Chart(waveCtx, {
    type: 'line',
    data: {
        labels: waveLabels,
        datasets: [
            {
                fill: true,
                backgroundColor: "rgba(178, 230, 157, 0.2)",
                label: "Wave Period (seconds)",
                yAxisID: "wp",
                data: wavePeriod,
                borderColor: "rgba(178, 250, 157, 1)"
            },
            {
                fill: true,
                backgroundColor: "rgba(206, 130, 92, 0.3)",
                label: "Wave Height (meters)",
                yAxisID: "wh",
                data: waveHeight,
                borderColor: "rgba(206, 130, 92, 1)"
            },
        ]
    },
    options: {
        tooltips: {
            mode: "label"
        },
        resposive: true,
        maintainAspectRatio: false,
        title: {
            display: true,
            text: waveTitle
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
                    callback: function (value, index, values) {
                        return value + " " + waveDirections[index]
                    }
                }
            }],
            yAxes: [
                {
                    id: "wh",
                    type: "linear",
                    position: "right",
                    ticks: {
                        beginAtZero: true,
                        callback: function (value, index, values) {
                            return value + " (m)"
                        }
                    }
                },
                {
                    id: "wp",
                    type: "linear",
                    position: "left",
                    ticks: {
                        beginAtZero: true,
                        callback: function (value, index, values) {
                            return value + " (s)"
                        }
                    }
                }
            ]
        }
    }
})

var windCtx = document.getElementById('windBuoyChart').getContext('2d');
var windChart = new Chart(windCtx, {
    type: 'line',
    data: {
        labels: windLabels,
        datasets: [
            {
                fill: true,
                backgroundColor: "rgba(206, 130, 92, 0.3)",
                label: "Wind Speed (meters/second)",
                yAxisID: "ws",
                data: windSpeed,
                borderColor: "rgba(206, 130, 92, 1)"
            },
        ]
    },
    options: {
        resposive: true,
        maintainAspectRatio: false,
        title: {
            display: true,
            text: windTitle
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
                    callback: function (value, index, values) {
                        return value + " " + windDirections[index]
                    }
                }
            }],
            yAxes: [
                {
                    id: "ws",
                    type: "linear",
                    position: "right",
                    ticks: {
                        beginAtZero: true,
                        callback: function (value, index, values) {
                            return value + " (kts)"
                        }
                    }
                },
            ]
        }
    }
})


var tideCtx = document.getElementById('tideChart').getContext('2d');
var tideChart = new Chart(tideCtx, {
    type: 'line',
    data: {
        labels: tideLabels,
        datasets: [
            {
                fill: true,
                backgroundColor: "rgba(206, 130, 92, 0.3)",
                label: "tide (meters)",
                yAxisID: "td",
                data: tideHeight,
                borderColor: "rgba(206, 130, 92, 1)"
            },
        ]
    },
    options: {
        resposive: true,
        maintainAspectRatio: false,
        title: {
            display: true,
            text: tideTitle
        },
        scales: {
            xAxes: [{
                type: 'time',
                time: {
                    displayFormats: {
                        hour: 'MMM D h:mm a'
                    },
                    tooltipFormat: 'MMM D h:mm a'
                }
            }],
            yAxes: [
                {
                    id: "td",
                    type: "linear",
                    position: "right",
                    ticks: {
                        beginAtZero: true,
                        callback: function (value, index, values) {
                            return value + " (m)"
                        }
                    }
                },
            ]
        }
    }
})