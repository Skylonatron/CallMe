function generate_line_chart(chart_data, symbol) {
  var today = new Date()
  var tomorrow = today.getDate() + 1
  var symbolID = "myChart-" + symbol
  var ctx = document.getElementById(symbolID)

  var lowest = 10000
  var highest = 0

  var times = []

  data = []

  var sum = 0

  if(chart_data[0].marketAverage > chart_data[chart_data.length - 1].marketAverage){
    fillColor = 'rgba(255, 0, 0, 0.3)'
    borderColor = 'rgba(255, 0, 0, 1)'
  }
  else{
    fillColor = 'rgba(0,250,154, 0.3)'
    borderColor = 'rgba(0,250,154, 1)'
  }


  for (i = 0; i < chart_data.length; i++) { 
    d = chart_data[i]

    if(d.marketAverage < lowest){
      lowest = d.marketAverage
    }

    if(d.marketAverage > highest){
      highest = d.marketAverage
    }

    if((i+1)%10==0){
      data.push(sum/10.0)
      sum = 0
      times.push(d.date)
    }
    else{
      sum += d.marketAverage
    }
  }


  new Chart(ctx, {
    type: 'line',
    data: {
      labels: times,
      datasets: [{ 
          data: data,
          label: "",
          pointRadius: 0,
          borderColor: "#3e95cd",
          fill: true,
          lineTension: 1,
          borderWidth: 1,
          backgroundColor: fillColor,
          borderColor: borderColor
        }
      ]
    },
    options: {
      title: {
        display: false,
      },
      legend: {
        display: false
      },
      scales: {
        yAxes: [{
          display: false,
          // ticks: {
          //   min: lowest,
          //   max: highest
          // }
        }],
        xAxes: [{
          display: false
        }]
      }
    }
  });


}

function get_chart(symbol){

  let endpoint = "https://api.iextrading.com/1.0/stock/" + symbol + "/chart/1d";

  fetch(endpoint)
    .then(response => {
      if (response.ok) {
        return response.json();
      }
    })
    .then(function(json) {
      generate_line_chart(json, symbol)
    })
    .catch(error => {
      console.log("error:")
      console.log(error);
      return error;
    })
}