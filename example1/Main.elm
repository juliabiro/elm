import Counter  exposing (Model, Action,  update, view)

import StartApp.Simple exposing (start)

main =
      start { model = 0, update = update, view = view }

