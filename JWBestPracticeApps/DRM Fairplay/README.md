##  DRMPlayer - Best Practices App

The DRMPlayer project illustrates how to use our DRM implementation to play a FairPlay encrypted streams. The stream used in this demo was generously provided by EZDRM.

When a FairPlay encrypted stream is loaded through the `JWPlayerKit` framework, the `JWDRMContentKeyDataSource` protocol methods are called to request the data required to decrypt the stream. Please note that the data required and the procedures for obtaining the data are specific to your business needs and may not be covered in this demo.

> **Note:** FairPlay streams **cannot** be played on the simulator; you will need to run this project on a device.
