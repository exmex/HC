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
 * The request resulted in a lack of content.
 *
 */
public class NoContentException
    extends PlayHavenException
{
    private static final long serialVersionUID = 3749072636752677104L;

    // per [secaucus]
    private static final String message = "The request was successful but did not contain any displayable content. This may have occurred because there are no content units assigned to this placement; all content units assigned to this placement are suppressed by frequency caps or targeting; no ad campaigns are available at this time; or an invalid placement was requested. Visit the PlayHaven Dashboard for more details.";

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public NoContentException() {
        super(message);
    }
}
