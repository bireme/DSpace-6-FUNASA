#!/bin/sh
if [ -z "$1" ]
  then
    echo "No argument supplied"
fi

if [ "$1" = "paho" ] 
then
	echo "Armando distro de PAHO"
	cp dspace/config/local_paho.cfg dspace/config/local.cfg
	cp dspace/config/dspace_paho.cfg dspace/config/dspace.cfg
	cp dspace/config/input-forms-paho.xml dspace/config/input-forms.xml
	cp dspace/config/xmlui_paho.xconf dspace/config/xmlui.xconf
	cp -R dspace/config/emails_paho dspace/config/emails
	
	
	cp dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap_paho.xmap dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap.xmap
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_es_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_es.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_pt_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_pt.xml
	
elif [ "$1" = "pahowin" ] 
then
	echo "Armando distro de PAHO Windows"
	cp dspace/config/local_paho_win.cfg dspace/config/local.cfg
	cp dspace/config/dspace_paho_win.cfg dspace/config/dspace.cfg
	cp dspace/config/input-forms-paho.xml dspace/config/input-forms.xml
	cp dspace/config/xmlui_paho.xconf dspace/config/xmlui.xconf
	
	cp -R dspace/config/emails_paho dspace/config/emails
	
	
	cp dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap_paho.xmap dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap.xmap
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_es_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_es.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_pt_paho.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_pt.xml
	
elif [ "$1" = "distro" ] 
then
	echo "Armando distro generica"
	cp dspace/config/local_distro.cfg dspace/config/local.cfg
	cp dspace/config/dspace_distro.cfg dspace/config/dspace.cfg
	cp dspace/config/input-forms-distro.xml dspace/config/input-forms.xml
	cp dspace/config/xmlui_distro.xconf dspace/config/xmlui.xconf
	cp dspace/config/news-xmlui-distro.xml dspace/config/news-xmlui.xml
	
	cp -R dspace/config/emails_paho dspace/config/emails
	
	
	cp dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap_distro.xmap dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap.xmap
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_distro.xml dspace/modules/xmlui/src/main/webapp/i18n/messages.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_es_distro.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_es.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_pt_distro.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_pt.xml
	
	
elif [ "$1" = "funasa" ] 
then
	echo "Armando distro FUNASA"
	cp dspace/config/local_funasa.cfg dspace/config/local.cfg
	cp dspace/config/dspace_funasa.cfg dspace/config/dspace.cfg
	cp dspace/config/input-forms-funasa.xml dspace/config/input-forms.xml
	cp dspace/config/xmlui_funasa.xconf dspace/config/xmlui.xconf
	cp dspace/modules/xmlui/src/main/java/org/dspace/app/xmlui/aspect/artifactbrowser/CommunityViewer.java_funasa dspace/modules/xmlui/src/main/java/org/dspace/app/xmlui/aspect/artifactbrowser/CommunityViewer.java
	
	cp dspace/config/news-xmlui-funasa.xml dspace/config/news-xmlui.xml
	cp -R dspace/config/emails_funasa dspace/config/emails
	
	
	cp dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap_distro.xmap dspace/modules/xmlui/src/main/resources/aspects/BrowseArtifacts/sitemap.xmap
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_funasa.xml dspace/modules/xmlui/src/main/webapp/i18n/messages.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_es_funasa.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_es.xml
	cp dspace/modules/xmlui/src/main/webapp/i18n/messages_pt_funasa.xml dspace/modules/xmlui/src/main/webapp/i18n/messages_pt.xml	
fi
