---
authors:
- admin
- 吳恩達
categories:
- Demo
- 教程
date: "2020-12-13T00:00:00Z"
draft: false
featured: false
image:
  caption: 'Image credit: [**Unsplash**](https://unsplash.com/photos/CpkOjOcXdUY)'
  focal_point: ""
  placement: 2
  preview_only: false
lastmod: "2020-12-13T00:00:00Z"
projects: []
subtitle: "Welcome \U0001F44B We know that first impressions are important, so we've
  populated your new site with some initial content to help you get familiar with
  everything in no time."
summary: "Welcome \U0001F44B We know that first impressions are important, so we've
  populated your new site with some initial content to help you get familiar with
  everything in no time."
tags:
- Academic
- 开源
title: Welcome to Wowchemy, the website builder for Hugo
---

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />

  <title>REPL</title>

  <link rel="icon" type="image/png" href="favicon.png" />
  <link rel="stylesheet" href="https://pyscript.net/latest/pyscript.css" />
  <script defer src="https://pyscript.net/latest/pyscript.js"></script>
  
  <script type="text/javascript">
    /* <![CDATA[ */
        // flattr button
        (function() {
            var s = document.createElement('script'), t = document.getElementsByTagName('script')[0];
            s.type = 'text/javascript';
            s.async = true;
            s.src = 'http://api.flattr.com/js/0.6/load.js?mode=auto';
            t.parentNode.insertBefore(s, t);
        })();
    /* ]]> */</script>

</head>


```python
import libr
print('hello')
```

<py-env>
  - paths:
      - tester.py
      - tex/template.tex
      - data/input.csv
</py-env>

## Tester

<py-script>
from tester import create_tex_template, create_tex_file
template = create_tex_template()
create_tex_file(template, 1)

</py-script>


## Overview

1. The Wowchemy website builder for Hugo, along with its starter templates, is designed for professional creators, educators, and teams/organizations - although it can be used to create any kind of site
2. The template can be modified and customised to suit your needs. It's a good platform for anyone looking to take control of their data and online identity whilst having the convenience to start off with a **no-code solution (write in Markdown and customize with YAML parameters)** and having **flexibility to later add even deeper personalization with HTML and CSS**
3. You can work with all your favourite tools and apps with hundreds of plugins and integrations to speed up your workflows, interact with your readers, and much more

