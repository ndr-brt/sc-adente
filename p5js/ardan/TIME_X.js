'use babel'

export default function(p) {


  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    windowsize = p.windowHeight;
    console.log(p.windowHeight)
  }

// USER VARIABLE
  var globaltime = 10;
  var rows = 6;
  var speed_range = [0.01, 4]


// INIT
  var framerate = 20;
  var increment = (p.windowWidth/((globaltime * 60 / rows) * framerate));
  var xpoint = 0;
  var ypoint = Math.trunc(p.windowHeight / rows);
  var start = 0;
  var ynum = 0;
  var stave = p.windowHeight/rows;
  var galpha = 80;



  p.setup = () => {
    p.smooth();
    p.frameRate(framerate);

    // STAVES
       setTimeout(() => {
         p.background(0, 0, 0);
         for (i = 0; i < rows; i++) {
             p.strokeWeight(2);
             p.stroke(255, 255, 255, 255);
             p.line(0, ynum, p.windowWidth, ynum);
             ynum = ynum + stave;
           }
       })
    } // setup


// FUNCT
  function s_range(v_in, speed_range, scaled_range_min, scaled_range_max) {
    let s_min = speed_range[0]
    let s_max = (speed_range[1] + 0.5)
    let c_min = scaled_range_min
    let c_max = scaled_range_max
     return (v_in - s_min) * (c_max - c_min) / (s_max - s_min) + c_min;
  }


// OSC
this.onOscMessage(message => {
      var tidalArgs = message.args;
      start = 1;

        // reader
        tidal = {};
          for(var i = 0; i < tidalArgs.length; i+=2){
            tidal[tidalArgs[i]] = tidalArgs[i+1]
          };
       console.log(tidalArgs);



//SWITCHER + PLOTTER


          // TRIANGLE
               if (tidal.s) {

                 switch (tidal.f) {
                    case 1:
                      [r, g, b] = [0, 100, 255];
                      break;
                    case 2:
                      [r, g, b] = [255, 20, 0];
                      break;
                    case 3:
                      [r, g, b] = [255, 255, 0];
                      break;
                  }

                 if (tidal.gain) {
                   alpha = (tidal.gain * 255) - galpha
                 }
                 else {
                   alpha = 255 - galpha
                 }

                 let yy = s_range(tidal.speed, speed_range, ypoint, ypoint - stave);
                 [base_min, base_max] = [5, 40];
                 [alt_min, alt_max] = [8, 30];

                 if (tidal.speed) {
                   alt = s_range(tidal.speed, speed_range, alt_max, alt_min);
                   base = s_range(tidal.speed, speed_range, base_max, base_min);
                 }
                 else {
                   [base, alt] = [base_max, alt_max]
                 }

                 if (tidal.begin) {
                   xx1 = base * tidal.begin
                 }
                 else {
                  xx1 = 0
                 }

                 if (tidal.end) {
                   xx2 = base * tidal.end
                 }
                 else {
                  xx2 = 0
                 }

                 p.noStroke();
                 p.fill(r, g, b, alpha);
                 p.triangle(xpoint + xx1, yy, xpoint + base/2, yy - alt, xpoint + xx2, yy);
               }

        }) // oscmessage


// POINTER
p.draw = () => {

if (start == 1) {
  xpoint = (xpoint + increment)%(p.windowWidth);
  if (xpoint < (increment)) {
    ypoint = ypoint + Math.trunc(stave);
      }
 // console.log(xpoint);
 // console.log(ypoint);
    }
  }  // draw


} // function
