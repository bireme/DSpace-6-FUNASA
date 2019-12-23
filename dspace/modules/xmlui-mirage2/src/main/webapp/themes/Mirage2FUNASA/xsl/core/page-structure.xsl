<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
xmlns:dri="http://di.tamu.edu/DRI/1.0/"
xmlns:mets="http://www.loc.gov/METS/"
xmlns:xlink="http://www.w3.org/TR/xlink/"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:mods="http://www.loc.gov/mods/v3"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:confman="org.dspace.core.ConfigurationManager"
xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).

        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information

        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->
    <xsl:template match="dri:document">

    <xsl:choose>
    <xsl:when test="not($isModal)">


    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
</xsl:text>
<xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7]&gt; &lt;html class=&quot;no-js lt-ie9 lt-ie8 lt-ie7&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
&lt;!--[if IE 7]&gt;    &lt;html class=&quot;no-js lt-ie9 lt-ie8&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
&lt;!--[if IE 8]&gt;    &lt;html class=&quot;no-js lt-ie9&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
&lt;!--[if gt IE 8]&gt;&lt;!--&gt; &lt;html class=&quot;no-js&quot; lang=&quot;en&quot;&gt; &lt;!--&lt;![endif]--&gt;
</xsl:text>

<!-- First of all, build the HTML head element -->

<xsl:call-template name="buildHead"/>

<!-- Then proceed to the body -->
<body id="mainbody" onload="acessibilidade();">
                    <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
                       chromium.org/developers/how-tos/chrome-frame-getting-started -->
                       <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->
                       <xsl:choose>
                       <xsl:when
                       test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                       <xsl:apply-templates select="dri:body/*"/>
                   </xsl:when>
                   <xsl:otherwise>
                   <xsl:call-template name="buildHeader"/>


                   <xsl:choose>
                   <xsl:when test="string-length(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']) > 0">
                   <xsl:call-template name="buildTrail"/>
               </xsl:when>
               <xsl:otherwise>
               <xsl:call-template name="buildFrontSearch" />
           </xsl:otherwise>
       </xsl:choose>


       <!--javascript-disabled warning, will be invisible if javascript is enabled-->
       <div id="no-js-warning-wrapper" class="hidden">
        <div id="no-js-warning">
            <div class="notice failure">
                <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
            </div>
        </div>
    </div>

    <div id="main-container" class="container maxfunasa">


        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">  
        <div class="row row-offcanvas row-offcanvas-right">
            <div class="horizontal-slider clearfix">

                <div class="col-xs-12 col-sm-12 col-md-9 main-content" id="main_container">

                    <xsl:if test="starts-with($request-uri, 'page/accesibility')">
                            <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                            <xsl:variable name="staticpage" select="concat('../../accesibility_',$active-locale)" />

                            <xsl:copy-of select="document(concat($staticpage,'.xml'))" />
                    </xsl:if>

                    <xsl:if test="starts-with($request-uri, 'page/governance_policy')">
                            <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                            <xsl:variable name="staticpage" select="concat('../../governance_policy_',$active-locale)" />

                            <xsl:copy-of select="document(concat($staticpage,'.xml'))" />
                    </xsl:if>

                </div>

                <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                    <xsl:apply-templates select="dri:options"/>
                </div>

            </div>
        </div>
        </xsl:if>


    <!-- Este es el home -->

    <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 1">

    <div class="row row-offcanvas row-offcanvas-right">
        <div class="horizontal-slider clearfix">




            <div class="col-xs-12 col-sm-12 col-md-12 main-content" id="main_container">      
                <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                                 <!-- <h2 class="ds-div-head page-header orange"><i18n:text>xmlui.ArtifactBrowser.SiteViewer.head_featured_items</i18n:text></h2>
                                                   <xsl:apply-templates select="//dri:div[@id='aspect.browseArtifacts.SiteFeaturedItems.div.site-featured-items']" mode="show"/>
                                                         
                                                   <h2 class="ds-div-head page-header orange"><i18n:text>xmlui.ArtifactBrowser.SiteViewer.head_recent_submissions</i18n:text></h2>
                                                  <xsl:apply-templates select="//dri:div[@id='aspect.discovery.SiteRecentSubmissions.div.site-home']" mode="show"/>
                                                  
                                              -->


                                          </div>
                                      </div>
                                  </div>  
                              </xsl:if>

                              <div class="row row-offcanvas row-offcanvas-right">
                                <div class="horizontal-slider clearfix">
                                    <hr />
                                    <div class="text-right">  <a class="voltar-topo-a" href="#mainbody">
                                      <i18n:text>xmlui.home.gotop</i18n:text>
                                      <xsl:text> </xsl:text>
                                      <img src="{$theme-path}images/voltar.png" />
                                  </a> </div>
                                  <hr />
                                  <p class="text-center" style="padding:10px;">Todo o conteúdo deste site está publicado sob licencia <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional</a></p>
                                  <hr />

                              </div>
                          </div>      


                      </div>

                  </xsl:otherwise>
              </xsl:choose>




              <!-- Javascript at the bottom for fast page loading -->

              <xsl:call-template name="buildFooter"/>
              <xsl:call-template name="addJavascript"/>




          </body>

          <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>
          <script defer="defer" src="//barra.brasil.gov.br/barra.js" type="text/javascript"></script>

      </xsl:when>
      <xsl:otherwise>
                <!-- This is only a starting point. If you want to use this feature you need to implement
                    JavaScript code and a XSLT template by yourself. Currently this is used for the DSpace Value Lookup -->
                    <xsl:apply-templates select="dri:body" mode="modal"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
             <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

             <!-- Mobile viewport optimized: h5bp.com/viewport -->
             <meta name="viewport" content="width=device-width,initial-scale=1"/>

             <link rel="shortcut icon">
             <xsl:attribute name="href">
             <xsl:value-of select="$theme-path"/>
             <xsl:text>images/favicon.ico</xsl:text>
         </xsl:attribute>
     </link>
     <link rel="apple-touch-icon">
     <xsl:attribute name="href">
     <xsl:value-of select="$theme-path"/>
     <xsl:text>images/apple-touch-icon.png</xsl:text>
 </xsl:attribute>
