This is my personal quickshell configuration. More explanations and intentions will be written as this configuration comes close to an end.

# Wallpapers

This quickshell configuration uses SWWW to change the wallpaper every 4 minutes. 
Since it's not smart to read files outside the configuration the images will be located here.

Here's the breakdown of the folders.

### Time folders
When the weather is other than the 4 specified ones then the folders ``day``, ``evening`` and ``night`` will be used. Any pictures that I'd like during these times are located here. All of these folders are located at the root of the wallpaper folder. 

An example would look like this.

```
wallpapers
|___day
|     image.jpg
|     image.png
|
|___evening
|     image.jpg
|     image.png
|
|___night
|     image.jpg
|     image.png
```

### Weather folders
For now these "special" folders are for ``rain``, ``snow``, ``fog`` and ``sleet``. Each of these folders also have ``day``, ``evening`` and ``night`` folders. Maybe one day I'll add folders for cloudy environments as well. 

Here's an example of the structure.

```
wallpapers
|___day
|   |  image.jpg
|   |  image.png
|
|___evening
|   |  image.jpg
|   |  image.png
|
|___night
|   |  image.jpg
|   |  image.png
|
|___rain
|   |__day
|   |  |  image.jpg
|   |  |  image.png
|   |  
|   |__evening
|   |  |  image.jpg
|   |  |  image.png
|   |
|   |__night
|   |  |  image.jpg
|   |  |  image.png
```

## Why so specific?
I just thought that having your system be able to change wallpapers according to weather would be cool. I like doing things very specific and complicated for some reason. You might have noticed that the wallpaper changes when the minute is divisible by 4 and not every 4 minutes since startup. That's just the way I am and wallpapers are one of the things I made this way. I'm considering in making my own wallpaper engine but first I'll have to test its performance compared to SWWW.

