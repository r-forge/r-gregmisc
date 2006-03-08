#!/bin/sh
wget -N -r -nd ftp://research.warnes.net:8021/projects/CommercialR/
svn add *
svn commit -m "Automatic update of wiki information"
