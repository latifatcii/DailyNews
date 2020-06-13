# Daily News

Hey ! Daily News is a news app with good looking user interface ! Apps architecture is MVVM and used RxSwift for binding. <br />

# Architecture
I preferred MVVM for this project because its more testable and maintainable than MVC. And VIPER would be an overkill for this project. I have solved binding problem with Functional Programming using RxSwift.  

# Features
-Functional Programming with RxSwift <br />
-Nested collection views. <br />
-Custom views and layouts <br />
-Pagination <br />
-Programmatically UI <br />
-Unit Tests for networking and view models.

# Todos
-Implement side Menu with screen edge pan and tap gestures. <br />
-Add Unit tests for Search Screen <br />
-Add refreshing to every screens. <br />
-Subscribe to errors and show alert. <br />

## Upcoming
-I will use Apple's Combine framework and Delegation Pattern for binding in different branches to see cons and pros of three different binding solution for MVVM.

## 3rd Party Libraries
-[SDWebImage](https://github.com/SDWebImage/SDWebImage) <br />
-[RxSwift](https://github.com/ReactiveX/RxSwift)  <br />
-[TinyConstraints](https://github.com/roberthein/TinyConstraints) <br />

## Usage
It is powered by NewsAPI! You should get your free developer API key from [NewsAPI](https://newsapi.org) and add it to DailyNews/Networking/APISettings.swift. 

# ScreenShots

![](DailyNewsScreenShots/dailyNewsScreenshot.png)
![](DailyNewsScreenShots/news.png)
![](DailyNewsScreenShots/sideMenu.png)
![](DailyNewsScreenShots/sideMenu2.png)
![](DailyNewsScreenShots/categories.png)
![](DailyNewsScreenShots/categories2.png)
![](DailyNewsScreenShots/search.png)
![](DailyNewsScreenShots/sources.png)


## License

MIT
