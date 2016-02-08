open Core.Std
open Async.Std
open Telegram_t

type command =
  | Dolly

let command_of_string str =
  if str = "dolly" then Dolly
  else failwith "Invalid command"

let response_from_update { update_id = _; message = maybe; } =
  match maybe with
  | Some msg ->
     begin match msg.text with
           | Some text ->
              let chat_id = (msg.chat).id
              in let s_msg = { chat_id = chat_id; text = text; }
              in let response = `String (Telegram_j.string_of_send_message s_msg)
              in Cohttp_async.Server.respond ~body:response `OK
           | None -> failwith "No text in update"
     end
  | None -> failwith "No message in update"

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
               response_from_update (Telegram_j.update_of_string body))
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

