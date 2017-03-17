#!/usr/bin/perl
use strict;
use warnings;
use POSIX qw(strftime);

my $snapdir="/run/btrfs-root/__snapshots";
my $snapmax=10;

my @snapshots;

print "###  Lecture des snapshots btrfs  ###\n";

opendir( my $dh,"$snapdir" ) or die "Could not open directory $snapdir : $!";

while ( readdir $dh ) {
	if ( $_ =~ /^ROOT@/ ){
		#print "$_\n";
		push @snapshots, "$_";
	}
}

close $dh;


@snapshots = sort { lc($b) cmp lc($a) } @snapshots;


if ( @snapshots ) {
	my $i=0;
	my $cmd;
	foreach (@snapshots){
		$i++;
		my $snapshot = $_;
		if ( $i+1 == $snapmax) { 
			print "=> Supression des snapshots\n"; 
		}
		if ( $i > $snapmax ) {
			$cmd = "sudo btrfs subvolume delete $snapdir/$snapshot";
			#print "$cmd\n";
			system $cmd;
		}
	}
}

my $date = strftime "%Y%m%d",localtime;

if ( ! grep (/^ROOT\@$date/,@snapshots)){
	print "=> Creation d'un snapshot\n";
	my $cmd = 'sudo btrfs subvolume snapshot -r /run/btrfs-root/__current/ROOT/ /run/btrfs-root/__snapshots/ROOT@$(date "+%Y%m%d%H%M")';
	#print "$cmd\n";
	system $cmd;
}
print "### Lecture des snapshots terminé ###\n\n";
exit;
