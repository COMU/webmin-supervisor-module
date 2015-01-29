#!/usr/bin/perl
# Stop the ProFTPD server process
# stop.cgi

require './supervisor-lib.pl';
$err = &start_supervisor();
&webmin_log("stop");
&redirect($in{'redir'});
