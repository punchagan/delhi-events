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
   (ocaml (>= 5.1.1))
   (dune (>= 3.8))
   yojson
   ppx_deriving_yojson
   tyxml
   icalendar
   (eio (>= 1.0))
   eio_main
   cohttp-eio
   tls-eio
   lambdasoup
   cmdliner
   mirage-crypto-rng-eio
   cmarkit
   rss
 )
 (tags
  (topics events calendar html rss generator ssg)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
