# epiquiz - Shiny app to generate a quiz from Google forms input

A short script in Shiny and R to create a web-accessible application, that takes data as stored in a publicly available Google Sheets file online and presents it as in a flash cards interface, organised into Themes, Questions, Answers (hide/show). As data is stored remotely in Google Sheets, and entries are able to be created using a system such as Google Forms, this is a low-maintenance way of presenting information that is able to be safely stored in the Google cloud ecosystem.

Shiny theming by default is based on bootstrap, so bootstrap themes should work out of the box. 

Themes as described on the Shiny webpage:

- https://shiny.rstudio.com/articles/css.html
- http://bootswatch.com/


## About

This small app was created when we were studying for our Membership of the Australian and New Zealand College of Veterinary Scientists, epidemiology chapter examinations. A need was identified for a way of testing ourselves with some questions in a more distributable way than physical flash cards. As there were drawings, equations and different types of text, using markdown presented in a shiny app was considered ideal. 

## Acknowledgements

Much thanks to other members of the Victorian study group, along with Dr Jaimie Hunnam of the Department of Economic Development, Jobs, Transport and Resources for generously providing her study card material. Material may have been modified or slighly edited from the source, to further elaborate, clarify or otherwise reword the questions or answers