</link>

<meta name="Generator">
<xsl:attribute name="content">
<xsl:text>DSpace</xsl:text>
<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
<xsl:text> </xsl:text>
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
</xsl:if>
</xsl:attribute>
</meta>

<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS'][not(@qualifier)]">
<meta name="ROBOTS">
<xsl:attribute name="content">
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS']"/>
</xsl:attribute>
</meta>
</xsl:if>

<!-- Add stylesheets -->

<!--TODO figure out a way to include these in the concat & minify-->
<xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
<link rel="stylesheet" type="text/css">
<xsl:attribute name="media">
<xsl:value-of select="@qualifier"/>
</xsl:attribute>
<xsl:attribute name="href">
<xsl:value-of select="$theme-path"/>
<xsl:value-of select="."/>
</xsl:attribute>
</link>
</xsl:for-each>

<link rel="stylesheet" href="{concat($theme-path, 'styles/main.css')}"/>

<!-- Add syndication feeds -->
<xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
<link rel="alternate" type="application">
<xsl:attribute name="type">
<xsl:text>application/</xsl:text>
<xsl:value-of select="@qualifier"/>
</xsl:attribute>
<xsl:attribute name="href">
<xsl:value-of select="."/>
</xsl:attribute>
</link>
</xsl:for-each>

<!--  Add OpenSearch auto-discovery link -->
<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
<link rel="search" type="application/opensearchdescription+xml">
<xsl:attribute name="href">
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
<xsl:text>://</xsl:text>
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
<xsl:text>:</xsl:text>
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
<xsl:value-of select="$context-path"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='autolink']"/>
</xsl:attribute>
<xsl:attribute name="title" >
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
</xsl:attribute>
</link>
</xsl:if>

<!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
<!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
<script>
                //Clear default text of empty text areas on focus
                function tFocus(element)
                {
                    if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of empty text areas on submit
                function tSubmit(form)
                {
                    var defaultedElements = document.getElementsByTagName("textarea");
                    for (var i=0; i != defaultedElements.length; i++){
                        if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                            defaultedElements[i].value='';}}
                        }
                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                function disableEnterKey(e)
                {
                    var key;

                    if(window.event)
                key = window.event.keyCode;     //Internet Explorer
            else
                key = e.which;     //Firefox and Netscape

                if(key == 13)  //if "Enter" pressed, then disable!
                    return false;
                else
                    return true;
            }

     </script>

        <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
    &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
&lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/dest/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
&lt;![endif]--&gt;</xsl:text>

<!-- Modernizr enables HTML5 elements & feature detects -->
<script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

<!-- Add the title in -->
<xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]" />
<title>
    
    <xsl:choose>
    <xsl:when test="starts-with($request-uri, 'page/accesibility')">
        <i18n:text catalogue="default">xmlui.general.accesibility</i18n:text>
    </xsl:when>  
    <xsl:when test="starts-with($request-uri, 'page/governance_policy')">
        <i18n:text catalogue="default">xmlui.general.governance_policy</i18n:text>
    </xsl:when>
    <xsl:when test="starts-with($request-uri, 'page/about')">
        <i18n:text>xmlui.mirage2.page-structure.aboutThisRepository</i18n:text>
    </xsl:when>
    <xsl:when test="not($page_title)">
        <xsl:text>  </xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:copy-of select="$page_title/node()" />
    </xsl:otherwise>
    </xsl:choose>
    
    
</title>

<!-- Head metadata in item pages -->
<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
disable-output-escaping="yes"/>
</xsl:if>

<!-- Add all Google Scholar Metadata values -->
<xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
<meta name="{@element}" content="{.}"></meta>
</xsl:for-each>

<!-- Add MathJAX JS library to render scientific formulas-->
<xsl:if test="confman:getProperty('webui.browse.render-scientific-formulas') = 'true'">
<script type="text/x-mathjax-config">
    MathJax.Hub.Config({
    tex2jax: {
    ignoreClass: "detail-field-data|detailtable|exception"
},
TeX: {
Macros: {
AA: '{\\mathring A}'
}
}
});
</script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML">&#160;</script>
</xsl:if>

<link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />



           <!-- <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/solid.css" integrity="sha384-+0VIRx+yz1WBcCTXBkVQYIBVNEFH1eP6Zknm16roZCyeNg2maWEpk/l/KsyFKs7G" crossorigin="anonymous" />
            <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/fontawesome.css" integrity="sha384-jLuaxTTBR42U2qJ/pm4JRouHkEDHkVqH0T1nyQXn1mZ7Snycpf6Rl25VBNthU4z0" crossorigin="anonymous" /> -->

        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
        <xsl:template name="buildHeader">


        <!-- Barra Brasil -->
        <div id="barra-brasil" style="background:#7F7F7F; height: 20px; padding:0 0 0 10px;display:block;">
          <ul id="menu-barra-temp" style="list-style:none;">
            <li style="display:inline; float:left;padding-right:10px; margin-right:10px; border-right:1px solid #EDEDED">
                <a href="http://brasil.gov.br" style="font-gamilt:sans,sans-serif; text-decoration:none; color:white;">Portal do Governo Brasileiro</a>
            </li>
            <li>
               <a style="font-family:sans,sans-serif; text-decoration:none; color:white;" href="http://epwg.governoeletronico.gov.br/barra/atualize.html" target="_blank">Atualize sua Barra de Governo</a>
           </li>
       </ul>
   </div>



   <!-- header provided -->
   <div class="containerCabecalho">  

    <header class="containerTopo">		
     <div class="topo">

      <div class="marca">
       <a href="http://www.funasa.gov.br" target="_blank">
          <img class="logoFunasa" src="{$theme-path}images/marcaFunasa.png" /></a>
      </div>	
      <div class="nav-mobile">
        <span id="nav" class="icon-navbar fa fa-navicon"></span>
    </div>

    <nav class="menuTopo hidden-xs">
       <ul>
        <li><a href="{$context-path}/community-list">Comunidades e Coleções</a></li>
        <li class="dropdown">
           <a href="#" class="dropdown-toggle" data-toggle="dropdown">Navegar</a><b class="caret"></b> 
           <ul class="dropdown-menu" role="menu">
              <li class="overwriteleft"><a href="{$context-path}/browse?type=title">Listar por Titulo</a></li>
              <li class="overwriteleft"><a href="{$context-path}/browse?type=author">Autor</a></li>
              <li class="overwriteleft"><a href="{$context-path}/browse?type=subject">Assunto</a></li>
          </ul>
      </li>

      <li><a href="{$context-path}/recent-submissions">Documentos</a></li>
  </ul>
