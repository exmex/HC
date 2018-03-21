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

import android.os.Bundle;
import com.playhaven.android.view.PlayHavenView;

/**
 * Notification for content loading/failing
 */
public interface PlacementListener
{
    /**
     * Content was loaded successfully
     *
     * @param placement to load
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void contentLoaded(Placement placement);

    /**
     * Content failed to load successfully
     *
     * @param placement that was attempted
     * @param e containing the error that prevented loading
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void contentFailed(Placement placement, PlayHavenException e);

    /**
     * The content was dismissed
     *
     * @param placement that was dismissed
     * @param dismissType how it was dismissed
     * @param data additional data, depending on the content type
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see com.playhaven.android.data.Purchase
     * @see com.playhaven.android.data.Reward
     * @see com.playhaven.android.data.DataCollectionField
     */
    public void contentDismissed(Placement placement, PlayHavenView.DismissType dismissType, Bundle data);
}
