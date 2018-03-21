/**
 * Copyright 2013 Medium Entertainment, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.playhaven.android;

import java.io.IOException;

/**
 * An error occurred within the PlayHaven framework
 */
public class PlayHavenException
        extends IOException
{

    private static final long serialVersionUID = 3658185815214219062L;

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace filled in.
     */
    public PlayHavenException() {
        super();
    }

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and detail
     * message filled in.
     *
     * @param detailMessage
     *            the detail message for this exception.
     */
    public PlayHavenException(String detailMessage) {
        super(detailMessage);
    }

    /**
     * Constructs a new instance of this class with detail message and cause
     * filled in.
     *
     * @param message
     *            The detail message for the exception.
     * @param cause
     *            The detail cause for the exception.
     */
    public PlayHavenException(String message, Throwable cause) {
        // @playhaven.apihack Can't use super(message, cause) because of API8 compat
        super(message);
        initCause(cause);
    }

    /**
     * Constructs a new instance of this class with its detail cause filled in.
     *
     * @param cause
     *            The detail cause for the exception.
     */
    public PlayHavenException(Throwable cause) {
        // @playhaven.apihack Can't use super(cause) because of API8 compat
        super(cause.getMessage());
        initCause(cause);
    }

    /**
     * Convenience wrapper
     *
     * @param fmt format
     * @param args arguments
     * @see PlayHavenException#PlayHavenException(String)
     * @see String#format(String, Object...)
     */
    public PlayHavenException(String fmt, Object ... args) {
        this(String.format(fmt, args));
    }

    /**
     * Convenience wrapper
     *
     * @param cause of the exception
     * @param fmt format
     * @param args arguments
     * @see PlayHavenException#PlayHavenException(String, Throwable)
     * @see String#format(String, Object...)
     */
    public PlayHavenException(Throwable cause, String fmt, Object ... args) {
        this(String.format(fmt, args), cause);
    }

}
