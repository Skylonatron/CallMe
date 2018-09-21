
function changeGraph(){

}

function refresh_stocks(stocks){
    // do whatever you like here
    var stocksArray = stocks.split(',')
    
    for (var i in stocksArray) {
      get_stock_price(stocksArray[i])
      get_high_low(stocksArray[i])
    }
    
    console.log("andrew")

    setTimeout(function(){ refresh_stocks(stocks); }, 3000);



}

function get_high_low(symbol){
  let endpoint = "https://api.iextrading.com/1.0/stock/" + symbol + "/previous";

  fetch(endpoint)
    .then(response => {
      if (response.ok) {
        return response.json();
      }
    })
    .then(function(json) {
      var html = ""
      var color = "grey"
      var plus = ""

      if( json.change > 0 ){
        // html += "<i class='material-icons vertical-align-bottom green md-36'>arrow_upward</i>"
        color = "green"
        plus = "+"

      }
      else{
        // html += "<i class='material-icons vertical-align-bottom red md-24'>arrow_downward</i>"
        color = "red"
      }



      html += "<div class='inline-block vertical-align-bottom " + color + "'>"
      html += plus + json.change + " (" + json.changePercent + "%)"
      html += "</div>"

      $( "#stock-" + symbol + "-change" ).html(html);
    })
    .catch(error => {
      console.log(error);
      return error;
    })
}

function get_stock_price(symbol){

  let endpoint = "https://api.iextrading.com/1.0/stock/" + symbol + "/price";

  fetch(endpoint)
    .then(response => {
      if (response.ok) {
        return response.json();
      }
    })
    .then(function(json) {
      $( "#stock-" + symbol + "-price" ).html(json);
    })
    .catch(error => {
      console.log(error);
      return error;
    })
}


