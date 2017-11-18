use strict;
use warnings;
use XML::Parser;
use Data::Dumper;
my $str = '';
my @stack = ();
sub getAttrs {
    my ($rh_attrs) = @_;
    my $str = '';
    my @arr = ();
    foreach my $k (keys %$rh_attrs) {
        my $v = $rh_attrs->{$k};
        push @arr, "'$k': '$v'";
    }
    if (@arr) {
        return join(',', @arr);
    }
    return '[:]';
}
sub handle_start {
    my ($expat, $element, %attrs) = @_;
    push @stack, $element;
    my $attr = &getAttrs(\%attrs);
    $str .= '    ' x @stack;
    if ($element eq 'class' or $element eq 'package') {
        $element = "'$element'";
    }
    $str .= $element . '(' . $attr . ') {' . "\n";
}

sub handle_char {
    my ($expat, $str) = @_;
}
sub handle_end {
    my ($expat, $element) = @_;
    $str .= '    ' x @stack;
    $str .= "}\n";
    pop @stack;
}
sub handle_final {
    my @arr = split("\n", $str);
    for(my $i =0; $i< scalar @arr; $i++) {
        if (($arr[$i] =~ /\{$/) and ($arr[$i+1] =~ /^\s*\}/)) {
            chop $arr[$i];
#            $arr[$i] =~ s/(\{$/$1/;
            $arr[$i+1] = undef;
            $i++;
        }
    }
   $str = join ("\n", @arr);
}

my $p2 = new XML::Parser(NoExpand => 1, Handlers => {Start => \&handle_start,
                                      End   => \&handle_end,
                                    Char  => \&handle_char,
                                    Final => \&handle_final});
$p2->parsefile($ARGV[0]);
print $str;
