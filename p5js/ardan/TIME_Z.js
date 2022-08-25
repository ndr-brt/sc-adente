'use babel'

export default function(p) {


// CREATE WINDOW
  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    windowsize = p.windowHeight;
    //console.log(p.windowHeight)
  }

// USER VARIABLES
  var globaltime = 10;
  var speed_range = [0.01, 4]


// INIT
  var start = 0;
  var shiftx = 300;
  var shifty = 50;
  var centerx = (p.windowWidth/3/2);
  var timewidget = 0;
  var framerate = 3;


  p.setup = () => {
    p.smooth();
    p.frameRate(framerate);
    p.colorMode(p.HSB, 360);

// LINES
   setTimeout(() => {
     p.background(0, 0, 0);
         p.strokeWeight(2);
         p.stroke(255, 0, 255);
         p.line(p.windowWidth/3, 0, p.windowWidth/3, p.windowHeight);
         p.line((p.windowWidth/3)*2, 0, (p.windowWidth/3)*2, p.windowHeight);
   })
} // setup


// FUNCTIONS
  function littleRand(shift) {
    var rnd = ((Math.random() * shift) - shift/2);
      	return rnd;
      }

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
       console.log(tidal);


// SWITCHER + PLOTTER

        // TRIANGLE
             if (tidal.s) {

               switch (tidal.f) {
                  case 1:
                    h = 240;
                    pos = [0, 0]
                    break;
                  case 2:
                    h = 0;
                    pos = [p.windowWidth/3, 0]
                    break;
                  case 3:
                    h = 56;
                    pos = [(p.windowWidth/3)*2, 0]
                    break;
                }

                let sat
                if (tidal.gain) {
                  sat = (tidal.gain * 360)
                }
                else {
                  sat = 360
                }
               let yy = s_range(tidal.speed, speed_range, p.windowHeight, 0);
               [base_min, base_max] = [40, 100];
               [alt_min, alt_max] = [40, 100];

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

               let posx = centerx + pos[0] + littleRand(shiftx)
               let posy = yy + pos[1] + littleRand(shifty)

               p.noStroke();
               p.fill(h, sat, 360);
               p.triangle(posx + xx1, posy, posx + base/2, posy - alt, posx + xx2, posy);
             }

        }) //oscmessage


// LAYER
p.draw = () => {

if (start == 1) {
  p.noStroke();
  p.fill(0, 0, 0, 15)
  p.rect(0, 0, p.windowWidth, p.windowHeight);
  p.strokeWeight(2);
  p.stroke(255, 0, 255);
  p.line(p.windowWidth/3, 0, p.windowWidth/3, p.windowHeight);
  p.line((p.windowWidth/3)*2, 0, (p.windowWidth/3)*2, p.windowHeight);
  p.strokeWeight(30);
  p.stroke(255, 100, 255);
  p.line(0, 0, timewidget, 0)
  timewidget = timewidget + p.windowWidth/globaltime/60/framerate;
      }
  }  // draw


} //function
