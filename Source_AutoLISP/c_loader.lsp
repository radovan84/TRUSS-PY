; ADD SUPPORT FILE SEARCH PATH FUNCTION
(defun sfsp_add ( lst )
    (   (lambda ( str lst )
            (if (setq lst
                    (vl-remove-if
                       '(lambda ( x )
                            (or (vl-string-search (strcase x) (strcase str))
                                (not (findfile x))
                            )
                        )
                        lst
                    )
                )
                (setenv "ACAD" (strcat str ";" (apply 'strcat (mapcar '(lambda ( x ) (strcat x ";")) lst))))
            )
        )
        (vl-string-right-trim ";" (getenv "ACAD"))
        (mapcar '(lambda ( x ) (vl-string-right-trim "\\" (vl-string-translate "/" "\\" x))) lst)
    )
)

; add sfsp
;(sfsp_add '("E:\\Python_Scripts\\moje\\TRUSS-PY\\dwg"))
;(sfsp_add '("E:\\Python_Scripts\\moje\\TRUSS-PY\\Source_AutoLISP"))
;(sfsp_add '("C:\\programdata\\autodesk\\applicationplugins\\TRUSS-PY.bundle\\Contents"))
;(sfsp_add '("C:\\programdata\\autodesk\\applicationplugins\\TRUSS-PY.bundle\\Resources\\dwg"))
(princ "Loading TRUSS-PY functions and commands ...\n")
(vl-load-com)
(load "f_functions")
(load "c_define_elements")
(load "c_define_supports")
(load "c_define_loads")
(load "c_export_model")
(load "c_draw_forces")
(load "c_draw_displacements")
(load "c_draw_geometry")
(load "c_draw_reactions")
(load "c_draw_stresses")
(princ "DONE")