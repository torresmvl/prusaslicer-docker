# PrusaSlicer - GPU ready

Powered with the benefits of VirtualGL, this docker image is able to be deployed remotely and access its GUI
Batch-processing is working accordingly.

## How to use this image?

Run `make nvidia` or `make` to show help

Once deployed, you can access the container remotely with x11 forwarding enabled:

`ssh -X root@docker-container -p 2222` or with **vglconnect**: `DISPLAY=:0 vglconnect -s root@docker-container -p 2222`

## Notes

- The default SSH password is **virtualgl**
- **supervisord** webGUI is reachable on port :9001, you can start the application from there.
- Be sure to use Xming/Xqartz on Windows/OS X
