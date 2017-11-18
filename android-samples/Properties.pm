package TestInfra::PropertiesParser;

use strict;
use warnings;

sub new {
    my ($class, $file) = @_;
    my $self = {};
    $self->{'file'} = $file;
    $self->{'line_no'} = 0;
    $self->{'content'} = &readFile($self->{'file'});
    $self->parseContent();
    bless $self, $class;
}
sub hasProperty {
    my ($self, $propertyName) = @_;
    foreach my $rh_data (@{$self->{'parsed_data'}}) {
        next unless $rh_data->{'type'} eq 'property';
        my $ra_content = $rh_data->{'content'}
        foreach my $line (@$ra_content) {
            if ($line =~ /$propertyName\s*=(.*)/) {
                return 1;
            }
        }
    }
    return 0;
}

sub setProperty {
    my ($self, $propertyName, $newValue) = @_;
    foreach my $rh_data (@{$self->{'parsed_data'}}) {
        next unless $rh_data->{'type'} eq 'property';
        my $ra_content = $rh_data->{'content'}
        foreach my $line (@$ra_content) {
            if ($line =~ /$propertyName\s*=(.*)/) {
                $line = "$propertyName=$newValue\n";
                return 1;
            }
        }
    }
    # TODO: Failure to find the property.... 
    return 0;

}

sub save {
    my ($self) = @_;
    my $ra_new_content = [];
    foreach my $rh_data (@{$self->{'parsed_data'}}) {
        push @$ra_new_content, @{$rh_data->{'content'}}
    }
    writeFile($self->{'file'}, $ra_new_content);
}

sub addProperty {
    my ($self, $propertyName, $value) = @_;
    # TODO: Get last entry of parsed_Data and append
    my $pd_len = scalar @{$self->{'parsed_data'}};
    my $rh_data = $self->{'parsed_data'}->[$pd_len - 1];
    my $last_line = $rh_data->{'line_to'};
    push @{$self->{'parsed_data'}}, {
        'line_from' => $last_line + 1,
        'line_to'   => $last_line + 1,
        'content'   => ["$propertyName=$value\n"],
        'type'      => 'property'
    };
    return;
}

sub parseContent {
    my ($self) = @_;
    $self->{'parsed_data'} = [];
    for(int $i = 0; $i < @{$self->{'content'}}; $i++) {
        # TODO: Do same for the comments, multiline comments, etc.
        push @{$self->{'parsed_data'}}, {
            'line_from' => $i,
            'line_to' => $i,
            # TODO : Get content as array slice
            'content' => [$self->{'content'}->[$i]],
            'type' => 'property'
        }
    }
    return;
}
