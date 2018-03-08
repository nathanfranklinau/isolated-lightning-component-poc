/**
 * Handles the messaging between the LightningComponentWrapper Visualforce page and the parent that has called it.
 */
window.IFRAME_PROXY = (function() {

	var $context = this,
		monitoredEvents = [],
		monitoredComponents = {},
		eventListenerEnabled = false,
		origin = '';

	/**
	 * This will ensure that we only only listen to 1 message event handler.
	 * If many events are being monitored, listening to many message event handlers might cause performance issues.
	 *
	 * This is ALWAYS called from the parent Visualforce page.
	 */
	var maybeStartEventListener = function() {
		if(!eventListenerEnabled) {
		    eventListenerEnabled = true;

			// Whenever the message event is fired, we loop through all the events that are monitored to try and find a match to proxy back to the parent.
		    window.addEventListener("message", function(event) {

		        for(var i=0;i<monitoredEvents.length;i++) {
		         	var componentWindow = document.getElementById(monitoredEvents[i].componentWindowId);

		         	// check the iframe window that the message came from matches the iframe of the event that is being monitored.
		         	// make sure the eventType matches the event that is being monitored
					if(event.origin == $context.origin && componentWindow.contentWindow == event.source && event.data != null && isObject(event.data) && event.data.eventType == monitoredEvents[i].eventType) {
						// callback to monitored events call back
						if(monitoredEvents[i].callback)
							monitoredEvents[i].callback(event.data);
					}
          		}
			}, false);
  		}
 	};

	/**
	 * When the LightningComponentWrapper page receives a monitored event from a lightning component, this is sent back up to the main page
	 * This will only ever be called in the LightningComponentWrapper page.
	 */
	var proxyLightningEvent = function(event) {
	    var eventType = event.getType();
	    var params = event.getParams();
	    if(!isObject(params))
	    	params = {};

	    params.eventType = eventType;

	    // post the actual message from the LightningComponentWrapper back to the parent Visualforce page.
	    // both pages are in the Visualforce origin space, but as an added precaution, we only dispatch the message to a single origin
	    // when this message is received, we also check the origin and only process events where the origin matches our source.
		window.parent.postMessage(params, $context.origin);
 	};

	/**
	 * On the main visualforce page, this is used to monitor for proxied events that have come from a lightning component and been proxied through the LightningComponentWrapper page.
	 * This ensure that only 1 listener event is created per window and will add any number of proxied events to listen for
	 */
 	var monitorProxiedEvent = function(componentWindowId, eventType, callback) {
 	    monitoredComponents[componentWindowId] = true;
 	    monitoredEvents.push({componentWindowId: componentWindowId, eventType: eventType, callback: callback});
 	    maybeStartEventListener();
  	};

  	var isObject = function(value) {
  	    return Object.prototype.toString.call(value).indexOf('Object') !== -1;
   	};

   	var isArray = function(value) {
    	return Object.prototype.toString.call(value).indexOf('Array') !== -1;
    };

    return {
    	origin: origin,
        proxyLightningEvent: proxyLightningEvent,
        monitorProxiedEvent: monitorProxiedEvent
    }
})();