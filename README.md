WhatCDi (What.CD for iPhone)
============================

Access What.CD natively from your jailbroken iPhone.

## Installation

1. In Cydia, add the repo: `repo.whatcdios.com`
2. Install WhatCDi and enjoy ![Heart](https://whatimg.com/i/USJX7V.png)

## Manual Setup

1. Download the project and navigate into the project folder:
    * `git clone https://github.com/c88/WhatCDi.git` (or [download the ZIP](https://github.com/c88/WhatCDi/archive/master.zip))
    * `cd WhatCDi`
2. [Install Cocoapods](http://cocoapods.org/) (if necessary)
3. Fetch the Cocoapods dependencies:
    * `sudo pod install`
4. Fix Cocoapods ownership:
    * `sudo chown -R <yourUsername> Pods`
    * `sudo chown -R <yourUsername> WhatCDi.xcworkspace`
5. Open `WhatCDi.xcworkspace`
6. Enter your own developer credentials (client ID, client secret key, etc.) in the `.m` file(s) of any cloud storage service(s) you want to mess with (*optional*)