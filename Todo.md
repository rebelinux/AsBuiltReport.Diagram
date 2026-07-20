## High Priority
- [ ] Add-HtmlNodeTable
  - [x] Add Port to Subgraph section
  - [ ] Add option to set image size by percent and by pixels (width x height)
  - [x] In -MultiIcon mode, only the label TD gets a PORT (`PORT="{Element}"`) — the icon TD above it has no port at all. This means edges targeting a specific element (e.g. `"NodeName":"SpokeLabel"`) always land on the label cell, never the icon, even though single-icon (non-MultiIcon) nodes naturally let edges land on the icon since the whole node is the target. Add a dedicated port to the icon TD (e.g. `PORT="Icon_{Element}"`, keeping the existing label port intact for backwards compatibility) so consumers can choose to route edges onto the icon instead of the label.
  - [x] Add pester to test this funtionality
  - [x] Add documentation for this funtionality
  - [x] Add example for this funtionality
- [x] Add function to dinamically build Table cells based on input use Format-HTMLTable as example
  - [x] Add pester to test this funtionality
  - [x] Add documentation for this funtionality
  - [x] Add example for this funtionality

## Medium Priority


## Low Priority

- [ ] Add option to set icon size by percent
  - [ ] Add pester to test this funtionality