</nav>

<nav class="menuAcessibilidade">

   <ul class="nav nav-pills pull-right">
      <div class="pull-left idoptions">
          <li><a href="{$context-path}/page/accesibility" class="hidden-xs">Acessibilidade</a></li>
      </div>

      <div class="pull-left idoptions">
          <li><a href="#" id="btnContrast" class="hidden-xs">Contraste</a></li>
      </div>   
      <!-- este es el copy del xsl de menues de idioma y usuario -->


      <div class="pull-right visible-xs hidden-sm hidden-md hidden-lg idoptions">
      	<li><a href="#" id="btnContrast2"><img src="{$theme-path}/images/contrast.svg" alt="" class="iconContrast" /></a></li>

        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
        <li id="ds-language-selection-xs" class="dropdown">
            <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
            <button id="language-dropdown-toggle-xs" href="#" role="button" class="dropdown-toggle navbar-toggle navbar-link" data-toggle="dropdown">
                <b class="visible-xs glyphicon glyphicon-globe" aria-hidden="true"/>
            </button>
            <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle-xs" data-no-collapse="true">
                <xsl:for-each
                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                <xsl:variable name="locale" select="."/>
                <li role="presentation">
                    <xsl:if test="$locale = $active-locale">
                    <xsl:attribute name="class">
                    <xsl:text>disabled</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                <xsl:value-of select="$current-uri"/>
                <xsl:text>?locale-attribute=</xsl:text>
                <xsl:value-of select="$locale"/>
            </xsl:attribute>
            <xsl:value-of
            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
        </a>
    </li>
</xsl:for-each>
</ul>
</li>
</xsl:if>

<xsl:choose>
<xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
<li class="dropdown">
    <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button"  data-toggle="dropdown">
        <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
    </button>
    <ul class="dropdown-menu pull-right" role="menu"
    aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
    <li>
        <a href="{/dri:document/dri:meta/dri:userMeta/
        dri:metadata[@element='identifier' and @qualifier='url']}">
        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
    </a>
</li>
<li>
    <a href="{/dri:document/dri:meta/dri:userMeta/
    dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
</a>
</li>
</ul>
</li>
</xsl:when>
<xsl:otherwise>
<li>
    <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/
    dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
    <button class="navbar-toggle navbar-link">
        <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
    </button>
</form>
</li>
</xsl:otherwise>
</xsl:choose>

</div>


<div class="pull-right hidden-xs idoptions">
    <xsl:call-template name="languageSelection"/>
    <xsl:choose>
    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
    <li class="dropdown">
        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
        data-toggle="dropdown">
        <span class="hidden-xs">
            <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
            &#160;
            <b class="caret"/>
        </span>
    </a>
    <ul class="dropdown-menu pull-right" role="menu"
    aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
    <li>
        <a href="{/dri:document/dri:meta/dri:userMeta/
        dri:metadata[@element='identifier' and @qualifier='url']}">
        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
    </a>
</li>
<li>
    <a href="{/dri:document/dri:meta/dri:userMeta/
    dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
</a>
</li>
</ul>
</li>
</xsl:when>
<xsl:otherwise>
<li>
    <a href="{/dri:document/dri:meta/dri:userMeta/
    dri:metadata[@element='identifier' and @qualifier='loginURL']}">
    <span class="hidden-xs">
        <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
    </span>
</a>
</li>
</xsl:otherwise>
</xsl:choose>


</div>


<xsl:choose>
<xsl:when test="string-length(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']) > 0">
<div class="pull-right">
  <li>
      <button data-toggle="offcanvas" class="navbar-toggle visible-sm visible-xs" type="button">
        <span class="sr-only"><i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
</li>
</div>
</xsl:when>                            
</xsl:choose>

<!-- fin del copy -->



</ul>
</nav>

<div class="visible-xs topo">
  <nav class="menuTopo">
   <ul>
    <li><a href="{$context-path}/community-list">Comunidades &amp; Coleções</a></li>
    <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown">Navegar</a><b class="caret"></b> 
       <ul class="dropdown-menu" role="menu">
          <li class="overwriteleft"><a href="{$context-path}/browse?type=title">Listar por Titulo</a></li>
          <li class="overwriteleft"><a href="{$context-path}/browse?type=author">Autor</a></li>
          <li class="overwriteleft"><a href="{$context-path}/browse?type=subject">Assunto</a></li>
      </ul>
  </li>

  <li><a href="{$context-path}/recent-submissions">Documentos</a></li>
</ul>
</nav>
</div>

</div>
</header>  

<section class="idRepositorio">
   <div class="logoRepositorio">
    <!-- a href="{$context-path}" -->
    <a href="{$context-path}/">
        <img class="logoRCFunasa img-responsive" src="{$theme-path}images/logoRCFUNASA1.svg" />
    </a>
