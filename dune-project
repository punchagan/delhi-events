(lang dune 3.15)

(name delhi_events)

(generate_opam_files true)

(source
 (github punchagan/delhi-events))

(authors "Puneeth Chaganti")
(maintainers "Puneeth Chaganti")

(license ISC)

(package
 (name delhi_events)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ocaml
   dune
   yojson
   ppx_deriving_yojson
   tyxml
   icalendar
   (eio (>= 1.0))
   eio_main
   cohttp-eio
   lambdasoup
   tls-eio
   cmdliner
   mirage-crypto-rng-eio)
 (tags
  (topics events calendar html rss generator ssg)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
