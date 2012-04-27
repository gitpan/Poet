#!perl -w

BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for testing by the author');
  }
}

use Poet::t::NoLog4perl;
Poet::t::NoLog4perl->runtests;