</div>	
<nav class="menuIdRepositorio hidden-xs">
    <ul class="linksocial">
     <li><a href="https://www.facebook.com/funasaoficial" target="_blank"><i class="fa fa-facebook-square"></i></a></li>
     <li><a href="https://www.instagram.com/funasa_oficial" target="_blank"><i class="fa fa-instagram"></i></a></li>
     <li><a href="https://www.youtube.com/user/Funasaoficial" target="_blank"><i class="fa fa-youtube-square"></i></a></li>
     <li><a href="https://twitter.com/funasa" target="_blank"><i class="fa fa-twitter-square"></i></a></li>
     <!-- antigo soundcloud-->
     <!-- <li><a href="https://soundcloud.com/funasaoficial"><i class="fa fa-soundcloud"></i></a></li> -->
     <!-- Novo Soundcloud -->
     <li>
        <a href="https://soundcloud.com/funasaoficial" target="_blank">
            <span class="fa-stack socialsound">
              <i class="fa fa-square fa-stack-2x"></i>
              <i class="fa fa-soundcloud fa-stack-1x fa-inverse"></i>
          </span>
      </a>
  </li>
  <li><a href="https://www.flickr.com/people/funasaoficial" target="_blank"><i class="fa fa-flickr"></i></a></li>

</ul>
</nav>	

<button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
    <span class="sr-only"><i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
</button>
</section> 

<hr class="linhaAzulFunasa" />

</div>


   </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
        <xsl:template name="buildTrail">
        <div class="trail-wrapper hidden-print">
            <div class="container maxfunasa">
                <div class="row">
                    <!--TODO-->
                    <div class="col-xs-12">
                        <xsl:choose>
                        <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                        <div class="breadcrumb dropdown visible-xs">
                            <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                            data-toggle="dropdown">
                            <xsl:variable name="last-node"
                            select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                            <xsl:choose>
                            <xsl:when test="$last-node/i18n:*">
                            <xsl:apply-templates select="$last-node/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                        <xsl:apply-templates select="$last-node/text()"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>&#160;</xsl:text>
                <b class="caret"/>
            </a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                mode="dropdown"/>
            </ul>
        </div>
        <ul class="breadcrumb hidden-xs">
            <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
        </ul>
    </xsl:when>
    <xsl:otherwise>
    <ul class="breadcrumb">
        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
    </ul>
</xsl:otherwise>
</xsl:choose>
</div>
</div>
</div>
</div>


</xsl:template>

<!--The Trail-->
<xsl:template match="dri:trail">
<!--put an arrow between the parts of the trail-->
<li>
    <xsl:if test="position()=1">
    <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
</xsl:if>
<!-- Determine whether we are dealing with a link or plain text trail link -->
<xsl:choose>
<xsl:when test="./@target">
<a>
    <xsl:attribute name="href">
    <xsl:value-of select="./@target"/>
</xsl:attribute>
<xsl:apply-templates />
</a>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="class">active</xsl:attribute>
<xsl:apply-templates />
</xsl:otherwise>
</xsl:choose>
</li>
</xsl:template>

<xsl:template match="dri:trail" mode="dropdown">
<!--put an arrow between the parts of the trail-->
<li role="presentation">
    <!-- Determine whether we are dealing with a link or plain text trail link -->
    <xsl:choose>
    <xsl:when test="./@target">
    <a role="menuitem">
        <xsl:attribute name="href">
        <xsl:value-of select="./@target"/>
    </xsl:attribute>
    <xsl:if test="position()=1">
    <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
</xsl:if>
<xsl:apply-templates />
</a>
</xsl:when>
<xsl:when test="position() > 1 and position() = last()">
<xsl:attribute name="class">disabled</xsl:attribute>
<a role="menuitem" href="#">
    <xsl:apply-templates />
</a>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="class">active</xsl:attribute>
<xsl:if test="position()=1">
<i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
</xsl:if>
<xsl:apply-templates />
</xsl:otherwise>
</xsl:choose>
</li>
</xsl:template>

<!--The License-->
<xsl:template name="cc-license">
<xsl:param name="metadataURL"/>
<xsl:variable name="externalMetadataURL">
<xsl:text>cocoon:/</xsl:text>
<xsl:value-of select="$metadataURL"/>
<xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
</xsl:variable>

<xsl:variable name="ccLicenseName"
select="document($externalMetadataURL)//dim:field[@element='rights']"
/>
<xsl:variable name="ccLicenseUri"
select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
/>
<xsl:variable name="handleUri">
<xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
<a>
    <xsl:attribute name="href">
    <xsl:copy-of select="./node()"/>
</xsl:attribute>
<xsl:copy-of select="./node()"/>
</a>
<xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
<xsl:text>, </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:variable>

<xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
<div about="{$handleUri}" class="row">
    <div class="col-sm-3 col-xs-12">
        <a rel="license"
        href="{$ccLicenseUri}"
        alt="{$ccLicenseName}"
        title="{$ccLicenseName}"
        >
        <xsl:call-template name="cc-logo">
        <xsl:with-param name="ccLicenseName" select="$ccLicenseName"/>
        <xsl:with-param name="ccLicenseUri" select="$ccLicenseUri"/>
    </xsl:call-template>
</a>
</div> <div class="col-sm-8">
    <span>
        <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
        <!-- xsl:value-of select="$ccLicenseName"/ -->
    </span>
</div>
</div>
</xsl:if>
</xsl:template>

<xsl:template name="cc-logo">
    <xsl:param name="ccLicenseName"/>
    <xsl:param name="ccLicenseUri"/>
    <xsl:variable name="ccLogo">
        <xsl:choose>
             <xsl:when test="starts-with($ccLicenseUri,'https://creativecommons.org/licenses/by-nc-sa/4.0/')">
                 <xsl:value-of select="'by-nc-sa-4_0-88x31.png'" />
             </xsl:when>
             <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by/')">
                 <xsl:value-of select="'cc-by.png'" />
             </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by-sa/')">
                <xsl:value-of select="'cc-by-sa.png'" />
             </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by-nd/')">
                <xsl:value-of select="'cc-by-nd.png'" />
            </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by-nc/')">
                <xsl:value-of select="'cc-by-nc.png'" />
            </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by-nc-sa/')">
                <xsl:value-of select="'cc-by-nc-sa.png'" />
            </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/licenses/by-nc-nd/')">
                <xsl:value-of select="'cc-by-nc-nd.png'" />
             </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/publicdomain/zero/')">
                <xsl:value-of select="'cc-zero.png'" />
            </xsl:when>
            <xsl:when test="starts-with($ccLicenseUri,'http://creativecommons.org/publicdomain/mark/')">
                 <xsl:value-of select="'cc-mark.png'" />
            </xsl:when>
            <xsl:otherwise>
                 <xsl:value-of select="'cc-generic.png'" />
            </xsl:otherwise>
         </xsl:choose>
     </xsl:variable>
     <img class="img-responsive">
         <xsl:attribute name="src">
             <xsl:value-of select="concat($theme-path,'/images/creativecommons/', $ccLogo)"/>
         </xsl:attribute>
         <xsl:attribute name="alt">
             <xsl:value-of select="$ccLicenseName"/>
         </xsl:attribute>
     </img>
