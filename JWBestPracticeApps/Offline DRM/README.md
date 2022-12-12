
## Offline DRM - Best Practices App


The DRM Fairplay project illustrates how to use our DRM implementation to play FairPlay encrypted streams. The stream should be a [signed URL](https://docs.jwplayer.com/platform/reference/protect-your-content-with-signed-urls) that you generate for DRM protected content from JW Player StudioDRM.

Important: you need a Fairplay package from Apple to enable Fairplay for your content, more information [here](https://docs.jwplayer.com/players/docs/ios-apply-studio-drm-with-jw-platform#enabling-apple-fairplay-streaming).

For `JWPlayerKit` to request your content keys we can do it in two ways:

* Requesting them directly through an instance of `JWDRMContentLoader` by loading the asset, calling `JWDRMContentLoader.load` and using the `JWDRMContentKeyManager` to listen to updates from the content loader.

* Initializing an instance of a `JWDRMContentLoader` and setting it as the player's `contentLoader`. You will still need to listen to updates from the content loader in your `JWDRMContentKeyManager`.

The updates that are received from the `JWDRMContentLoader` in your `JWDRMContentKeyManager` are:

* To write the keys.

* To notify they have been written.

* To get the key type, if they will be persistable or not.

* To delete the keys.

* To check if the keys exist in memory.

* To get the URL for the keys.

* To report that an error has been encountered.

On this BPA, we also add a snippet to download the DRM HLS stream so that you can test that the keys are working offline.

> ****Note:**** FairPlay streams ****cannot**** be played on the simulator; you will need to run this project on a device.