[![The template is mobile first with a responsive design to ensure that your site looks stunning on every device.](https://raw.githubusercontent.com/wowchemy/wowchemy-hugo-modules/main/starters/academic/preview.png)](https://wowchemy.com)

## Get Started

- 👉 [**Create a new site**](https://wowchemy.com/templates/)
- 📚 [**Personalize your site**](https://wowchemy.com/docs/)
- 💬 [Chat with the **Wowchemy community**](https://discord.gg/z8wNYzb) or [**Hugo community**](https://discourse.gohugo.io)
- 🐦 Twitter: [@wowchemy](https://twitter.com/wowchemy) [@GeorgeCushen](https://twitter.com/GeorgeCushen) [#MadeWithWowchemy](https://twitter.com/search?q=%23MadeWithWowchemy&src=typed_query)
- 💡 [Request a **feature** or report a **bug** for _Wowchemy_](https://github.com/wowchemy/wowchemy-hugo-themes/issues)
- ⬆️ **Updating Wowchemy?** View the [Update Tutorial](https://wowchemy.com/docs/hugo-tutorials/update/) and [Release Notes](https://wowchemy.com/updates/)

## Crowd-funded open-source software

To help us develop this template and software sustainably under the MIT license, we ask all individuals and businesses that use it to help support its ongoing maintenance and development via sponsorship.

### [❤️ Click here to become a sponsor and help support Wowchemy's future ❤️](https://wowchemy.com/sponsor/)

As a token of appreciation for sponsoring, you can **unlock [these](https://wowchemy.com/sponsor/) awesome rewards and extra features 🦄✨**

## Ecosystem

- **[Hugo Academic CLI](https://github.com/wowchemy/hugo-academic-cli):** Automatically import publications from BibTeX

## Inspiration

[Check out the latest **demo**](https://academic-demo.netlify.com/) of what you'll get in less than 10 minutes, or [view the **showcase**](https://wowchemy.com/user-stories/) of personal, project, and business sites.

## Features

- **Page builder** - Create _anything_ with [**widgets**](https://wowchemy.com/docs/page-builder/) and [**elements**](https://wowchemy.com/docs/content/writing-markdown-latex/)
- **Edit any type of content** - Blog posts, publications, talks, slides, projects, and more!
- **Create content** in [**Markdown**](https://wowchemy.com/docs/content/writing-markdown-latex/), [**Jupyter**](https://wowchemy.com/docs/import/jupyter/), or [**RStudio**](https://wowchemy.com/docs/install-locally/)
- **Plugin System** - Fully customizable [**color** and **font themes**](https://wowchemy.com/docs/customization/)
- **Display Code and Math** - Code highlighting and [LaTeX math](https://en.wikibooks.org/wiki/LaTeX/Mathematics) supported
- **Integrations** - [Google Analytics](https://analytics.google.com), [Disqus commenting](https://disqus.com), Maps, Contact Forms, and more!
- **Beautiful Site** - Simple and refreshing one page design
- **Industry-Leading SEO** - Help get your website found on search engines and social media
- **Media Galleries** - Display your images and videos with captions in a customizable gallery
- **Mobile Friendly** - Look amazing on every screen with a mobile friendly version of your site
- **Multi-language** - 34+ language packs including English, 中文, and Português
- **Multi-user** - Each author gets their own profile page
- **Privacy Pack** - Assists with GDPR
- **Stand Out** - Bring your site to life with animation, parallax backgrounds, and scroll effects
- **One-Click Deployment** - No servers. No databases. Only files.

## Themes

Wowchemy and its templates come with **automatic day (light) and night (dark) mode** built-in. Alternatively, visitors can choose their preferred mode - click the moon icon in the top right of the [Demo](https://academic-demo.netlify.com/) to see it in action! Day/night mode can also be disabled by the site admin in `params.toml`.

[Choose a stunning **theme** and **font**](https://wowchemy.com/docs/customization) for your site. Themes are fully customizable.

## License

Copyright 2016-present [George Cushen](https://georgecushen.com).

Released under the [MIT](https://github.com/wowchemy/wowchemy-hugo-themes/blob/master/LICENSE.md) license.

<script>
  var visibilityChanger = function(element_id) {
    return function(visible) {
      document.getElementById(element_id).style.display = visible ? 'block' : 'none';
    }
  }

  var showLoadingIndicator = visibilityChanger("running")
  var showOpenButton = visibilityChanger("tab_open_pdf")

  var appendOutput = function(msg) {
    var output = document.getElementById("output");
    var content = output.textContent;
    output.textContent = content + "\r\n" + msg;
    output.scrollTop = 999999;
    console.log(msg);
  }

  var pdf_dataurl = undefined;
  var compile = function(source_code) {
    document.getElementById("output").textContent = "";
    showLoadingIndicator(true);
    window.location.href = "#running";
    
    var pdftex = new PDFTeX();
    pdftex.set_TOTAL_MEMORY(80*1024*1024).then(function() {
      pdftex.FS_createLazyFile('/', 'snowden.jpg', 'snowden.jpg', true, true);

      pdftex.on_stdout = appendOutput;
      pdftex.on_stderr = appendOutput;

      console.time("Execution time");

      pdftex.compile(source_code).then(function(pdf_dataurl) {
        console.timeEnd("Execution time");

        showLoadingIndicator(false);

        if (pdf_dataurl === false)
          return;

        showOpenButton(true);
        window.location.href = "#open_pdf";
        document.getElementById("open_pdf_btn").focus();
      });
    });
  }

  document.getElementById("compile").addEventListener("click", function(e) {
    var source_code = document.getElementById("input").value;
    compile(source_code);
  });

  document.getElementById("open_pdf_btn").addEventListener("click", function(e) {
    window.open(pdf_dataurl);
    e.preventDefault();
  });

  var pdftex_preload = new PDFTeX("pdftex-worker.js");
  pdftex_preload = undefined;
</script>
