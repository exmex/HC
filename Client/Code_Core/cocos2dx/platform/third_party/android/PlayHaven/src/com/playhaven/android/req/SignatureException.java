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
package com.playhaven.android.req;

import com.playhaven.android.PlayHavenException;

/**
 * The request resulted in a lack of content due to
 * an invalidate signature.
 */
public class SignatureException
extends PlayHavenException
{
    private static final long serialVersionUID = 9097118801340451686L;
    private static final String messageFmt = "The request returned an invalid %s signature. %s";
    public enum Type
    {
        Digest, Reward, Purchase
    }

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public SignatureException(Type type)
    {
        this(type, "");
    }

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public SignatureException(Type type, String message)
    {
        super(messageFmt, type, message);
    }

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public SignatureException(Throwable cause, Type type)
    {
        super(cause, messageFmt, type, "");
    }

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public SignatureException(Throwable cause, Type type, String message)
    {
        super(cause, messageFmt, type, message);
    }

}
