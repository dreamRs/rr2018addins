
#' @title Réorganise les appels à \code{library}.
#'
#' @description Place les appels à \code{library} disséminés dans un
#'  script au début et les remplace par une section contenant le nom du package.
#'
#' @export
#'
#' @importFrom rstudioapi getActiveDocumentContext modifyRange insertText
#' @importFrom stringr str_which str_replace str_c
#'
#' @examples
#' # Utilisez le menu "Addins" dans
#' # RStudio pour exécuter la fonction !
reorder_library <- function() {

  # Recupère le contenu du script courant
  script <- rstudioapi::getActiveDocumentContext()$contents

  # Identifie les lignes avec des appels à library()
  indice_library <- stringr::str_which(
    string = script,
    pattern = "library\\([:alnum:]+\\)"
  )

  # on les remplace par une section avec le nom du package
  rng_library <- Map(c, Map(c, indice_library, 1), Map(c, indice_library, 80))
  rstudioapi::modifyRange(
    location = rng_library, # position des library() dans le script
    text = stringr::str_replace(
      string = script[indice_library],
      pattern = "library\\(([:alnum:]+)\\)",
      replacement = "# \\1 ----"
    )
  )

  # on les place les appels à library() en début de script
  rstudioapi::insertText(
    location = c(1, 1), # début du script
    text = stringr::str_c(c(
      "\n# Packages ----",
      script[indice_library],
      "\n"
    ), collapse = "\n")
  )

  return(invisible())
}












