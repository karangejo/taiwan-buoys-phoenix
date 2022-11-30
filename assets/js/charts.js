const Chart = require("chart.js");

var waveCtx = document.getElementById('waveBuoyChart').getContext('2d');
new Chart(waveCtx, {
    data: {
        labels: waveLabels,
        datasets: [
            {
                type: 'line',
                borderColor: "rgba(206, 130, 92, 0.6)",
                label: "Wave Period (seconds)",
                yAxisID: "wp",
                data: wavePeriod,
                pointBackgroundColor: buoyColor,
                pointRadius: 5,
            },
            {
                type: 'bar',
                label: "Wave Height (meters)",
                yAxisID: "wh",
                data: waveHeight,
                backgroundColor: buoyColor,
            },
        ]
    },
    options: {
        tooltips: {
            mode: "label"
        },
        responsive: true,
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
new Chart(windCtx, {
    type: 'bar',
    data: {
        labels: windLabels,
        datasets: [
            {
                fill: true,
                label: "Wind Speed (kts)",
                yAxisID: "ws",
                data: windSpeed,
                backgroundColor: buoyColor,
            },
        ]
    },
    options: {
        responsive: true,
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
new Chart(tideCtx, {
    type: 'line',
    data: {
        labels: tideLabels,
        datasets: [
            {
                fill: true,
                label: "tide (centimeters)",
                yAxisID: "td",
                data: tideHeight,
                pointBackgroundColor: tideColor,
                pointRadius: 8,
            },
        ]
    },
    options: {
        responsive: true,
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
                            return value + " (cm)"
                        }
                    }
                },
            ]
        }
    }
})


// var wavePredCtx = document.getElementById('wavePredChart').getContext('2d');
// new Chart(wavePredCtx, {
//     data: {
//         labels: predLabels,
//         datasets: [
//             {
//                 type: 'bar',
//                 label: "Wave Height (meters)",
//                 yAxisID: "wh",
//                 data: wavePredHeight,
//                 backgroundColor: predColor,
//             },
//             {
//                 type: 'line',
//                 borderColor: "rgba(206, 130, 92, 0.6)",
//                 pointBackgroundColor: predColor,
//                 label: "Wave Period (seconds)",
//                 yAxisID: "wp",
//                 data: wavePredPeriod,
//                 pointRadius: 5,
//             },
//         ]
//     },
//     options: {
//         tooltips: {
//             mode: "label"
//         },
//         responsive: true,
//         maintainAspectRatio: false,
//         title: {
//             display: true,
//             text: wavePredTitle
//         },
//         scales: {
//             xAxes: [{
//                 type: 'time',
//                 time: {
//                     displayFormats: {
//                         hour: 'MMM D h:mm a'
//                     },
//                     tooltipFormat: 'MMM D h:mm a'
//                 },
//                 ticks: {
//                     callback: function (value, index, values) {
//                         return value + " " + wavePredDirections[index]
//                     }
//                 }
//             }],
//             yAxes: [
//                 {
//                     id: "wh",
//                     type: "linear",
//                     position: "right",
//                     ticks: {
//                         beginAtZero: true,
//                         callback: function (value, index, values) {
//                             return value + " (m)"
//                         }
//                     }
//                 },
//                 {
//                     id: "wp",
//                     type: "linear",
//                     position: "left",
//                     ticks: {
//                         beginAtZero: true,
//                         callback: function (value, index, values) {
//                             return value + " (s)"
//                         }
//                     }
//                 }
//             ]
//         }
//     }
// })


// var windPredCtx = document.getElementById('windPredChart').getContext('2d');
// new Chart(windPredCtx, {
//     type: 'bar',
//     data: {
//         labels: predLabels,
//         datasets: [
//             {
//                 backgroundColor: predColor,
//                 label: "Wind Speed (kts)",
//                 yAxisID: "ws",
//                 data: windPredSpeed,
//             },
//         ]
//     },
//     options: {
//         responsive: true,
//         maintainAspectRatio: false,
//         title: {
//             display: true,
//             text: windPredTitle
//         },
//         scales: {
//             xAxes: [{
//                 type: 'time',
//                 time: {
//                     displayFormats: {
//                         hour: 'MMM D h:mm a'
//                     },
//                     tooltipFormat: 'MMM D h:mm a'
//                 },
//                 ticks: {
//                     callback: function (value, index, values) {
//                         return value + " " + windPredDirections[index]
//                     }
//                 }
//             }],
//             yAxes: [
//                 {
//                     id: "ws",
//                     type: "linear",
//                     position: "right",
//                     ticks: {
//                         beginAtZero: true,
//                         callback: function (value, index, values) {
//                             return value + " (kts)"
//                         }
//                     }
//                 },
//             ]
//         }
//     }
// })
