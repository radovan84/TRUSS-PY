
(defun c:TP_draw_geometry( / old_env_vars ins_pt geometry_data filename
						   xc yc counter data_line x1 y1 z1 x2 y2 z2 F pt1 pt2
						   dx dy ins_x ins_y text_x text_y pt_text text_str
						   ln_tension ln_compression ln_zero text_str_nd1 text_str_nd2
						   text_str_el ln_element ln_element_labels ln_node_labels
						   node1_label node2_label)

	(setq old_env_vars (env_get))
	(setvar "osmode" 0)
	(setvar "cmdecho" 0)

	(setq ln_element "TRUSSPY_elements")
	(setq ln_element_labels "TRUSSPY_element_labels")
	(setq ln_node_labels "TRUSSPY_nodes_labels")

	(command-s "._LAYER" "M" ln_element "C" "4" "" "")	
	(command-s "._LAYER" "M" ln_element_labels "C" "3" "" "")
	(command-s "._LAYER" "M" ln_node_labels "C" "2" "" "")
	
	(setq filename (strcat (getvar "dwgprefix") (getvar "dwgname")))
	(setq filename (vl-string-trim ".dwg" filename))
	(setq filename (strcat filename ".gtr"))	
	
	(setq geometry_data (read_csv filename))
	
	(setq ins_pt (getpoint "\nSpecify diagram insertion point: "))
	(setq ins_x (car ins_pt))
	(setq ins_y (cadr ins_pt))
	
	(setq counter 0)
	(repeat (length geometry_data)		
		(setq data_line (nth counter geometry_data))
		(if (= counter 0)
			(progn
				(setq xc (nth 0 data_line))
				(setq yc (nth 1 data_line))
				(setq dx (- ins_x xc))
				(setq dy (- ins_y yc))	
			)
			(progn
				(setq x1 (nth 0 data_line))				
				(setq y1 (nth 1 data_line))				
				(setq node1_label (nth 2 data_line))	
				(setq x2 (nth 3 data_line))
				(setq y2 (nth 4 data_line))				
				(setq node2_label (nth 5 data_line))
				(setq element_label (nth 6 data_line))				

				(setq x1 (+ x1 dx))
				(setq y1 (+ y1 dy))
				(setq x2 (+ x2 dx))
				(setq y2 (+ y2 dy))
				
				(setq text_x (/ (+ x1 x2) 2))
				(setq text_y (/ (+ y1 y2) 2))			
			
				(setq pt1 (list x1 y1 0))
				(setq pt2 (list x2 y2 0))
				(setq pt_text (list text_x text_y 0))
				(setq text_str_el (strcat "el "(rtos element_label 2 0)))
				(setq text_str_nd1 (strcat "nd " (rtos node1_label 2 0)))
				(setq text_str_nd2 (strcat "nd " (rtos node2_label 2 0)))
				
				(setvar "CLAYER" ln_element)				
				(command-s "._LINE" pt1 pt2 "")				
				(setvar "CLAYER" ln_element_labels)				
				(command-s "._TEXT" "J" "C" pt_text 0.1 0 text_str_el)				
				(setvar "CLAYER" ln_node_labels)				
				(command-s "._TEXT" "J" "C" pt1 0.1 0 text_str_nd1)
				(command-s "._TEXT" "J" "C" pt2 0.1 0 text_str_nd2)
			)
		)
		
		(setq counter (+ 1 counter))
	)
	
	
	(env_set old_env_vars)
	(princ)
)

