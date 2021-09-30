~drones.createDrone(\sine, 0, name: \low0);
~drones.createDrone(\sine, 1, name: \low1);
~drones.createDrone(\saw, 2, name: \low2, degree: 5);
~drones.createDrone(\pulse, 3, name: \low3, degree: 3);
~drones.createDrone(\sine, 4, name: \low4);

~low2.type_(\pulse,2)
~low4.type_(\saw,3)

~low3.tonic_(0,2)
~low3.degree_(0,5)

~low3.kill

~drones.killAll

~drones.createDrone(\saw, 2, harmonics: 3, degree: 3, length: 120, speed: 4);

~csi.type=sine;

~csi.harmonics_(5,10);

~eri.harmonics_(3,10);
~eri.type_(\sine,10);

~csi.type_(\sine,10);

~drones.createChord(\saw, \minor, 2)

~chd_ulz.tonic_(4,20);
~chd_ulz.type = \square

~chd_ulz.kill


~drones.createSatellites(\saw, \minor, 4, name: \ooo)

~ooo.harmonics_(7,10);
~ooo.octave_(1,4);
~ooo.kill
