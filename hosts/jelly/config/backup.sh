#!/bin/bash

########################################################
# This is not in use at the moment, using GUI server. 
# TO DEPRECATE
########################################################

# Run backup
kopia snapshot create /home/drose

# Show quick status
kopia snapshot list --show-identical=false 