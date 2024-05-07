## Release v0.17.0

- Introduce `Topological_sort.Traversal_order` module with traversal order options:
  * `Decreasing_order`
  * `Decreasing_order_with_isolated_nodes_first`
  * `Unspecified` for performance optimization

- Update `Topological_sort.sort` and `Topological_sort.sort_or_cycle` functions:
  * Add optional `traversal_order` parameter with default `Decreasing_order_with_isolated_nodes_first`
  * Introduce optional `verify` parameter with default `true`

## Release v0.16.0

- Add new function:
  * `Topological_sort.sort_or_cycle`
    Similar to `Topological_sort.sort`, but returns the cycle if one exists instead of an error

## Old pre-v0.15 changelogs (very likely stale and incomplete)

# v0.11

Drop dependency to core\_kernel in favor of base + stdio.

# v0.10

Initial release