</xsl:template>

<!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
<xsl:template name="buildFooter">


<footer>
  <div class="container maxfunasa">
    <div class="row">
        <div class="col-md-12">
          <h3>REDES SOCIAIS</h3>
          <ul class="socialnetwork">
        <li><a href="https://www.facebook.com/funasaoficial" target="_blank"><img src="{$theme-path}images/iconFooterFacebook.svg" /></a></li>
        <li><a href="https://www.instagram.com/funasa_oficial" target="_blank"><img src="{$theme-path}images/iconFooterInstagram.svg" /></a></li>
        <li><a href="https://www.youtube.com/user/Funasaoficial" target="_blank"><img src="{$theme-path}images/iconFooterYoutube.svg" /></a></li>
        <li><a href="https://twitter.com/funasa" target="_blank"><img src="{$theme-path}images/iconFooterTwitter.svg" /></a></li>
        <li><a href="https://soundcloud.com/funasaoficial" target="_blank"><img src="{$theme-path}images/iconFooterSoundcloud.svg" /></a></li>
        <li><a href="https://www.flickr.com/people/funasaoficial" target="_blank"><img src="{$theme-path}images/iconFooterFlickr.svg" /></a></li>
    </ul>
</div>
</div>
<hr />

<!-- Alterado Link Footer -->
<div class="row">
    <div class="col-sm-2">
        <nav class="" id="footer-navigation">
            <h3>REPOSITÓRIO FUNASA</h3> 
            <ul class="listagem-links"> 
                <li> <a href="{$context-path}/community-list" title="Comunidades e Coleções"><span>Comunidades e Coleções</span></a> </li> 
                <li> <a href="{$context-path}/recent-submissions" title="Documentos"><span>Documentos</span></a> </li> 
            </ul>
        </nav>
    </div>
     <div class="col-sm-2">
        <nav class="" id="footer-navigation"> 
            <h3>SOBRE A FUNDAÇÃO</h3>
            <ul class="listagem-links"> 
                <li> <a href="http://www.funasa.gov.br/a-funasa1" title="Quem somos" target="_blank">Quem somos</a> </li> 
                <li> <a href="http://www.funasa.gov.br/todas-as-noticias" title="Notícias" target="_blank">Notícias</a> </li> 
                <li> <a href="http://www.funasa.gov.br/biblioteca-eletronica" title="Publicações" target="_blank">Publicações</a> </li> 
                <li> <a href="http://www.funasa.gov.br/portarias-funasa" title="Portarias" target="_blank">Portarias</a> </li>
            </ul>
        </nav>
    </div> 
    <div class="col-sm-4">
        <nav class="" id="footer-navigation"> 
            <h3>ACESSO À INFORMAÇÃO ORGANIZACIONAL</h3>
            <ul class="listagem-links"> 
                <li> <a href="http://www.funasa.gov.br/institucional" title="Institucional" target="_blank">Institucional</a> </li>
                <li> <a href="http://www.funasa.gov.br/acoes-e-programas" title="Ações e Programas" target="_blank">Ações e Programas</a> </li>
                <li> <a href="http://www.funasa.gov.br/participacao-social" title="Participação Social" target="_blank">Participação Social</a> </li>
                <li> <a href="http://www.funasa.gov.br/auditorias" title="Auditorias" target="_blank">Auditorias</a> </li>
                <li> <a href="http://www.funasa.gov.br/convenios-e-tranferencias" title="Convênios e Transferências" target="_blank">Convênios e Transferências</a> </li>
                <li> <a href="http://www.funasa.gov.br/receitas-e-despesas" title="Receitas e Despesas" target="_blank">Receitas e Despesas</a> </li>
                <li> <a href="http://www.funasa.gov.br/licitacoes-e-contratos" title="Licitações e Contratos" target="_blank">Licitações e Contratos</a> </li>
                <li> <a href="http://www.funasa.gov.br/servidores" title="Servidores" target="_blank">Servidores</a> </li>
                <li> <a href="http://www.funasa.gov.br/informacoes-classificadas" title="Informações Classificadas" target="_blank">Informações Classificadas</a> </li>
                <li> <a href="http://www.funasa.gov.br/servico-de-informacao-ao-cidadao-sic" title="Serviço de Informação ao Cidadão" target="_blank">Serviço de Informação ao Cidadão</a> </li>
                <li> <a href=" http://www.funasa.gov.br/perguntas-frequentes" title="Perguntas Frequentes" target="_blank">Perguntas Frequentes</a> </li>
                <li> <a href="http://www.funasa.gov.br/dados-abertos" title="Dados Abertos" target="_blank">Dados Abertos</a> </li>
            </ul>
        </nav>
    </div>   
    <div class="col-sm-2">
        <nav class="" id="footer-navigation"> 
        <h3>CONTATO</h3>
            <ul class="listagem-links"> 
                <li> <a href="http://www.funasa.gov.br/enderecos" title="Fale conosco" target="_blank">Fale conosco</a> </li> 
            </ul>
        </nav>
    </div>   
    <div class="col-sm-2">
        <nav class="" id="footer-navigation"> 
            <h3>MANUAIS</h3>
            <ul class="listagem-links"> 
                <li> <a href="" target="_self" title="Uso do repositório Funasa">Uso do repositório Funasa</a> </li> 
                <li> <a href="{$context-path}/page/governance_policy" class="hidden-xs">Política do repositório</a> </li> 
            </ul>
        </nav>
    </div> 
