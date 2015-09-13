# colorvisor
open source color identification for iOS


This is an application for iOS, optimized for iPhone. It is used to assist colorblind people with 
color identification.

A couple caveats:

1. The color matching is based in RGB space. RGB space is non-linear and we use Euclidean distance
in 3 dimensions to calculate the closest match.  This might not be the best way but it works.

2. The color that is identifed relies on the color read by the camera. Simply put: if the camera isn't
reading the correct color, then the app will only be able to match what the camera reads.  In the
future I would like to see white balance correction added.

Hopefully people will find this useful.  Feel free to contact me with any questions or comments.

-Paul
