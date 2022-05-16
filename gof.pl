#!/usr/bin/perl

# Any live cell with fewer than two live neighbors dies as if caused by underpopulation.
# Any live cell with two or three live neighbors lives on to the next generation.
# Any live cell with more than three live neighbors dies, as if by overpopulation.
# Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

my @grid = (
    [ qw/0 0 0 0 0/ ],
    [ qw/0 0 0 1 1/ ],
    [ qw/0 0 0 1 0/ ],
    [ qw/1 1 0 0 1/ ],
    [ qw/0 1 0 1 0/ ],
);

print "\nStarting Grid";
renderGrid();

for (my $i = 0; $i < 3; $i++) {
	print "\nNew Grid #$i";
	evaluateGrid();
	renderGrid();
}

# render grid and return new evaluated grid
sub renderGrid {
	my $render = "\n";
	foreach my $rowValue (@grid) {
		foreach my $cell (@$rowValue) {
			$render .= $cell . ' ';
		}
		$render .= "\n";
	}

	print $render;
}

sub evaluateGrid {
	my $row = 0;
	foreach my $rowValue (@grid) {
		my $col = 0;
		foreach my $cell (@$rowValue) {
			$grid[$row]->[$col] = evaluateCell($cell, $row, $col);
			$col++;
		}
		$row++;
	}
}

sub evaluateCell {
    my ($cell, $row, $col) = @_;

    my @checks = (
        [$row + 1, $col - 1], #left bottom
        [$row,     $col - 1], #left
        [$row - 1, $col - 1], #left top
        [$row - 1, $col],     #top
        [$row - 1, $col + 1], #right top
        [$row,     $col + 1], #right
        [$row + 1, $col + 1], #right bottom
        [$row + 1, $col],     #bottom
    );

    my $liveNeighbors = 0;
    foreach my $check (@checks) {
        next if grep { $_ < 0 } @$check; #neighbor not in grid (on border)

        my $checkRow = $check->[0];
        my $checkCol = $check->[1];

        $liveNeighbors++ if $grid[$checkRow]->[$checkCol];
    }

    my $state = 0; # over or under populated, no reproduction
    if ($cell) { # is alive!
        # lives on
        if (($liveNeighbors == 2) || ($liveNeighbors == 3)) {
            $state = 1;
        }
    }
    elsif ($liveNeighbors == 3) {
        # reproduces
        $state = 1;
    }

	return $state;
}
