Posh
====

A **P**erl **O**riented **Sh**ell.

(c) 2011 Gatlin Johnson, Traian Nedelea

This is licensed under the Do What The Fuck You Want Public License.
You may obtain a copy of the license [here](http://sam.zoy.org/wtfpl).

What is it?
-----------

Posh is a simple, crappy shell written in Perl. It is intended to be used for
pedagogical purposes as it supports a number of beginner-to-intermediate Perl
examples.

Features
--------

*   You can write subs at run time
*   Supports piping between commands
*   You can rename the prompt!
*   Lambda functions

How do I use it?
----------------

    ./posh.pl
    posh> set prompt perl
    perl> set prompt posh
    posh> sub add { print $_[0] + $_[1] }
    posh> add 1 2
    3
    posh> sub myfriends { print "Jesus\nBuddha\nShaft" }
    posh> sub arecool { while (<>) { chomp $_; print "$_ is cool\n" } }
    posh> myfriends | arecool
    Jesus is cool
    Buddha is cool
    Shaft is cool
    posh> sub echo print @_;
    posh> echo posh
    posh
    posh> echo gatlin | lambda print "$_[0] is a moron"
    gatlin is a moron
    posh> exit
    Goodbye!

This showcases the basic features.

How is this different from gatlin/posh?
---------------------------------------

This `posh` looks in `$PATH` for commands it doesn't recognize. `gatlin/posh`
is a teaching tool, `tron1point0/posh` is more of a usable shell. Different
goals means different forks.

Oh, also, both were written from scratch in parallel by each of us. They have
similar structures (and I forked from him) because we have similar coding
styles. That, and we were sitting in the same room...
