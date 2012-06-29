I) Running the Phenoripper GUI from source:

        0/Start MATLAB:

        1/Set the path:
        cd src/


        2/Start the PhenoRipper GUI:
        phenoripper


II) Running the PhenoRipper engine without using the GUI.
        All the files required for this are present in the engine directory
        inside src/. Running Phenoripper involves the following steps
        1) Identifying the block types: identify_block_types.m
        2) Identifying the superblock types: identify_superblock_types.m
        3) Profiling an image:rip_image.m
        The first two steps are typically run on a subset of images,
        while the third step is executed on a per image basis. For
        further details look at the three files mentioned above.



