~drones.createDrone(\sine, 0, name: \low0);
~drones.createDrone(\sine, 1, name: \low1);
~low0.tonic_(0,10);
~drones.createDrone(\saw, 2, name: \low2, degree: 5, amp: 0.15);
~drones.createDrone(\pulse, 3, name: \low3, degree: 3, amp: 0.15);
~drones.createDrone(\tri, 4, name: \low4, harmonics: 5, amp: 0.2);

~drones.killAll

~eri.harmonics_(3,10);
~eri.type_(\sine,10);

~drones.createChord(\saw, \minor, 3)
~chd_csu.kill
~chd_ulz.tonic_(4,20);
~chd_ulz.type = \square

~chd_ulz.kill


~drones.createSatellites(\saw, \minor, 4, name: \ooo)

~ooo.harmonics_(7,10);
~ooo.octave_(1,4);
~ooo.kill
