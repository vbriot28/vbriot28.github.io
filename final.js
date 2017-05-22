
var gd1 = document.getElementById('g_year1');
var gd2 = document.getElementById('g_year2');
var gd3 = document.getElementById('g_year3');
var gd4 = document.getElementById('g_year4');

var cities = ['New York', 'Bronx', 'Brooklyn', 'Manhattan', 'Queens', 'Statend Island']

//Plot Stops by Years
Plotly.d3.csv("Data for Visualization/data1.csv", function(err, rows){
  //console.log(rows);
  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
  }

  var  allYear1 = unpack(rows, 'year');
  var  allStops1 = unpack(rows,'stops');

  var trace1 = {
    x: allYear1,
    y: allStops1,
    mode: 'lines+markers',
      marker: {
        color: 'rgb(128, 0, 128)',
        size: 8
      },
      line: {
        color: 'rgb(128, 0, 128)',
        width: 1
      }
  };

  var data1 = [ trace1];

  var layout1 = {
    title:'Number of Stops over the years',
    xaxis: {title: 'Years'},
    yaxis: {title: 'number of Stops'},
    height: 400,
    width: 480,
    margin: {t: 20},
    hovermode: 'closest'
  };

  Plotly.newPlot(gd1, data1, layout1);
});

//Plot Stops by Years by borroughs
Plotly.d3.csv("Data for Visualization/data2.csv", function(err, rows){
  //console.log(rows);
  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
  }

  var data2 = cities.map(function(city) {
    var rowsFiltered = rows.filter(function(row) {
        return (row.city === city);
    });
    return {
        mode: 'markers+lines',
        name: city,
        x: unpack(rowsFiltered, 'year'),
        y: unpack(rowsFiltered, 'stops'),
        text: unpack(rowsFiltered, 'city'),
        marker: {
            size: 8
        },
        line: {
          width: 1
        }
    };
  });
  var layout2 = {
    title:'Number of Stops over the years by borrough',
    xaxis: {title: 'Years'},
    height: 400,
    width: 480,
    margin: {t: 20},
    hovermode: 'closest'

  };
  Plotly.plot(gd2, data2, layout2, {showLink: false});
});

//Functionality to plot side by side graph accross year for selected borroughs
Plotly.d3.csv("Data for Visualization/data3_p2.csv", function(err, rows){

    function unpack(rows, key) {
        return rows.map(function(row) { return row[key]; });
    }

    var allYears3 = unpack(rows, 'year');
    var allCity3 = unpack(rows, 'city');
    var allRace3 = unpack(rows, 'race');
    var allPercStops3 = unpack(rows, 'perc_stops');
    var allPercPop3 = unpack(rows, 'perc_pop');
    var allPercPositive3 = unpack(rows, 'perc_positive');

    var listofYears = [];
    var listofCities = [];

    var currentRace = [];
    var currentStops = [];
    var currentPop = [];
    var currentPositive = [];

    function getData(chosenYear, chosenCity) {
      currentRace = [];
      currentStops = [];
      currentPop = [];
      currentPositive = [];
      for (var i = 0 ; i < allYears3.length ; i++){
        if ( allYears3[i] == chosenYear && allCity3[i] == chosenCity) {
          currentRace.push(allRace3[i]);
          currentStops.push(allPercStops3[i]);
          currentPop.push(allPercPop3[i]);
          currentPositive.push(allPercPositive3[i]);
        }
      }
    };

    //Set default Graph to 2015 and New York
    //setBarPlot(2015, 'New York');
    setBarPlot(2006, 'Bronx');

    function setBarPlot(chosenYear, chosenCity) {
        getData(chosenYear, chosenCity);

        var trace3_1 = {
          x: currentRace,
          y: currentStops,
          name: 'Stops',
          type: 'bar'
        };

        var trace3_2 = {
          x: currentRace,
          y: currentPop,
          name: 'Population',
          type: 'bar'
        };

        var trace3_3 = {
          x: currentRace,
          y: currentPositive,
          name: 'Positive Outcome',
          type: 'bar'
        };

        var data3 = [trace3_1, trace3_2, trace3_3];

        var layout3 = {barmode: 'group'};

        Plotly.newPlot(gd3, data3, layout3);

    };

    for (var i = 0; i < allYears3.length; i++ ){
      if (listofYears.indexOf(allYears3[i]) === -1 ){
        listofYears.push(allYears3[i]);
      }
    }

    for (var i = 0; i < allCity3.length; i++ ){
      if (listofCities.indexOf(allCity3[i]) === -1 ){
        listofCities.push(allCity3[i]);
      }
    }

    //Build year list for dropdown
    var yearSelector = document.querySelector('.yeardata');
    var citySelector = document.querySelector('.citydata');

    function assignOptions(textArray, selector) {
      for (var i = 0; i < textArray.length;  i++) {
          var currentOption = document.createElement('option');
          currentOption.text = textArray[i];
          selector.appendChild(currentOption);
      }
    }
    assignOptions(listofYears,yearSelector);
    assignOptions(listofCities,citySelector);

    //Build Manual subplot graph
    function updatePlot(){
        setBarPlot(yearSelector.value, citySelector.value);
    }

    citySelector.addEventListener('change', updatePlot, false);
    yearSelector.addEventListener('change', updatePlot, false);

});

