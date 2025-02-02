#!/bin/bash

# Run backup
kopia snapshot create /home/drose

# Show quick status
kopia snapshot list --show-identical=false 