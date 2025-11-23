build:
  kas-container build reference.yaml

clean:
  kas-container purge reference.yaml

spotless: clean
  rm -rf build/
  rm -rf sources/

shell:
  kas-container shell reference.yaml

flash device:
  sudo dd if=./build/tmp-raspberrypi5/deploy/images/raspberrypi5/autonomos-devel-Rubik-raspberrypi5.sdimg of={{device}} bs=1M conv=sparse status=progress && sudo sync
