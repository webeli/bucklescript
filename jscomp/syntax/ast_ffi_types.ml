(* Copyright (C) 2015-2016 Bloomberg Finance L.P.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)


type external_module_name = 
  { bundle : string ; 
    bind_name : string option
  }

type pipe = bool 
type js_call = { 
  name : string;
  external_module_name : external_module_name option;
  splice : bool 
}

type js_send = { 
  name : string ;
  splice : bool ; 
  pipe : pipe   
} (* we know it is a js send, but what will happen if you pass an ocaml objct *)

type js_global_val = {
  name : string ; 
  external_module_name : external_module_name option
}

type js_new_val = {
  name : string ; 
  external_module_name : external_module_name option;
  splice : bool ;
}

type js_module_as_fn = 
  { external_module_name : external_module_name;
    splice : bool 
  }
  
(** TODO: information between [arg_type] and [arg_label] are duplicated, 
  design a more compact representation so that it is also easy to seralize by hand
*)  
type arg_type = Ast_core_type.arg_type =
  | NullString of (int * string) list (* `a does not have any value*)
  | NonNullString of (int * string) list (* `a of int *)
  | Int of (int * int ) list (* ([`a | `b ] [@bs.int])*)
  | Arg_int_lit of int 
  | Arg_string_lit of string 
  | Fn_uncurry_arity of int (* annotated with [@bs.uncurry ] or [@bs.uncurry 2]*)
  (* maybe we can improve it as a combination of {!Asttypes.constant} and tuple *)
  | Array 
  | Extern_unit
  | Nothing

  
  | Ignore (* annotated with [@bs.ignore] *)

type arg_label = 
  | Label of string 
  | Label_int_lit of string * int 
  | Label_string_lit of string * string 
  | Optional of string 
  | Empty (* it will be ignored , side effect will be recorded *)
  | Empty_int_lit of int 
  | Empty_string_lit of string 
(**TODO: maybe we can merge [arg_label] and [arg_type] *)
type arg_kind = 
  {
    arg_type : arg_type;
    arg_label : arg_label
  }
type obj_create = arg_kind list

type ffi = 
  (* | Obj_create of obj_create *)
  | Js_global of js_global_val 
  | Js_module_as_var of  external_module_name
  | Js_module_as_fn of js_module_as_fn
  | Js_module_as_class of external_module_name             
  | Js_call of js_call 
  | Js_send of js_send
  | Js_new of js_new_val
  | Js_set of string
  | Js_get of string
  | Js_get_index
  | Js_set_index

let name_of_ffi ffi =
  match ffi with 
  | Js_get_index -> "[@@bs.get_index]"
  | Js_set_index -> "[@@bs.set_index]"
  | Js_get s -> Printf.sprintf "[@@bs.get %S]" s 
  | Js_set s -> Printf.sprintf "[@@bs.set %S]" s 
  | Js_call v  -> Printf.sprintf "[@@bs.val %S]" v.name
  | Js_send v  -> Printf.sprintf "[@@bs.send %S]" v.name
  | Js_module_as_fn v  -> Printf.sprintf "[@@bs.val %S]" v.external_module_name.bundle
  | Js_new v  -> Printf.sprintf "[@@bs.new %S]" v.name                    
  | Js_module_as_class v
    -> Printf.sprintf "[@@bs.module] %S " v.bundle
  | Js_module_as_var v
    -> 
    Printf.sprintf "[@@bs.module] %S " v.bundle
  | Js_global v 
    -> 
    Printf.sprintf "[@@bs.val] %S " v.name                    
(* | Obj_create _ -> 
   Printf.sprintf "[@@bs.obj]" *)

type return_wrapper = 
  | Return_unset 
  | Return_identity
  | Return_undefined_to_opt  
  | Return_null_to_opt
  | Return_null_undefined_to_opt
  | Return_to_ocaml_bool
  | Return_replaced_with_unit    
type t  = 
  | Ffi_bs of arg_kind list  *
     return_wrapper * ffi 
  (**  [Ffi_bs(args,return,ffi) ]
       [return] means return value is unit or not, 
        [true] means is [unit]  
  *)
  | Ffi_obj_create of obj_create
  | Ffi_normal 
  (* When it's normal, it is handled as normal c functional ffi call *)



let valid_js_char =
  let a = Array.init 256 (fun i ->
      let c = Char.chr i in
      (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c = '_' || c = '$'
    ) in
  (fun c -> Array.unsafe_get a (Char.code c))

let valid_first_js_char = 
  let a = Array.init 256 (fun i ->
      let c = Char.chr i in
      (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c = '_' || c = '$'
    ) in
  (fun c -> Array.unsafe_get a (Char.code c))

(** Approximation could be improved *)
let valid_ident (s : string) =
  let len = String.length s in
  len > 0 && valid_js_char s.[0] && valid_first_js_char s.[0] &&
  (let module E = struct exception E end in
   try
     for i = 1 to len - 1 do
       if not (valid_js_char (String.unsafe_get s i)) then
         raise E.E         
     done ;
     true     
   with E.E -> false )  

let valid_global_name ?loc txt =
  if not (valid_ident txt) then
    let v = Ext_string.split_by ~keep_empty:true (fun x -> x = '.') txt in
    List.iter
      (fun s ->
         if not (valid_ident s) then
           Location.raise_errorf ?loc "Not a valid name %s"  txt
      ) v      

let valid_method_name ?loc txt =         
  if not (valid_ident txt) then
    Location.raise_errorf ?loc "Not a valid name %s"  txt



let check_external_module_name ?loc x = 
  match x with 
  | {bundle = ""; _ } | {bind_name = Some ""} -> 
    Location.raise_errorf ?loc "empty name encountered"
  | _ -> ()
let check_external_module_name_opt ?loc x = 
  match x with 
  | None -> ()
  | Some v -> check_external_module_name ?loc v 


let check_ffi ?loc ffi = 
  match ffi with 
  | Js_global {name} -> valid_global_name ?loc  name
  | Js_send {name } 
  | Js_set  name
  | Js_get name
    ->  valid_method_name ?loc name
  (* | Obj_create _ -> () *)
  | Js_get_index | Js_set_index 
    -> ()

  | Js_module_as_var external_module_name
  | Js_module_as_fn {external_module_name; _}
  | Js_module_as_class external_module_name             
    -> check_external_module_name external_module_name
  | Js_new {external_module_name ;  name}
  | Js_call {external_module_name ;  name ; _}
    -> 
    check_external_module_name_opt ?loc external_module_name ;
    valid_global_name ?loc name     

let bs_prefix = "BS:"
let bs_prefix_length = String.length bs_prefix 


(** TODO: Make sure each version is not prefix of each other
    Solution:
    1. fixed length 
    2. non-prefix approach
*)
let bs_external = bs_prefix ^ Bs_version.version 


let bs_external_length = String.length bs_external


let to_string  t = 
  bs_external ^ Marshal.to_string t []


(* TODO:  better error message when version mismatch *)
let from_string s : t = 
  let s_len = String.length s in 
  if s_len >= bs_prefix_length &&
     String.unsafe_get s 0 = 'B' &&
     String.unsafe_get s 1 = 'S' &&
     String.unsafe_get s 2 = ':' then 
    if Ext_string.starts_with s bs_external then 
      Marshal.from_string s bs_external_length 
    else 
      Ext_pervasives.failwithf 
        ~loc:__LOC__
        "compiler version mismatch, please do a clean build"
  else Ffi_normal    