</div>





<div class="row">
   <div class="col-md-12">
    <p class="desenvolvido"><i18n:text>xmlui.home.disclaimer</i18n:text></p>
</div>
</div>


<div id="myfooter-brasil">
    <div id="mywrapper-footer-brasil">
        <a class="logo-acesso-footer" href="http://www.acessoainformacao.gov.br/" alt="Acesso à informação" title="Acesso à informação" target="_blank"></a>
        <a class="logo-governo-federal" href="http://www.brasil.gov.br/" alt="Governo Federal" title="Governo Federal" target="_blank"></a>
    </div>
</div>

<!--Invisible link to HTML sitemap (for search engines) -->
<a class="hidden">
  <xsl:attribute name="href">
  <xsl:value-of
  select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
  <xsl:text>/htmlmap</xsl:text>
</xsl:attribute>
<xsl:text>&#160;</xsl:text>
</a>


</div>
<!-- del container -->



</footer>
</xsl:template>


    <!--
            The meta, body, options elements; the three top-level elements in the schema
        -->




    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
    <div>
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
        <div class="alert alert-warning">
            <button type="button" class="close" data-dismiss="alert">&#215;</button>
            <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
        </div>
    </xsl:if>

    <!-- Check for the custom pages -->
    <xsl:choose>
    <xsl:when test="starts-with($request-uri, 'page/about')">
    <div class="hero-unit">
        <h1><i18n:text>xmlui.mirage2.page-structure.heroUnit.title</i18n:text></h1>
        <p><i18n:text>xmlui.mirage2.page-structure.heroUnit.content</i18n:text></p>
    </div>
</xsl:when>
<!-- Otherwise use default handling of body -->
<xsl:otherwise>
<xsl:apply-templates />
</xsl:otherwise>
</xsl:choose>

</div>
</xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
        <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
-->

<xsl:template name="addJavascript">

<script type="text/javascript"><xsl:text>
if(typeof window.publication === 'undefined'){
    window.publication={};
};
window.publication.contextPath= '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/><xsl:text>';</xsl:text>
<xsl:text>window.publication.themePath= '</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
</script>
<!--TODO concat & minify!-->

<script>
    <xsl:text>if(!window.DSpace){window.DSpace={};}window.DSpace.context_path='</xsl:text><xsl:value-of select="$context-path"/><xsl:text>';window.DSpace.theme_path='</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
</script>

        <!--inject scripts.html containing all the theme specific javascript references
        that can be minified and concatinated in to a single file or separate and untouched
        depending on whether or not the developer maven profile was active-->
        <xsl:variable name="scriptURL">
        <xsl:text>cocoon://themes/</xsl:text>
            <!--we can't use $theme-path, because that contains the context path,
                and cocoon:// urls don't need the context path-->
                <xsl:value-of select="$pagemeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                <xsl:text>scripts-dist.xml</xsl:text>
            </xsl:variable>
            <xsl:for-each select="document($scriptURL)/scripts/script">
            <script src="{$theme-path}{@src}">&#160;</script>
        </xsl:for-each>

        <!-- Add javascript specified in DRI -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
        <script>
            <xsl:attribute name="src">
            <xsl:value-of select="$theme-path"/>
            <xsl:value-of select="."/>
        </xsl:attribute>&#160;</script>
    </xsl:for-each>

    <!-- add "shared" javascript from static, path is relative to webapp root-->
    <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
            <xsl:when test="text() = 'static/js/choice-support.js'">
            <script>
                <xsl:attribute name="src">
                <xsl:value-of select="$theme-path"/>
                <xsl:text>js/choice-support.js</xsl:text>
            </xsl:attribute>&#160;</script>
        </xsl:when>
        <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
        <script>
            <xsl:attribute name="src">
            <xsl:value-of
            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="."/>
        </xsl:attribute>&#160;</script>
    </xsl:when>
</xsl:choose>
</xsl:for-each>

<!-- add setup JS code if this is a choices lookup page -->
<xsl:if test="dri:body/dri:div[@n='lookup']">
<xsl:call-template name="choiceLookupPopUpSetup"/>
</xsl:if>

<xsl:call-template name="addJavascript-google-analytics" />
</xsl:template>

<xsl:template name="addJavascript-google-analytics">
<!-- Add a google analytics script if the key is present -->
<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
<script><xsl:text>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/><xsl:text>');
ga('send', 'pageview');
</xsl:text></script>
</xsl:if>
</xsl:template>

    <!--The Language Selection
        Uses a page metadata curRequestURI which was introduced by in /xmlui-mirage2/src/main/webapp/themes/Mirage2/sitemap.xmap-->
        <xsl:template name="languageSelection">
        <xsl:variable name="curRequestURI">
        <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='curRequestURI'],/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'])"/>
    </xsl:variable>

    <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
    <li id="ds-language-selection" class="dropdown">
        <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
        <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">
            <span class="hidden-xs">
                <xsl:value-of
                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$active-locale]"/>
                <xsl:text>&#160;</xsl:text>
                <b class="caret"/>
            </span>
        </a>
        <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
            <xsl:for-each
            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
            <xsl:variable name="locale" select="."/>
            <li role="presentation">
                <xsl:if test="$locale = $active-locale">
                <xsl:attribute name="class">
                <xsl:text>disabled</xsl:text>
            </xsl:attribute>
        </xsl:if>
        <a>
            <xsl:attribute name="href">
            <xsl:value-of select="$curRequestURI"/>
            <xsl:call-template name="getLanguageURL"/>
            <xsl:value-of select="$locale"/>
        </xsl:attribute>
        <xsl:value-of
        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
    </a>
