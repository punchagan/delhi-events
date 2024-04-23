(lang dune 3.15)

(name delhi_events)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

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
   mirage-crypto-rng-eio)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
