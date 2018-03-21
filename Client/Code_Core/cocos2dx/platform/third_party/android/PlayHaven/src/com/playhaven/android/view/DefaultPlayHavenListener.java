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
package com.playhaven.android.view;

import android.os.Bundle;
import com.playhaven.android.PlayHavenException;

/**
 * Default no-op handler
 */
public class DefaultPlayHavenListener
implements PlayHavenListener
{
    /**
     * The view failed to load
     *
     * @param view that was attempted
     * @param exception that prevented loading of the view
     */
    @Override
    public void viewFailed(PlayHavenView view, PlayHavenException exception) {
        /* no-op */
    }

    /**
     * The view was dismissed
     *
     * @param view that was dismissed
     * @param dismissType how it was dismissed
     * @param data additional data, depending on the content type
     * @see com.playhaven.android.data.Purchase
     * @see com.playhaven.android.data.Reward
     * @see com.playhaven.android.data.DataCollectionField
     */
    @Override
    public void viewDismissed(PlayHavenView view, PlayHavenView.DismissType dismissType, Bundle data) {
        /* no-op */ 
    }
}
