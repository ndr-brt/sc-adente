msg.setPort(51000)

parseTidal = (args) => {
  obj = {}
  for(var i = 0; i < args.length; i+=2){
    obj[args[i]] = args[i+1]
  }
  return obj
}

freq = 10
numSides = 0
msg.on('/play2', (args) => {
  // parse the values from tidal
  var tidal = parseTidal(args)
  console.log(tidal)
  setTimeout(() => {
    //
    // increment values of freq and kaliedoscope based on tidal messages received
    //
     if(tidal.s === "sd"){
        // add 10 to frequency when "bd" message received
         freq = freq + 100
     } else if (tidal.s === "bd"){
        // add 1 to num
         numSides = numSides + 1
     }
  }, (tidal.delta - tidal.latency) * 1000)
})


osc(() => freq, 0.0, 0.8)
  .kaleid(() => numSides)
  .out()
