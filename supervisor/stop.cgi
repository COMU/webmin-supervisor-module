#!/usr/bin/perl
# Stop the ProFTPD server process
# stop.cgi

require './supervisor-lib.pl';
$err = &stop_supervisor();
&webmin_log("stop");
&redirect($in{'redir'});

