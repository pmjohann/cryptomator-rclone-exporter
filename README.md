# cryptomator-rclone-exporter
Export cryptomator protected filesystems located on any rclone supported backend.

## Usage

```
docker run --rm -v /hostpath/to/rclone.conf:/rclone.conf -v /hostpath/to/decrypted/contents:/export pmjohann/cryptomator-rclone-exporter $RCLONE_REMOTE_NAME $CRYPTOMATOR_PASSWORD
```
