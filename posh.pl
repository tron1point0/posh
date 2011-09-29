#!/usr/bin/env perl

use strict;
use warnings;
use B::Deparse;
use Data::Dump qw(pp);

sub deparse { B::Deparse->new()->coderef2text(@_) }

my (%dispatch,%builtin);
my %env = (
    ps1 => "perl",
);

%dispatch = (
    sub => sub {
        my $fn = shift;
        unless (defined $fn) {
            my %deparsed = map {($_,deparse($dispatch{$_}))} grep {!$builtin{$_}} keys %dispatch;
            while (my ($k,$v) = each %deparsed) {
                print "sub $k $v\n";
            }
            return;
        }

        $dispatch{$fn} = eval "sub {@_}";
    },
    prompt => sub {
        print "$env{ps1}> ";
    },
    set => sub {
        my $var = shift;
        unless (defined $var) {
            while (my ($k, $v) = each %env) {
                print "$k = ".pp($v)."\n";
            }
            return;
        }

        $env{$var} = join " ", @_;
    },
    '\\' => sub {
        my $fn = eval "sub {@_}";
        $fn->($_) while <>;
    },
    echo => sub {
        print @_,"\n";
    },
);
%builtin = map {$_ => 1} keys %dispatch;

sub command {
    s/(?<=[^\\]\$)([a-zA-Z0-9_]+)/defined $env{$1} ? "env{$1}" : "$1"/ges foreach @_;

    my ($fn, @args) = @_;

    unless (defined $dispatch{$fn}) {
        my @path = split ':', $ENV{PATH};
        foreach (@path) {
            return print `$_/$fn @args` if -x "$_/$fn";
        }
        return warn "$fn not found\n";
    }

    $dispatch{$fn}->(@args);
}

$dispatch{prompt}->();
while (<>) {
    last if /^exit\b/;
    my @parts = ([]);
    while (m/('[^']*'|"[^"]*"|\S+)/g) {
        my $token = $1;
        push(@parts, []),next if $token =~ m/^\|$/;
        push @{$parts[$#parts]}, $token;
    }

    my ($in,$out) = ("\n",undef);
    {
        local *STDIN;
        local *STDOUT;
        local $| = 1;
        foreach (@parts) {
            open STDOUT, '>', \$out;
            open STDIN, '<', \$in;
            local *ARGV = *STDIN;
            command(@$_);
            close STDIN;
            close STDOUT;
            $in = $out;
        }
    }
    print $in if $in;

    $dispatch{prompt}->();
}

print "\n";
