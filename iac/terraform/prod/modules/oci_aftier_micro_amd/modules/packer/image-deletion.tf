#data "oci_core_images" "existing_images" {
#  compartment_id = oci_identity_compartment.yohapp-packer-comp.id
#  sort_by        = "TIMECREATED"
#  sort_order     = "ASC"
#}

#resource "null_resource" "delete_old_images" {
#  count = 1

#  provisioner "local-exec" {
#    command = <<-EOF
#      images_to_delete=$(echo '${jsonencode([for img in local.images_to_delete : img.id])}' | jq -r '.[]' 2>/dev/null || echo "")
#      if [ -n "$images_to_delete" ]; then
#        echo "$images_to_delete" | while read -r image_id; do
#          if [ -n "$image_id" ]; then
#            oci compute image delete --image-id "$image_id" --force
#          fi
#        done
#      fi
#    EOF
#  }

#  triggers = {
#    images_hash = try(md5(jsonencode([for img in local.images_to_delete : img.id])), "empty")
#  }
#}