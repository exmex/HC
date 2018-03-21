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

import android.content.Context;
import android.content.ReceiverCallNotAllowedException;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Point;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import com.jayway.jsonpath.JsonPath;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.Version;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.data.ContentUnitType;
import com.playhaven.android.util.JsonUtil;
import com.playhaven.android.util.KontagentUtil;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

import static com.playhaven.android.PlayHaven.Config.*;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.auth.GooglePlayServicesAvailabilityException;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.api.GoogleApiClient;
/**
 * Base class for making requests to the server
 */
public abstract class PlayHavenRequest
{
    protected static final String HMAC = "HmacSHA1";
    private String lastUrl;

    /**
     * Handler for server response
     */
    private RequestListener handler;

    /**
     * Signature verification
     */
    private Mac sigMac;

    /**
     * Kontagent senderId
     */
    private String ktsid;

    /**
     * HTTP Method to use
     */
    private HttpMethod restMethod = HttpMethod.GET;

    /**
     * Custom Dimensions
     */
    private JSONObject customDimensions;

    /**
     * Identifiers desired to use in request
     */
    private Set<Identifier> identifiers;

    /**
     * Identifiers actually used in the request
     */
    private Set<Identifier> usedIdentifiers;

    /**
     * Android Advertiser ID
     */
    private String ifa = null;

    protected PlayHavenRequest()
    {
        // Default
        identifiers = new HashSet<Identifier>();
        identifiers.add(Identifier.AndroidID);
        identifiers.add(Identifier.SenderID);
        identifiers.add(Identifier.Signature);

        usedIdentifiers = new HashSet<Identifier>();
    }

    /**
     * Set the identifiers to use during the request
     *
     * @param identifiers to use
     */
    public void setIdentifiers(Set<Identifier> identifiers) throws PlayHavenException {
        if(identifiers.isEmpty())
            throw new PlayHavenException(new IllegalArgumentException("At least one identifier must be set"));

        this.identifiers = identifiers;
    }

    /**
     * Set the identifiers to use during the request
     *
     * @param identifiers to use
     */
    public void setIdentifiers(Identifier ... identifiers) throws PlayHavenException {
        setIdentifiers(new HashSet<Identifier>(Arrays.asList(identifiers)));
    }

    /**
     * Set the identifiers to use during the request
     *
     * @param json of identifiers to use
     */
    public void setIdentifiers(JSONArray json) throws PlayHavenException {
        if(json == null) return;

        HashSet<Identifier> ids = new HashSet<Identifier>();
        for(Identifier id : Identifier.values())
        {
            if(json.contains(id.getParam()) || json.contains(id.toString()))
                ids.add(id);
        }
        setIdentifiers(ids);
    }

    public Set<Identifier> getIdentifiers(){return new HashSet<Identifier>(identifiers);}

    /**
     * Set the REST method to use
     *
     * @param method to use
     */
    protected void setMethod(HttpMethod method){this.restMethod = method;}

    /**
     * Return the REST method to use
     *
     * @return method to use
     */
    protected HttpMethod getMethod()
    {
        return restMethod;
    }

