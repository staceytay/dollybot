open Core.Std
open Async.Std
open Telegram_t

type command =
  | Dolly

let command_of_string str =
  if str = "dolly" then Dolly
  else failwith "Invalid command"

let handle_update { update_id = uid; message = m; } =
  match m with
  | Some m ->
     begin
       match m with
       | Chat _ | Message _ | User _ -> Deferred.unit
     end
  | None ->
     Log.Global.info "  handle_update: Empty update...";
     Deferred.unit

let run ~port =
  Cohttp_async.Server.create
    ~on_handler_error:`Raise
    (Tcp.on_port port)
    (fun ~body _ req ->
       match (Cohttp.Request.meth req) with
       | `POST ->
          Cohttp_async.Body.to_string body
          >>= (fun body ->
               Log.Global.info "POST: %s" body;
               handle_update (Telegram_j.update_of_string body))
          >>= (fun () -> Cohttp_async.Server.respond `OK)
       | _ -> Cohttp_async.Server.respond `Method_not_allowed
    )
  >>= fun _ -> Deferred.never ()

let () =
  Command.async_basic
    ~summary:"Start a telegram bot server"
    Command.Spec.(
      empty
      +> flag "-port" (optional_with_default 8080 int)
         ~doc: " Port to listen on (default 8080)"
    )
    (fun port () -> run ~port)
  |> Command.run

