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

import android.content.Context;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.View;
import com.playhaven.android.Placement;

/**
 * Android-based Content Unit
 */
public class NativeView extends View
implements ChildView<NativeView>
{
    /**
     * Simple constructor to use when creating a NativeView from code.
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     */
    public NativeView(Context context) {
        super(context);
    }

    /**
     * Constructor that is called when inflating a NativeView from XML. This is called
     * when a NativeView is being constructed from an XML file, supplying attributes
     * that were specified in the XML file. This version uses a default style of
     * 0, so the only attribute values applied are those in the Context's Theme
     * and the given AttributeSet.
     *
     * <p>
     * The method onFinishInflate() will be called after all children have been
     * added.
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     * @param attrs The attributes of the XML tag that is inflating the view.
     * @see View#View(Context, AttributeSet, int)
     */
    public NativeView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    /**
     * Perform inflation from XML and apply a class-specific base style. This constructor
     * of NativeView allows subclasses to use their own base style when they are inflating. For example,
     * a Button class's constructor would call this version of the super class constructor and supply
     * R.attr.buttonStyle for defStyle; this allows the theme's button style to modify all of the base view
     * attributes (in particular its background) as well as the Button class's attributes.
     *
     * @param context The Context the view is running in, through which it can access the current theme, resources, etc.
     * @param attrs The attributes of the XML tag that is inflating the view.
     * @param defStyle The default style to apply to this view. If 0, no style will be applied (beyond what is included in the theme). This may either be an attribute resource, whose value will be retrieved from the current theme, or an explicit style resource.
     */
    public NativeView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    /**
     * Set the placement as configured in the Dashboard
     *
     * @param placement to display
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    @Override
    public void setPlacement(Placement placement) {
        //To change body of implemented methods use File | Settings | File Templates.
    }

    /**
     * Create a response bundle for passing back to the publisher
     *
     * @return bundle containing data
     */
    @Override
    public Bundle generateResponseBundle() {
        return null;
    }
}