    protected HttpHeaders getHeaders()
    {
        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Collections.singletonList(new MediaType("application", "json")));
        headers.setUserAgent(UserAgent.USER_AGENT);
        return headers;
    }

    protected HttpEntity<?> getEntity()
    {
        return new HttpEntity<Object>(getHeaders());
    }

    protected int getApiPath(Context context)
    {
        return -1;
    }

    protected String getString(SharedPreferences pref, PlayHaven.Config param)
    {
        return getString(pref, param, "unknown");
    }

    protected String getString(SharedPreferences pref, PlayHaven.Config param, String defaultValue)
    {
        return pref.getString(param.toString(), defaultValue);
    }

    protected Integer getInt(SharedPreferences pref, PlayHaven.Config param, int defaultValue)
    {
        return pref.getInt(param.toString(), defaultValue);
    }

    @SuppressWarnings("deprecation")
    protected UriComponentsBuilder createApiUrl(Context context) throws PlayHavenException{
        SharedPreferences pref = PlayHaven.getPreferences(context);
        return UriComponentsBuilder.fromHttpUrl(getString(pref, APIServer));
    }

    @SuppressWarnings("deprecation")
    protected UriComponentsBuilder addApiPath(Context context, UriComponentsBuilder builder) throws PlayHavenException{
        builder.path(context.getResources().getString(getApiPath(context)));
        return builder;
    }

    protected AdvertisingIdClient.Info getAdvertisingIdInfo(Context context)
            throws GooglePlayServicesNotAvailableException, IOException, GooglePlayServicesRepairableException
    {
        return AdvertisingIdClient.getAdvertisingIdInfo(context);
    }

    @SuppressWarnings("deprecation")
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        try {
            SharedPreferences pref = PlayHaven.getPreferences(context);

            UriComponentsBuilder builder = createApiUrl(context);
            addApiPath(context, builder);
            builder.queryParam("app", getString(pref, AppPkg));
            builder.queryParam("opt_out", getString(pref, OptOut, "0"));
            builder.queryParam("app_version", getString(pref, AppVersion));
            builder.queryParam("os", getInt(pref, OSVersion, 0));
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            Display display = wm.getDefaultDisplay();
            builder.queryParam("hardware", getString(pref, DeviceModel));
            PlayHaven.ConnectionType connectionType = getConnectionType(context);
            builder.queryParam("connection", connectionType.ordinal());
            builder.queryParam("idiom", context.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK);

            /**
             * For height/width we will use getSize(Point) not getRealSize(Point) as this will allow us to automatically
             * account for rotation and screen decorations like the status bar. We only want to know available space.
             *
             * @playhaven.apihack for SDK_INT < 13, have to use getHeight and getWidth!
             */
            Point size = new Point();
            if (Build.VERSION.SDK_INT >= 13) {
                display.getSize(size);
            } else {
                size.x = display.getWidth();
                size.y = display.getHeight();
            }
            builder.queryParam("width", size.x);
            builder.queryParam("height", size.y);


            /**
             * SDK Version needs to be reported as a dotted numeric value
             * So, if it is a -SNAPSHOT build, we will replace -SNAPSHOT with the date of the build
             * IE: 2.0.0.20130201
             * as opposed to an actual released build, which would be like 2.0.0
             */
            String sdkVersion = getString(pref, SDKVersion);
            String[] date = Version.PLUGIN_BUILD_TIME.split("[\\s]");
            sdkVersion = sdkVersion.replace("-SNAPSHOT", "." + date[0].replaceAll("-", ""));
            builder.queryParam("sdk_version", sdkVersion);


            builder.queryParam("plugin", getString(pref, PluginIdentifer));

            Locale locale = context.getResources().getConfiguration().locale;
            builder.queryParam("languages", String.format("%s,%s", locale.toString(), locale.getLanguage()));
            builder.queryParam("token", getString(pref, Token));

            ifa = null;
            ktsid = null;
            try {
                AdvertisingIdClient.Info adInfo = getAdvertisingIdInfo(context);

                // track = !limitTracking
                if (adInfo != null) {
                    builder.queryParam("tracking", (adInfo.isLimitAdTrackingEnabled() ? 0 : 1));
                    if (identifiers.contains(Identifier.AdvertiserID))
                        ifa = adInfo.getId();
                }
            } catch (GooglePlayServicesRepairableException e) {
                PlayHaven.w(getClass().getSimpleName() + ": Google Play services is not currently available.");
            } catch (GooglePlayServicesNotAvailableException e) {
                PlayHaven.w(getClass().getSimpleName() + ": Google Play services is not available.");
            } catch (IOException e) {
                PlayHaven.w(getClass().getSimpleName() + ": Google Play services is not supported.");
            } catch (ReceiverCallNotAllowedException e) {
                PlayHaven.w(getClass().getSimpleName() + ": Google Play services is not supported from a Receiver");
            }

            for (Identifier id : identifiers) {
                switch (id) {
                    case AdvertiserID:
                        if (ifa != null) {
                            builder.queryParam(Identifier.AdvertiserID.getParam(), ifa);
                            usedIdentifiers.add(id);
                        }

                        break;
                    case AndroidID:
                        builder.queryParam(Identifier.AndroidID.getParam(), getString(pref, DeviceId));
                        usedIdentifiers.add(id);
                        break;
                    case SenderID:
                        ktsid = KontagentUtil.getSenderId(context);
                        if (ktsid != null) {
                            builder.queryParam(Identifier.SenderID.getParam(), ktsid);
                            usedIdentifiers.add(id);
                        }

                        break;
                    default:
                        break;
                }
            }

            DisplayMetrics metrics = new DisplayMetrics();
            display.getMetrics(metrics);
            builder.queryParam("dpi", metrics.densityDpi);

            if (customDimensions != null && !customDimensions.isEmpty())
                builder.queryParam("custom", customDimensions.toJSONString());

            String uuid = UUID.randomUUID().toString();
            String nonce = base64Digest(uuid);
            builder.queryParam("nonce", nonce);

            addSignature(builder, pref, nonce);

            // Setup for signature verification
            String secret = getString(pref, Secret);
            SecretKeySpec key = new SecretKeySpec(secret.getBytes(PlayHaven.getUTF8()), HMAC);
            sigMac = Mac.getInstance(HMAC);
            sigMac.init(key);
            sigMac.update(nonce.getBytes(PlayHaven.getUTF8()));

            return builder;
        }catch(PlayHavenException e){
            throw e;
        }catch(Exception e){
            throw new PlayHavenException(e);
        }
    }

    protected void addSignature(UriComponentsBuilder builder, SharedPreferences pref, String nonce) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException, PlayHavenException {
        addV4Signature(builder, pref, nonce);
    }

    protected void addV3Signature(UriComponentsBuilder builder, SharedPreferences pref, String nonce) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        if(!identifiers.contains(Identifier.Signature))
            return;

        if(identifiers.contains(Identifier.AdvertiserID) && ifa != null)
        {
            builder.queryParam("signature", hexDigest( concat(":", getString(pref, Token), ifa, nonce, getString(pref, Secret) ) ));
        }else{
            builder.queryParam("signature", hexDigest( concat(":", getString(pref, Token), getString(pref, DeviceId), nonce, getString(pref, Secret) ) ));
        }
    }

    private static final String COLON = ":";
    protected void addV4Signature(UriComponentsBuilder builder, SharedPreferences pref, String nonce) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException, PlayHavenException {
        if(!identifiers.contains(Identifier.Signature))
            return;


        boolean first = true;
        StringBuilder sb = new StringBuilder();

        /**
         * Alphabetical order: DEVICE_ID, IFA, KTSID
         * Then Token, Nonce
         */

        if(usedIdentifiers.contains(Identifier.AndroidID))
        {
            sb.append(getString(pref, DeviceId));
            first = false;
        }

        if(usedIdentifiers.contains(Identifier.AdvertiserID) && ifa != null)
        {
            if(!first) sb.append(COLON);
            sb.append(ifa);
            first = false;
        }

        if(usedIdentifiers.contains(Identifier.SenderID) && ktsid != null)
        {
            if(!first) sb.append(COLON);
            sb.append(ktsid);
            first = false;
        }

        if(first)
            throw new NoIdentifierException(identifiers, usedIdentifiers);

        sb.append(COLON);
        sb.append(getString(pref, Token));
        sb.append(COLON);
        sb.append(nonce);

        builder.queryParam(Identifier.Signature.getParam(), createHmac(pref, sb.toString(), true));
        usedIdentifiers.add(Identifier.Signature);
    }

    protected String createHmac(SharedPreferences pref, String content, boolean stripEquals) throws NoSuchAlgorithmException, UnsupportedEncodingException, InvalidKeyException {
        String secret = getString(pref, Secret);
        SecretKeySpec key = new SecretKeySpec(secret.getBytes(PlayHaven.getUTF8()), HMAC);
        Mac hmac = Mac.getInstance(HMAC);
        hmac.init(key);
        hmac.update(content.getBytes(PlayHaven.getUTF8()));
        byte[] bytes = hmac.doFinal();
        String derived = new String(Base64.encode(bytes, Base64.URL_SAFE), PlayHaven.getUTF8()).trim();
        if(stripEquals)
            derived = derived.replaceAll("=", "");

        return derived;
    }

    protected String concat(String delim, String ... data)
    {
        boolean first = true;
        StringBuilder sb = new StringBuilder();
        for(String d : data)
        {
            if(d == null) continue;

            if(!first) sb.append(delim);
            else first = false;

            sb.append(d);
        }
        return sb.toString();
    }

    protected static PlayHaven.ConnectionType getConnectionType(Context context) {
        try {
            ConnectivityManager manager	= (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);

            if (manager == null)
                return PlayHaven.ConnectionType.NO_NETWORK; // happens during tests

            NetworkInfo wifiInfo   = manager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
            if(wifiInfo != null)
            {
                NetworkInfo.State wifi = wifiInfo.getState();
                if(wifi == NetworkInfo.State.CONNECTED || wifi == NetworkInfo.State.CONNECTING)
                    return PlayHaven.ConnectionType.WIFI;
            }

            NetworkInfo mobileInfo = manager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
            if(mobileInfo != null)
            {
                NetworkInfo.State mobile = mobileInfo.getState();
                if(mobile == NetworkInfo.State.CONNECTED || mobile == NetworkInfo.State.CONNECTING)
                    return PlayHaven.ConnectionType.MOBILE;
            }
        } catch (SecurityException e) {
            // ACCESS_NETWORK_STATE permission not granted in the manifest
            return PlayHaven.ConnectionType.NO_PERMISSION;
        }

        return PlayHaven.ConnectionType.NO_NETWORK;
    }

    protected static String convertToHex(byte[] in) {
        StringBuilder builder = new StringBuilder(in.length*2);

        Formatter formatter = new Formatter(builder);
        for (byte inByte : in)
            formatter.format("%02x", inByte);


        return builder.toString();
    }

    /** First encrypts with SHA1 and then spits the result out as a hex string*/
    protected static String hexDigest(String input) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        return convertToHex(dataDigest(input));
    }

    /** First encrypt with SHA1 then convert to Base64*/
    protected static String base64Digest(String input) throws UnsupportedEncodingException, NoSuchAlgorithmException {

        String b64digest = convertToBase64(dataDigest(input));

        // Trim off last character for v1.x compatibility
        return b64digest.substring(0, b64digest.length() - 1);
    }

    protected static String convertToBase64(byte[] in) throws UnsupportedEncodingException {
        if (in == null) return null;

        return new String(Base64.encode(in, Base64.URL_SAFE | Base64.NO_PADDING), PlayHaven.getUTF8());
    }

    protected static byte[] dataDigest(String in) throws NoSuchAlgorithmException, UnsupportedEncodingException{
        if (in == null) return null;

        MessageDigest md = MessageDigest.getInstance("SHA-1");
        return 		  md.digest(in.getBytes(PlayHaven.getUTF8()));
    }

    protected void validateSignatures(Context context, String xPhDigest, String json) throws SignatureException {
        // If sigMac isn't setup... then createUrl wasn't called which means we're probably doing mock calls
        if(sigMac == null) return;

        /**
         * Step 1: Validate X-PH-DIGEST
         */

        // X-PH-DIGEST are required when coming from the server
        if(xPhDigest == null)
            throw new SignatureException(SignatureException.Type.Digest, "No digest found");

        // If json is null, there is nothing to validate against
        if(json == null)
            throw new SignatureException(SignatureException.Type.Digest, "No JSON found");

        // Valid X-PH-DIGEST against sigMac
        sigMac.update(json.getBytes(PlayHaven.getUTF8()));
        byte[] bytes = sigMac.doFinal();
        String derived = new String(Base64.encode(bytes, Base64.URL_SAFE), PlayHaven.getUTF8()).trim();
        if(!xPhDigest.equals(derived)) {
            PlayHaven.v("Signature error. Received: %s != Derived: %s", xPhDigest, derived);
            throw new SignatureException(SignatureException.Type.Digest, "Signature mismatch");
        }

        SharedPreferences pref = PlayHaven.getPreferences(context);

        /**
         * Step 2: Validate any Rewards
         */
        try{
            JSONArray rewards = JsonUtil.getPath(json, "$.response.context.content.*.parameters.rewards");
            if(rewards != null)
            {
                for(int i=0; i<rewards.size(); i++)
                {
                    JSONObject reward = (JSONObject) rewards.get(i);
                    String body = concat(":",
                        getString(pref, DeviceId),
                        JsonUtil.asString(reward, "$.reward"),
                        JsonUtil.asString(reward, "$.quantity"),
                        JsonUtil.asString(reward, "$.receipt")
                    );
                    String mac = createHmac(pref, body, true);
                    String sig = JsonUtil.<String>getPath(reward, "$.sig4");
                    if(!mac.equals(sig))
                        throw new SignatureException(SignatureException.Type.Reward, "Signature does not match.");
                }
            }
        }catch(SignatureException se){
            throw se;
        }catch(Exception e){
            throw new SignatureException(e, SignatureException.Type.Reward);
        }

        /**
         * Step 3: Validate any Purchases
         */
        try{
            JSONArray purchases = JsonUtil.getPath(json, "$.response.context.content.*.parameters.purchases");
            if(purchases != null)
            {
                for(int i=0; i<purchases.size(); i++)
                {
                    JSONObject purchase = (JSONObject) purchases.get(i);
                    String body = concat(":",
                            getString(pref, DeviceId),
                            JsonUtil.asString(purchase, "$.product"),
                            JsonUtil.asString(purchase, "$.name"),
                            JsonUtil.asString(purchase, "$.quantity"),
                            JsonUtil.asString(purchase, "$.receipt")
                    );
                    String mac = createHmac(pref, body, true);
                    String sig = JsonPath.<String>read(purchase, "$.sig4");
                    if(!mac.equals(sig))
                        throw new SignatureException(SignatureException.Type.Purchase, "Signature does not match.");
                }
            }
        }catch(SignatureException se){
            throw se;
        }catch(Exception e){
            throw new SignatureException(e, SignatureException.Type.Purchase);
        }
    }

    public void send(final Context context)
    {
        new Thread(new Runnable(){
            @Override
            public void run() {
                try {
                    /**
                     * First, check if we are mocking the URL
                     */
                    String mockJsonResponse = getMockJsonResponse();
                    if (mockJsonResponse != null) {
                        /**
                         * Mock the response
                         */
                        PlayHaven.v("Mock Response: %s", mockJsonResponse);
                        handleResponse(context, mockJsonResponse);
                        return;
                    }

                    /**
                     * Not mocking the response. Do an actual server call.
                     */
                    String url = getUrl(context);
                    PlayHaven.v("Request(%s) %s: %s", PlayHavenRequest.this.getClass().getSimpleName(), restMethod, url);

                    // Add the gzip Accept-Encoding header
                    HttpHeaders requestHeaders = getHeaders();
                    requestHeaders.setAcceptEncoding(ContentCodingType.GZIP);
                    requestHeaders.setAccept(Collections.singletonList(new MediaType("application", "json")));
                    /**
                     * Bug in Jelly Bean when used with KeepAlive
                     * We could apihack for Jelly Bean specifically, but server team prefers consistent headers for debugging
                     *
                     * http://code.google.com/p/google-http-java-client/issues/detail?id=116
                     * http://stackoverflow.com/questions/13182519/spring-rest-template-usage-causes-eofexception
                     */
//                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN && Build.VERSION.SDK_INT <= Build.VERSION_CODES.JELLY_BEAN_MR2)
//                    {
                    requestHeaders.set("Connection", "Close");
//                    }

                    // Create our REST handler
                    RestTemplate rest = new RestTemplate();
                    rest.setErrorHandler(new ServerErrorHandler());

                    // Capture the JSON for signature verification
                    final Charset UTF8 = PlayHaven.getUTF8();
                    // https://code.google.com/p/android/issues/detail?id=42769
                    final ArrayList<Charset> availableCharset = new ArrayList<Charset>();
                    availableCharset.add(UTF8);
                    rest.getMessageConverters().add(new StringHttpMessageConverter(UTF8, availableCharset));

                    ResponseEntity<String> entity = null;

                    switch (restMethod) {
                        case POST:
                            SharedPreferences pref = PlayHaven.getPreferences(context);
                            String apiServer = getString(pref, APIServer) + context.getResources().getString(getApiPath(context));
                            url = url.replace(apiServer, "");
                            if (url.startsWith("?") && url.length() > 1)
                                url = url.substring(1);

                            requestHeaders.setContentType(new MediaType("application", "x-www-form-urlencoded"));
                            entity = rest.exchange(apiServer, restMethod, new HttpEntity<String>(url, requestHeaders), String.class);
                            break;
                        default:
                            entity = rest.exchange(url, restMethod, new HttpEntity<Object>(requestHeaders), String.class);
                            break;
                    }

                    String json = entity.getBody();

                    List<String> digests = entity.getHeaders().get("X-PH-DIGEST");
                    String digest = (digests == null || digests.size() == 0) ? null : digests.get(0);

                    validateSignatures(context, digest, json);

                    HttpStatus statusCode = entity.getStatusCode();
                    PlayHaven.v("Response (%s): %s",
                            statusCode,
                            json
                    );

                    serverSuccess(context);
                    handleResponse(context, json);
                }catch(NoIdentifierException e){
                    PlayHaven.w(e.getMessage());
                    handleResponse(context, e);
                }catch(PlayHavenException e){
                    PlayHaven.e(e, "Error calling server");
                    handleResponse(context, e);
                }catch(Exception e2){
                    PlayHaven.e(e2, "Error calling server");
                    handleResponse(context, new PlayHavenException(e2.getMessage()));
                }
            }
        }).start();
    }

    /**
     * @deprecated
     */
    protected void serverSuccess(Context context)
    {

    }

    public void setResponseHandler(RequestListener handler)
    {
        this.handler = handler;
    }

    public RequestListener getResponseHandler()
    {
        return handler;
    }

    protected void handleResponse(Context context, String json)
    {
        if(handler != null)
            handler.handleResponse(context, json);
    }

    protected void handleResponse(Context context, PlayHavenException e)
    {
        if(handler != null)
            handler.handleResponse(context, e);
    }

    /**
     * To actually call the server, but with a mock URL - return it here
     *
     * @param context of the request
     * @return the url to call
     * @throws PlayHavenException if there is a problem
     */
    public String getUrl(Context context) throws PlayHavenException {
        lastUrl = createUrl(context).build().encode().toUriString();
        return lastUrl;
    }

    /**
     * @return the url last returned from getUrl
     */
    public String getLastUrl()
    {
        return lastUrl;
    }

    /**
     * To pretend to call the server, and return a mock result - return the JSON result here
     * Note: This is used for testing
     *
     * @return json result
     */
    protected String getMockJsonResponse()
    {
        return null;
    }

    protected VendorCompat getCompat(Context context){return PlayHaven.getVendorCompat(context);}

    /**
     * Add a set of custom dimensions to the request.
     *
     * @param dimensions to add to this request.
     */
    public void addDimensions(Map<String,Object> dimensions)
    {
        if(customDimensions == null)
            customDimensions = new JSONObject();

        customDimensions.putAll(dimensions);
    }

    /**
     * Add a single custom dimension to the request.
     *
     * @param name of the custom dimension
     * @param value of the custom dimension, or null to remove it
     */
    public void addDimension(String name, Object value)
    {
        if(customDimensions == null)
            customDimensions = new JSONObject();

        customDimensions.put(name, value);
    }
}
