; localization - ok

(defun c:TP_draw_displacements( / old_env_vars ins_pt displacement_data filename
						   xc yc counter data_line x1 y1 z1 x2 y2 z2 F pt1 pt2
						   dx dy ins_x ins_y text_x text_y pt_text text_str
						   ln_tension ln_compression ln_zero scale ln_undef ln_def
						   dx1 dx2 dy1 dy2 x1_def y1_def x2_def y2_def
						   pt1_def pt2_def text_str1x text_str1y text_str2x text_str2y)

	(setq old_env_vars (env_get))
	(setvar "osmode" 0)
	(setvar "cmdecho" 0)

	(setq ln_undef "TRUSSPY_undeformed")
	(setq ln_def "TRUSSPY_deformed")
	
	(command-s "._LAYER" "M" ln_undef "C" "4" "" "")
	(command-s "._LAYER" "M" ln_def "C" "2" "" "")
	
	(setq filename (strcat (getvar "dwgprefix") (getvar "dwgname")))
	(setq filename (vl-string-trim ".dwg" filename))
	(setq filename (strcat filename ".dpl"))	
	
	(setq displacement_data (read_csv filename))
	
	(setq ins_pt (getpoint "\nSpecify diagram insertion point: "))
	(setq ins_x (car ins_pt))
	(setq ins_y (cadr ins_pt))
	
	(setq counter 0)
	(repeat (length displacement_data)		
		(setq data_line (nth counter displacement_data))
		(if (= counter 0)
			(setq scale (nth 0 data_line))
		)
		(if (= counter 1)
			(progn
				(setq xc (nth 0 data_line))
				(setq yc (nth 1 data_line))
				(setq dx (- ins_x xc))
				(setq dy (- ins_y yc))	
			)
		)
		(if (> counter 1)
			(progn
				(setq x1 (nth 0 data_line))				
				(setq y1 (nth 1 data_line))				
				(setq z1 0)
				(setq x2 (nth 4 data_line))
				(setq y2 (nth 5 data_line))				
				(setq z2 0)
				(setq dx1 (nth 2 data_line))
				(setq dy1 (nth 3 data_line))
				(setq dx2 (nth 6 data_line))
				(setq dy2 (nth 7 data_line))
				
				(setq x1 (+ x1 dx))
				(setq y1 (+ y1 dy))
				(setq x2 (+ x2 dx))
				(setq y2 (+ y2 dy))

				(setq x1_def (+ x1 (* dx1 scale)))
				(setq y1_def (+ y1 (* dy1 scale)))
				(setq x2_def (+ x2 (* dx2 scale)))
				(setq y2_def (+ y2 (* dy2 scale)))					
		
				(setq pt1 (list x1 y1 z1))
				(setq pt2 (list x2 y2 z2))
				(setq pt1_def (list x1_def y1_def z1))
				(setq pt2_def (list x2_def y2_def z2))
				(setq text_str1x (strcat "Ux: " (rtos dx1 1 2)))
				(setq text_str1y (strcat "Uy: " (rtos dy1 1 2)))
				(setq text_str2x (strcat "Ux: " (rtos dx2 1 2)))
				(setq text_str2y (strcat "Uy: " (rtos dy2 1 2)))			
			
				(setvar "CLAYER" ln_undef)
				(command-s "._LINE" pt1 pt2 "")				
				(setvar "CLAYER" ln_def)
				(command-s "._LINE" pt1_def pt2_def "")		

				(setq pt3 (list (car pt1) (- (cadr pt1) 0.1) (caddr pt1)))
				(setq pt4 (list (car pt2) (- (cadr pt2) 0.1) (caddr pt2)))
				
				(command-s "._TEXT" "J" "C" pt1 0.05 0 text_str1x)				
				(command-s "._TEXT" "J" "C" pt3 0.05 0 text_str1y)				
				(command-s "._TEXT" "J" "C" pt2 0.05 0 text_str2x)
				(command-s "._TEXT" "J" "C" pt4 0.05 0 text_str2y)			
				
			)
		)
		
		
		(setq counter (+ 1 counter))
	)
	
	
	(env_set old_env_vars)
	(princ)
)

