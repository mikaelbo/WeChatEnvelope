# <img src="https://cloud.githubusercontent.com/assets/5389084/23944495/ff90708c-09ad-11e7-8378-cb5382cb7c90.png" width="24" height="24"/> WeChat Envelope

A simple iOS tweak that opens red envelopes in WeChat. It's a very hacky UI based solution, which requires the chat to be visible for the envelopes to be opened. Made for research purposes, and for fun, with the help of Cycript.

![Auto-open](https://cloud.githubusercontent.com/assets/5389084/21757423/647cc5b8-d669-11e6-8b3a-90855c444b00.gif)

## How it works
When the chat view becomes visible, the tweak scans the visible cells for a red envelope cell. If the red envelope hasn't previously been opened, the tweak will try to open it.

## Opening speed
In order to make it less suspicious, there's a delay added to the opening of envelopes. It's still quicker to manually open them (if on a good internet connection), but the tweak will usually be one of the first five to open an envelope in a group chat.

## Error handling
The tweak currently handles two corner cases:

1. A red envlope has already been opened by other people in a group
2. Envelope opening fails, and an alert gets shown (no internet connection for instance)

## Settings
Added a cell for configuration under "Settings" in the "Me" tab.

## Installation
Make sure you have [Theos](https://github.com/theos/theos) installed (guide found [here](http://iphonedevwiki.net/index.php/Theos/Setup)), with the `$THEOS` and `$THEOS_DEVICE_IP` variables configured. 

After that just run `make package install` in the console from the project directory.

## Credits
Many thanks to [Wencharm](https://github.com/wencharmwang) for providing me with a temporary test account, and to Theo for providing me with two incredibly crisp and beautiful icons!
