---
title: Technology and Platforms
layout: single
toc: true
toc_label: "Developer and Pedagogical Tech"
tags: syllabus 4400 grades policies 
---

As a course and a student body, we are more remote than usual, and
preferable. To help bridge the chasm, I will leverage some of the
technology platforms Northeastern makes available to us.

## [Duo 2FA](https://get2fa.northeastern.edu/)

Most if not all students will already have enrolled themselves for the
Duo 2FA system. It is essential that you do so to access
Northeastern's digital resources. Northeastern has at least two
tutorials for installing and using the Duo 2FA system:

   - [The express version](https://express.northeastern.edu/get2fa/how-to-enroll-in-2fa/)
   - [The `servicenow` guide, (with pictures)](https://northeastern.service-now.com/kb_view.do?sys_kb_id=436cd1dbdb808854c5575e38dc9619e3&sysparm_class_name=kb_knowledge)

## Piazza 

[Piazza.com](http://piazza.com/) hosts our main Q&A forum. We are everyone learning; no one
knows all the answers, and remember that everyone wears their best and
most knowledgeable face. For questions related to the course material,
assignments, policies, or what have you, please utilize Piazza. I
generally prefer anonymous Piazza posts over email---this way others
get the benefit of your thoughtful question and answers and
corrections scale to the size of our class. Please do anonymize them
if you wish; we can see even if you cannot. Frequently someone will
have the same concern or be feeling the same way.

 If it doesn't "give away the punchline" of some homework question or
 assignment, *necessitate* PII in the question or the answer, and isn't
 contrary to FERPA or your rights under the Northeastern University
 Handbook, please do consider if this can be a Piazza message.

## KCCS/CCIS/CCS Github

Historically, this course used the Khoury Enterprise git host at
`http://ccs.github.neu.edu` (now retired/unavailable).

For Spring 2021 CS4400, use the public course repository:
[https://github.com/jasonhemann/21SP-CS4400](https://github.com/jasonhemann/21SP-CS4400).

## Course Homepage

I constructed our course homepage as a Jekyll site built with Github
Pages. Student corrections and improvements are *incredibly* welcome!
You can submit a [pull request
(PR)](https://github.com/jasonhemann/21SP-CS4400) for a quick
correction and improvement. Every page on this website has a direct
links to its `.md` file in this repository.

## Handin Server

We will use the [Handin server](http://handins.ccs.neu.edu/) (bottlenose) to submit homework. You
will likely have experience with this platform from Fundies I; if you
do not, please read the [Handin Server Guide](http://ccs.neu.edu/home/blerner/handin-server/handin-server-guide.html). 

## PollEverywhere

As a part of a participation grade, I will be asking poll questions in
class (often several per class). These will constitute a part of your
grade. I will expect you to login to answer, during the class period
itself. You should ensure that you have added your northeastern
university email address account, and have this active and enabled.

You can use the web browser, the [desktop app](https://www.polleverywhere.com/desktop-beta), or the mobile app
[(Apple)](https://apps.apple.com/us/app/poll-everywhere/id893375312) [(Android)](https://play.google.com/store/apps/details?id=com.polleverywhere.mobile&hl=en_US). Regardless of however you configure this, have it
with you and available at all times.

There is a [KB Article](https://service.northeastern.edu/tech?id=kb_article&sys_id=69a02a6fdb0d001084ba5595ce96199c) on logging in via Northeastern.

## Zoom 

I intend to broadcast our course meetings via [Northeastern Zoom](https://northeastern.zoom.us/). I
prefer it over MS Teams for a variety of reasons. Not the least of
which is the instantaneous and anonymous feedback that it provides,
via [Dial testing](https://www.dialsmith.com/blog/dial-testing-vs-focus-groups-how-are-they-different/). You will find it helpful to have two
internet-enabled devices with at hand when you are attending class
remotely, once for viewing the class and a second for answering poll
questions.

### Via direct installation. 

If you have difficulty installing or using the platform please see
ITS' associated [KB article](https://support.zoom.us/hc/en-us) or contact [Zoom support](https://support.zoom.us/hc/en-us).

### Via the browser

You also have the option to join without downloading or installing any
software, via the [Zoom web client](https://support.zoom.us/hc/en-us/articles/214629443-Zoom-web-client). The web client does not have all
the functionality of the desktop or mobile apps; please see the
comparison [here](https://support.zoom.us/hc/en-us/articles/360027397692#query:~:text=Note%3A,-We). 

## NEU VPN 

Go to [https://vpn.northeastern.edu](https://vpn.northeastern.edu), and follow the instructions to
install the GlobalProctect VPN client on your machine. You will need
this to use the VDI linux machines. If you have difficulty please
consult the [relevant ITS KB articles](http://northeastern.service-now.com/tech?id=kb_category&kb_category=07d42f714f02cf0099c2fd511310c7b2), and if necessary [reach out to
ITS support](https://its.northeastern.edu/resources/).

## VDI Linux Machines 

[Khoury VDI Virtual
Desktops](https://web.archive.org/web/20200815193823/http://khoury.northeastern.edu/systems/vdi/), and the
[relevant ITS KB
articles](http://northeastern.service-now.com/tech?id=kb_category&kb_category=6b863d8d4f3b5b4450a5798e0210c735&kb_id=d82ad28c134922401528f5104244b068).

## Racket

[Download](https://download.racket-lang.org/) and install Racket and
the DrRacket integrated development environment. To begin with, I will
use DrRacket in front of the classroom to demonstrate Racket and
miniKanren programming, and I want you all to follow along and to
practice during designated practice periods.

### Rackunit

We will also use the
[Rackunit](https://docs.racket-lang.org/rackunit/) unit testing
framework. This is another Racket package. We will use this as a
substitute for the `check-expect` you might have come to appreciate if
you have already taken Fundamentals I at NEU. We make this
substitution because `check-expect` doesn't exist in the full `racket`
language.

### miniKanren 

I will base our discussion, usage, and implementation around the
miniKanren language. You can install this in DrRacket via the
`faster-minikanren` package in the package manager. You can also
(likely) find this implemented for the language of your choice at
[http://minikanren.org]. We will at first use the Racket
implementation 

### Other packages as they come up

Prepare yourself to download and install other packages as necessary
to make our test suites run. You will not need any additional packages
to complete your homework, nor should you use them. 

## Applause!

One of the things I miss most about real, in-person classrooms is
being able to applaud someone for a job well done, and for giving it a
shot. Here's our best alternative (historical, now offline). If each of us
goes here and enters his or her name then, when one of us presses the
applause button, we can all see and hear it.