//Donut graphs for outcome percentage by race
Plotly.d3.csv("Data for Visualization/data4.csv", function(err, rows){

    function unpack(rows, key) {
        return rows.map(function(row) { return row[key]; });
    }

    var allYears4 = unpack(rows, 'year');
    var allCity4 = unpack(rows, 'city');
    var allRace4 = unpack(rows, 'race');
    var allPercPositive4 = unpack(rows, 'perc_positive');
    var allPercNegative4 = unpack(rows, 'perc_negative');

    var currentRace4 = [];
    var currentPositive4 = [];
    var currentNegative4 = [];

    function getData4(chosenYear, chosenCity) {
      currentRace4 = [];
      currentPositive4 = [];
      currentNegative4 = [];

      for (var i = 0 ; i < allYears4.length ; i++){
        if ( allYears4[i] == chosenYear && allCity4[i] == chosenCity) {
          currentRace4.push(allRace4[i]);
          currentPositive4.push(allPercPositive4[i]);
          currentNegative4.push(allPercNegative4[i]);
        }
      }
    };
    //Set default Graph to 2015 and New York
    //setBarPlot(2015, 'New York');
    setBarPlot4(2006, 'Bronx');

    function setBarPlot4(chosenYear, chosenCity) {
        getData4(chosenYear, chosenCity);

        var data4 = [{
          values: currentPositive4,
          labels: currentRace4,
          domain: {
            x: [0, .48]
          },
          name: 'Positive Outcome',
          hoverinfo: 'label+percent+name',
          hole: .4,
          type: 'pie'
        },{
          values: currentNegative4,
          labels: currentRace4,
          text: 'Negative',
          textposition: 'inside',
          domain: {x: [.52, 1]},
          name: 'Negative',
          hoverinfo: 'label+percent+name',
          hole: .4,
          type: 'pie'
        }];

        var layout4 = {
          title: 'Breakdown of Outcome by Race',
          annotations: [
            {
              font: {
                size: 14
              },
              showarrow: false,
              text: 'Pos',
              x: 0.17,
              y: 0.5
            },
            {
              font: {
                size: 14
              },
              showarrow: false,
              text: 'Neg',
              x: 0.82,
              y: 0.5
            }
          ],
          height: 400,
          width: 480
        };

        Plotly.newPlot(gd4, data4, layout4);

    };

    var yearSelector4 = document.querySelector('.yeardata');
    var citySelector4 = document.querySelector('.citydata');

    //Build Manual subplot graph
    function updatePlot(){
        setBarPlot4(yearSelector4.value, citySelector4.value);
    }

    citySelector4.addEventListener('change', updatePlot, false);
    yearSelector4.addEventListener('change', updatePlot, false);

});
