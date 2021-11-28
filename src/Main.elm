module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class) 
import Html.Events exposing (onMouseOver, onMouseOut)

main : Program () Model Msg
main = 
    Browser.element 
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


-- MODEL 

type alias Gate = 
    { name : String
    , template : String
    }

type alias Model = 
    { program : String
    , gates : List Gate
    , suggestion: Maybe String
    }

gates : List Gate
gates = 
    [ Gate "nand" "(nand a=1 b=1 out=out)"
    ]

init : () -> (Model, Cmd Msg)
init _ = 
    (Model "" gates Nothing, Cmd.none)



-- UPDATE

type Msg 
    = ShowPreview String
    | HidePreview 


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        ShowPreview s ->
            ({ model | suggestion = Just s }, Cmd.none)

        HidePreview ->
            ({ model | suggestion = Nothing }, Cmd.none)



-- VIEW

view : Model -> Html Msg
view model = 
    div [ class "container" ] 
        [ viewGates model.gates 
        , viewEditor model.program model.suggestion
        ]

viewGates : List Gate -> Html Msg
viewGates gs = 
    let 
        heading = h2 [] [ text "Gates" ]
        gateEls = List.map viewGate gs 
        body = heading :: gateEls
    in
    div [ class "gates" ] 
        body

viewGate : Gate -> Html Msg
viewGate {name, template} = 
    span [ onMouseOver (ShowPreview template)
         , onMouseOut HidePreview
         ] [ text name ] 


viewEditor : String -> Maybe String -> Html Msg
viewEditor program suggestion = 
    let 
        t = case suggestion of
            Just s ->
                program ++ "\n" ++ s
            Nothing ->
                program
    in
    div [ class "editor" ]
        [ textarea [] [ text t ]  
        ]


-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions _ = 
    Sub.none
