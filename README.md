# tiered-storage-data-lifecycle
A system of up to nine numbered tiers of storage, where the smallest tier is the first and each tier increases in size.  Includes a way check whether or not any one tier is too large -- and a way to "age off" or migrate data from one tier to the next one.

## How to use:
1. Clone or fork or otherwise have the tiered-storage-data-lifecycle folder available.  This is your "tier resource folder".
2. Copy the USE_TEMPLATE folder and rename it to something meaningful for you.
3. In your copy of the USE_TEMPLATE folder, update the 'tier_res' variable at the top of the 'tiers.sh' script to be the relative or absolute path to the tier resource folder.
4. You may update the 'storageConstant' property in 'build.properties' in the USE_TEMPLATE copy to be something other than the default size (in megabytes/mebibytes).  That's approximately how large the first tier is allowed to be.  Other tiers increase in multiples of this exponentially -- or according to a hard-coded configuration (the '$limits' hash in 'tierStor/build.pl').
5. The USE_TEMPLATE folder has two tiers already: storTier1 and storTier2.  (You can change the 'storTier' prefix in the configuration files in the tier resource folder.)
6. Add files according to their importance and priority to these tiers (and make more tiers as necessary).

When you run 'tiers.sh' it defaults to checking whether or not any tiers exceed their storage limits.

If you run 'tiers.sh' with a single argument ('ageoff'), it will also migrate the data from each overfull tier to the next.  Every time it detects a full tier, it moves the largest file it can find _and_ the oldest file it can find.

## Usage summary:
    tiers.sh        # checks for full tiers
    tiers.sh ageoff # migrates data from each full tier into the next tier
