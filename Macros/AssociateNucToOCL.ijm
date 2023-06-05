run("Object Inspector (2D/3D)", "primary_imageplus=OCL_Label secondary_imageplus=NucLabel original_1_title=OCL original_2_title=Nuc primary_volume_range=0-Infinity primary_mmer_range=0.00-1.00 secondary_volume_range=0-Infinity secondary_mmer_range=0.00-1.00 exclude_primary_objects_on_edges=true pad_stack_tops=false display_results_tables=true display_analyzed_label_maps=true show_count_map=true");
selectWindow("CountMap_OCL_Label");
run("Calibration Bar...", "location=[Lower Right] fill=White label=Black number=5 decimal=0 font=12 zoom=2 overlay");

