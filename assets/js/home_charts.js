
const Chart = require("chart.js");

const background = 'rgba(255, 148, 34, 0.55)'
// Home page chart
var waveCtx = document.getElementById('latestDataWaveChart').getContext('2d');
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
				pointRadius: 5,
				pointBackgroundColor: 'rgba(55,16,255,0.55)',
				backgroundColor: 'rgba(0,0,0,0)'
			},
			{
				type: 'bar',
				label: "Wave Height (meters)",
				yAxisID: "wh",
				data: waveHeight,
				backgroundColor: background
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
				type: 'category',
				labels: waveLabels
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

var windCtx = document.getElementById('latestDataWindChart').getContext('2d');
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
				backgroundColor: background
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
				type: 'category',
				labels: windLabels
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