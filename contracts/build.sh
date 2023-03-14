declare -a Contracts=(
                 "/Users/boraysaygilier/fuel-nomen/contracts/nomen-ownership" 
                 "/Users/boraysaygilier/fuel-nomen/contracts/simplified-nomen-ownership" 
                 "/Users/boraysaygilier/fuel-nomen/contracts/registry"
                 "/Users/boraysaygilier/fuel-nomen/contracts/general-resolver"
                 "/Users/boraysaygilier/fuel-nomen/contracts/harberger-ownership"
                 "/Users/boraysaygilier/fuel-nomen/contracts/annual-harberger-ownership"
                 "/Users/boraysaygilier/fuel-nomen/contracts/demand-based-ens-ownership"
                 "/Users/boraysaygilier/fuel-nomen/contracts/perpetual-ownership"
                 "/Users/boraysaygilier/fuel-nomen/contracts/governor"
                )
for entry in "${Contracts[@]}"
   do
     cd $entry
     forc-fmt
     forc build
     echo "$entry"
   done