</li>
</xsl:for-each>
</ul>
</li>
</xsl:if>
</xsl:template>

    <!-- Builds the Query String part of the language URL. If there already is an existing query string
        like: ?filtertype=subject&filter_relational_operator=equals&filter=keyword1 it appends the locale parameter with the ampersand (&) symbol -->
        <xsl:template name="getLanguageURL">
        <xsl:variable name="queryString" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='queryString']"/>
        <xsl:choose>
        <!-- There allready is a query string so append it and the language argument -->
        <xsl:when test="$queryString != ''">
        <xsl:text>?</xsl:text>
        <xsl:choose>
        <xsl:when test="contains($queryString, '&amp;locale-attribute')">
        <xsl:value-of select="substring-before($queryString, '&amp;locale-attribute')"/>
        <xsl:text>&amp;locale-attribute=</xsl:text>
    </xsl:when>
    <!-- the query string is only the locale-attribute so remove it to append the correct one -->
    <xsl:when test="starts-with($queryString, 'locale-attribute')">
    <xsl:text>locale-attribute=</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$queryString"/>
<xsl:text>&amp;locale-attribute=</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:text>?locale-attribute=</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template name="buildFrontSearch">

<xsl:variable name="numdocs">
<xsl:value-of select="//dri:div[@id='aspect.browseArtifacts.HomeSearchBand.div.total-items']/dri:p/text()" />
</xsl:variable> 


<div class="containerFundoQuemSomos">
   <section class="quemSomos">
    <h1 class="tituloSecoes corCinza">Seja bem-vindo(a),</h1>
    <img class="iconeConhecimento" src="{$theme-path}images/iconeConhecimentoFunasa.png" />
    <p class="pbCinza">
      O Repositório do Conhecimento (RC) da Fundação Nacional de Saúde (Funasa) tem por objetivo reunir, preservar e permitir o acesso à sua produção de conhecimento tácito e/ou explícito organizacional, bem como sua produção técnico-científica, editorial e multimídia, além de outros ativos referentes à sua memória institucional. Boa pesquisa!
  </p>
  <div class="busca">

    <form id="ds-search-form" class="home-search" method="post">
        <xsl:attribute name="action">
        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
        <xsl:value-of
        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>

    </xsl:attribute>

                      <!-- <div class="input-group">
        
               				<input type="text" class="ds-text-field form-control"  placeholder="xmlui.general.search" i18n:attr="placeholder">
                        <xsl:attribute name="name">
                                        <xsl:value-of
                                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                         </xsl:attribute>
                      </input>
                      
                      
               				<button type="submit" onclick="" class="buscar">
                    				<i class="fa fa-search" action=""></i>
                    	</button>
                    </div> -->

                    <fieldset>
                      <div class="input-group">
                        <input placeholder="Buscar no repositório" type="text" class="ds-text-field form-control redondoizq" name="query" />
                        <span class="input-group-btn">
                         <button title="Ir" class="ds-button-field btn btn-primary redondoderecha">
                             <span aria-hidden="true" class="glyphicon glyphicon-search"></span></button></span>
                         </div>
                     </fieldset>

                 </form>         


             </div> 
         </section>	
     </div>

     <!--
     <div class="container-fluid">
     <div class="row alturafranja">
        <div id="franjahead">
          
          <div class="container">
          
              <form id="ds-search-form" class="home-search" method="post">
                        <xsl:attribute name="action">
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                                    
                        </xsl:attribute>
                        <fieldset>
                            
                             <div class="searchgroup">
                                
                                <div class="row">
                                <div class="col-xs-12 col-md-12">
                                
                                 <h2 class="ds-div-head searchlegend">
                                      <i18n:text>xmlui.general.search-home</i18n:text><xsl:text> </xsl:text>
                                      <small>(<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='itemsinarchive'][@qualifier='repository']"/><xsl:text> </xsl:text><i18n:text>xmlui.general.search-documents</i18n:text>)</small>
                                </h2>
                                </div>
                                </div>
                                
                                
                                
                                <div class="row">
                                <div class="col-xs-12 col-md-12">
                                <div class="input-group">
                                <input class="ds-text-field form-control-searchhome" type="text" placeholder="xmlui.general.search" i18n:attr="placeholder">
                                    <xsl:attribute name="name">
                                        <xsl:value-of
                                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                                    </xsl:attribute>
                                </input>
                                <span class="input-group-btn">
                                    <button class="ds-button-field btn btn-primary" title="xmlui.general.go" i18n:attr="title">
                                        <span class="glyphicon glyphicon-search" aria-hidden="true"/>
                                        <xsl:attribute name="onclick">
                                                    <xsl:text>
                                                        var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                                        if (radio != undefined &amp;&amp; radio.checked)
                                                        {
                                                        var form = document.getElementById(&quot;ds-search-form&quot;);
                                                        form.action=
                                                    </xsl:text>
                                            <xsl:text>&quot;</xsl:text>
                                            <xsl:value-of
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                                            <xsl:text>/handle/&quot; + radio.value + &quot;</xsl:text>
                                            <xsl:value-of
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                                            <xsl:text>&quot; ; </xsl:text>
                                                    <xsl:text>
                                                        }
                                                    </xsl:text>
                                        </xsl:attribute>
                                    </button>
                                </span>
                                </div>
                                </div>
                                </div>
                                
                                
                                <div class="btn-group btn-group-xs" role="group">
                  
                                    <p class="termsearch"><i18n:text>xmlui.general.search-this-week</i18n:text></p>
                                    <p><xsl:for-each select="//dri:div[@id='aspect.browseArtifacts.HomeSearchBand.div.popular-searches']/dri:p">
                                        <xsl:variable name="expression"><xsl:value-of select="./text()"/></xsl:variable>
                                        <button type="button" class="btn btn-info btn-sm mayuscula" onclick="location.href='{$context-path}/discover?query={$expression}'"><xsl:value-of select="$expression" /></button>
                                    </xsl:for-each>
                                    </p>
                                </div>
                                
                                
                                

                           </div> 
                        </fieldset>
                    </form>
          
               </div>
          
          </div>
        </div>
        
      
    </div>  -->
    
    <!-- <script> new WOW().init(); </script> -->
    
    
    
