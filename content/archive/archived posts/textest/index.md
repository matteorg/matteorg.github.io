---
authors:
- admin
- 吳恩達
categories:
- Demo
- 教程
date: "2022-10-23T00:00:00Z"
draft: false
featured: false
image:
  caption: 'Image credit: [**aspose**](https://blog.aspose.com/2021/04/13/convert-tex-latex-to-pdf-xps-csharp/images/TeX-to-PDF-XPS.png)'
  focal_point: ""
  placement: 2
  preview_only: false
lastmod: "2022-10-23T00:00:00Z"
projects: []
subtitle: "Welcome \U0001F44B In this page you can compile some pdf documents."
summary: "Welcome \U0001F44B In this page you can compile some pdf documents."
title: Compile PDF online
---


<head>
    <!-- Basic Page Needs
    –––––––––––––––––––––––––––––––––––––––––––––––––– -->
    <!--meta charset="utf-8">
    <title>SwiftLaTeX: WYSIWYG LaTeX Editor for Browsers</title>
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Mobile Specific Metas
    –––––––––––––––––––––––––––––––––––––––––––––––––– -->
    <!--meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- FONT
    –––––––––––––––––––––––––––––––––––––––––––––––––– -->
    <link href='//fonts.googleapis.com/css?family=Raleway:400,300,600' rel='stylesheet' type='text/css'>
    <!-- CSS
    –––––––––––––––––––––––––––––––––––––––––––––––––– -->
    <!--link rel="stylesheet" href="css/normalize.css">
    <link rel="stylesheet" href="css/skeleton.css">
    <link rel="stylesheet" href="css/custom.css">
    <link rel="stylesheet" href="css/nprogress.css"-->
    <style type="text/css" media="screen">
        #demoframe {
            width: 100%;
            border: 0;
        }
        #demoselector {
            color: red;
            border-color: red;
            display: inline;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-fork-ribbon-css/0.2.3/gh-fork-ribbon.min.css" />
</head>


## Tester

<div class="docs-section" id="demo">
  <h6 class="docs-header">Select a demo:
  <select id="demoselector" onchange="selectDemo(this)">
      <option value="textest.html" selected="selected">Tex Compiler demo</option>
      <option value="pdftex_basic.html">PdfTeX basic demo (IEEEConf)</option>
      <option value="xetex_basic.html">XeTeX basic demo (acmart)</option>
      <option value="xetex_cjk.html">XeTeX Chinese/Japanese demo</option>
      <option value="xetex_font.html">XeTeX TrueType demo</option>
      <option value="xetex_tikz.html">XeTeX Tikz demo</option>
      <option value="xetex_beamer.html">XeTeX Beamer demo</option>
      <option value="pdftex_beamer.html">PdfTeX Beamer demo</option>
      <option value="pdftex_utf8.html">PdfTeX UTF8 demo</option>
      <option value="pdftex_tikz.html">PdfTeX Tikz demo</option>
  </select></h6>
  <h6>It may take a few minutes to download template files for the first time. Please be patient</h6>
  <iframe src="textest.html" id="demoframe" scrolling="no"></iframe>
</div>

## Overview

<script>
    const iframeobj = document.getElementById("demoframe");
    function selectDemo(selectObject) {
        const value = selectObject.value;
        iframeobj.src = value;
    }
    function resizeIframe(obj){
     obj.style.height = (obj.contentWindow.document.body.scrollHeight + 25) + 'px';
    }
    async function checkTexlive() {
      const ran = Math.random();
      const req = await fetch(`https://texlive.swiftlatex.com/texlive_version?v=${ran}`);
      if (req.status == 200) {
        await req.text();
      }
    }
    setInterval(()=>{resizeIframe(iframeobj)}, 500);
    setInterval(()=>{checkTexlive()}, 5000);
</script>