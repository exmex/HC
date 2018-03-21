
package com.nuclear.dota.platform.qihoo360.bean;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.TextUtils;

public class TokenInfo {

    private String accessToken; // Access Token值

    private Long expiresIn; // Access Token的有效期 以秒计

    private String qid; // 360用户ID

    private String account; // 登录账户名

    /**
     * {
     *   "data": {
     *     "qid": "xxxx",
     *     "account": "xxxx",
     *     "expires_in": "36000",
     *     "access_token": "xxxxxxxxxxxxxxxx"
     *   },
     *   "error_code": 0
     * }
     */
    public static TokenInfo parseJson(String jsonString) {
        TokenInfo tokenInfo = null;
        if (!TextUtils.isEmpty(jsonString)) {
            try {
                JSONObject dataJsonObj = new JSONObject(jsonString);

                String accessToken = dataJsonObj.optString("access_token");
                Long expiresIn = dataJsonObj.optLong("expires_in");
                String qid = dataJsonObj.optString("id");
                String account = dataJsonObj.optString("account");

                tokenInfo = new TokenInfo();
                tokenInfo.setAccessToken(accessToken);
                tokenInfo.setExpiresIn(expiresIn);
                tokenInfo.setQid(qid);
                tokenInfo.setAccount(account);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return tokenInfo;
    }

    public boolean isValid() {
        return !TextUtils.isEmpty(qid) && !TextUtils.isEmpty(accessToken);
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public Long getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(Long expiresIn) {
        this.expiresIn = expiresIn;
    }

    public String getQid() {
        return qid;
    }

    public void setQid(String qid) {
        this.qid = qid;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String toJsonString() {

        JSONObject obj = new JSONObject();
        try {
            obj.put("error_code", 0);

            JSONObject dataObj = new JSONObject();
            dataObj.put("access_token", accessToken);
            dataObj.put("expires_in", expiresIn);
            dataObj.put("qid", qid);
            dataObj.put("account", account);

            obj.put("content", dataObj);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return obj.toString();
    }

}