</xsl:template> 

<!-- Estos son para los destacados y recientes -->




<!-- Div principal para los featured -->
<xsl:template match="dri:div[@id='aspect.browseArtifacts.SiteFeaturedItems.div.site-featured-items']" mode="show">

<xsl:element name="div">
<xsl:attribute name="class"><xsl:text>row grid</xsl:text></xsl:attribute>
<xsl:attribute name="id"><xsl:text>featured</xsl:text></xsl:attribute>

<xsl:for-each select="./dri:referenceSet/dri:reference">

<div class="col-md-4 col-sm-6 col-xs-12 item">

    <xsl:variable name="externalMetadataURL">
    <xsl:text>cocoon://</xsl:text>
    <xsl:value-of select="@url"/>
    <xsl:text>?sections=dmdSec,fileSec</xsl:text>
</xsl:variable>

<xsl:apply-templates select="document($externalMetadataURL)" mode="recentSub" />      

</div>

</xsl:for-each> 

</xsl:element>
<div class="row">
 <div class="col-xs-12">
    <a href="{$context-path}/featured-submissions">
        <p class="pull-right">
            <img class="img-responsive" src="{$theme-path}/images/lupa.png" />
            <i18n:text>xmlui.ArtifactBrowser.AbstractRecentSubmissionTransformer.featured_submissions_more</i18n:text>
        </p>
    </a>
</div>
</div>

</xsl:template>


<!-- Div principal para las recientes -->
<xsl:template match="dri:div[@id='aspect.discovery.SiteRecentSubmissions.div.site-home']" mode="show">


<xsl:element name="div">
<xsl:attribute name="class"><xsl:text>row grid</xsl:text></xsl:attribute>
<xsl:attribute name="id"><xsl:text>recent</xsl:text></xsl:attribute>

<xsl:for-each select="./dri:div/dri:referenceSet/dri:reference">

<div class="col-md-4 col-sm-6 col-xs-12 item">

    <xsl:variable name="externalMetadataURL">
    <xsl:text>cocoon://</xsl:text>
    <xsl:value-of select="@url"/>
    <xsl:text>?sections=dmdSec,fileSec</xsl:text>
</xsl:variable>

<xsl:apply-templates select="document($externalMetadataURL)" mode="recentSub" />      

</div>

</xsl:for-each> 

</xsl:element>

<div class="row">
 <div class="col-xs-12 text-right">
    <a href="{$context-path}/recent-submissions">
        <p class="pull-right text-right">
            <img class="img-responsive" src="{$theme-path}/images/lupa.png" />
            <i18n:text>xmlui.ArtifactBrowser.AbstractRecentSubmissionTransformer.recent_submissions_more</i18n:text>
        </p>
    </a>
</div>
</div>

</xsl:template>



<xsl:template match="mets:METS" mode="recentSub">
<xsl:variable name="dim" select="mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
<xsl:variable name="titulo" select="$dim/dim:field[@element='title']"></xsl:variable>


<!-- <div style="padding-left: 90px; padding-right: 90px; display: inline-block; min-width:100% "> -->
 <div class="panel panel-default">
     <div class="panel-body nopadding">     
      <div class="row">
       <div class="col-md-12">
        <xsl:apply-templates select="mets:fileSec" mode="mythumb">
        <xsl:with-param name="href" select="@OBJID" />
        <xsl:with-param name="mytitle" select="$titulo" />
    </xsl:apply-templates>              
</div>
</div>
<div class="row">
   <div class="col-md-12">
    <div class="sipadding">


     <h5 class="header-naranja">
         <a href="{@OBJID}" class="sans-regular">
             <xsl:value-of select="$dim/dim:field[@element='title']"/></a>
         </h5>
         <h6><xsl:value-of select="$dim/dim:field[@element='date' and @qualifier='issued']/node()"/></h6>
         <xsl:variable name="abstract" select="$dim/dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
         <p class="interlineado"><xsl:value-of select="util:shortenString($abstract, 250, 10)"/></p>  

         <xsl:variable name="url" select="$dim/dim:field[@element = 'identifier' and @qualifier='uri']/node()"/>

         <!-- Go to www.addthis.com/dashboard to customize your tools -->


     </div>

 </div>
</div>
</div>


</div>

</xsl:template>



<xsl:template match="mets:fileSec" mode="mythumb">
<xsl:param name="href"/>
<xsl:param name="mytitle"/>

<div class="thumbnail artifact-preview">
    <a class="image-link" href="{$href}">
        <xsl:choose>
        <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']">
        <!-- <img class="img-responsive" alt="xmlui.mirage2.item-list.thumbnail" i18n:attr="alt"> -->
        <img class="img-responsive" alt="{$mytitle}"> 
        <xsl:attribute name="src">
        <xsl:value-of
        select="mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
    </xsl:attribute>
</img>
</xsl:when>
<xsl:otherwise>
<img alt="xmlui.mirage2.item-list.thumbnail" i18n:attr="alt">
<xsl:attribute name="data-src">
<xsl:text>holder.js/100%x</xsl:text>
<xsl:value-of select="$thumbnail.maxheight"/>
<xsl:text>/text:No Thumbnail</xsl:text>
</xsl:attribute>
</img>
</xsl:otherwise>
</xsl:choose>
</a>
</div>

</xsl:template>



<!-- Este es para ocultar la division repetida -->
<xsl:template match="dri:div[@id='aspect.browseArtifacts.SiteFeaturedItems.div.site-featured-items']" />
<xsl:template match="dri:div[@id='aspect.discovery.SiteRecentSubmissions.div.site-home']" /> 


<xsl:template match="dri:div[@n='news']" />

<!-- Frequent searches -->
<xsl:template match="dri:div[@id='aspect.browseArtifacts.HomeSearchBand.div.popular-searches']" />


</xsl:stylesheet>




