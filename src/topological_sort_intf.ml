open! Import

module type Node = sig
  type t [@@deriving sexp_of]

  include Equal.S with type t := t
  include Hashtbl.Key.S with type t := t
end

module type Topological_sort = sig
  module type Node = Node

  module Edge : sig
    type 'a t =
      { from : 'a
      ; to_ : 'a
      }
    [@@deriving sexp_of]
  end

  (** Controls the order in which we begin traversing nodes as entry points into the
      graph. The earliest nodes with finished traversals are returned last. *)
  module Traversal_order : sig
    type t =
      | Decreasing_order (** Process in decreasing order of [Node.compare]. *)
      | Decreasing_order_with_isolated_nodes_first
      (** Process isolated nodes -- those without edges -- first, and then the rest. Both
          groups go in decreasing order of [Node.compare]. *)
      | Unspecified
      (** Allows an implementation-specific, unspecified order. Order may be unstable
          and/or nondeterministic. Provides best performance. *)
  end

  module What : sig
    type t =
      | Nodes
      | Nodes_and_edge_endpoints
    [@@deriving sexp_of]
  end

  (** [sort (module Nodes) ~what ~nodes ~edges] returns a list of nodes [output]
      satisfying:

      - [output] contains one occurrence of every node in [nodes] when [what = Nodes], or
        one occurrence of every node in [nodes] and [edges] when
        [what = Nodes_and_edge_endpoints].
      - if [{ from; to_ }] is in [edges], then [from] occurs before [to_] in [output].

      [sort] returns [Error] if there is a cycle.

      [traversal_order] determines the order in which we processing nodes as entry points
      into the graph.

      [verify] checks that the sorted output or generated cycle is indeed correct. *)
  val sort
    :  ?traversal_order:Traversal_order.t
         (** default is [Decreasing_order_with_isolated_nodes_first] *)
    -> ?verbose:bool (** default is [false] *)
    -> ?verify:bool (** default is [true] *)
    -> (module Node with type t = 'node)
    -> what:What.t
    -> nodes:'node list
    -> edges:'node Edge.t list
    -> 'node list Or_error.t

  (** Same as [sort], but returns the cycle if there is one. *)
  val sort_or_cycle
    :  ?traversal_order:Traversal_order.t
         (** default is [Decreasing_order_with_isolated_nodes_first] *)
    -> ?verbose:bool (** default is [false] *)
    -> ?verify:bool (** default is [true] *)
    -> (module Node with type t = 'node)
    -> what:What.t
    -> nodes:'node list
    -> edges:'node Edge.t list
    -> ('node list, [ `Cycle of 'node list ]) Result.t
end
