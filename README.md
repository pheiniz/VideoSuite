VideoSuite
==========

Interactive Information Aggregation for Video Content

This is just the first prototype to showcase the idea behind a rich interaction with the a video source. It's a very early alpha version and got plenty of issues besides many hacks in code.
But first the idea: I aimed to develop a video player for touch interfaces that goes beyond simple playback of the source. It should aggregate all accessible information and put it on top of the video in several information layers.
First, before the movie starts, you will see all static informations which are available. Sources are IMDB, Rotten Tomatoes, TMDb, you name it.
![Start](pheiniz.github.com/VideoSuite/gh-pages/init.png)
While movie is running, you should be able to select an actor's face to get more informations immediately. Soundtrack is recognized when music plays. Informations to the scene as well as user somments should be presented in real-time in later development stages.
![Plain](pheiniz.github.com/VideoSuite/gh-pages/clean.png) ![Layers](pheiniz.github.com/VideoSuite/gh-pages/layer.png)

This repo works only on iPads (iOS 5 or higher) due to the compiling of the echolib library. You should compile a version for simulator if you really need it (see http://echoprint.me/ for more information).
Additionally you need API keys for [Echoprint](http://echoprint.me/), [Rekognition](http://rekognition.com/), [TMDb](http://www.themoviedb.org/documentation/api), and [Rotten Tomatoes](http://developer.rottentomatoes.com/). I know, that's a lot, but this App does a lot too ;)
Well, have fun!
