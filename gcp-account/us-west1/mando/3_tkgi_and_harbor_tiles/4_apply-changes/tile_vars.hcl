locals {
  # Apply the tiles that were installed. If installing more tiles, specify the product names in this list. Can be left empty but apply will take longer since it will apply all tiles.
  # No need to apply TAS4VMs and TKGI since those scripts apply them.
  product_names_to_apply  = ["harbor-container-registry"]
}
