package com.eventhub.util;

public class EventHubException extends Exception {

    private static final long serialVersionUID = 1L;

    public EventHubException(String message) {
        super(message);
    }

    public EventHubException(String message, Throwable cause) {
        super(message, cause);
    }
}