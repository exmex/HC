
package com.nuclear.dota.platform.qihoo360.bean;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.TextUtils;
import android.util.Log;

/**
 * QihooUserInfo，是360用户信息数据
 */
public class QihooUserInfo {

    private String qid;  // 360用户ID

    private String name; // 360用户名

    private String avatar; // 360用户头像url

    private String sex; // 360用户性别，仅在fields中包含时候才返回，返回值为：男，女或者未知。

    private String area; // 360用户地区，仅在fields中包含时候才返回。

    private String nick; // 360用户昵称，无值时候返回空。

    /***
     * 从返回的数据中解析出QihooUserInfo。 此处数据格式由支付SDK返回
     * 此处json示例：
     * {
     *   "error_code":0,
     *   "data":{
     *     "id":"13915949",
     *     "name":"yyyyyyyyyyyyy",
     *     "avatar":"http:\/\/u.qhimg.com\/qhimg\/quc\/48_48\/16\/03\/41\/1603414q9b57c.8e1eac.jpg?f=8689e00460eabb1e66277eb4232fde6f"
     *   }
     * }
     */
    public static QihooUserInfo parseJson(String jsonString) {
        QihooUserInfo userInfo = null;
        Log.d("QihooUserInfo", jsonString);
        if (!TextUtils.isEmpty(jsonString)) {
            try {
                JSONObject jsonObj = new JSONObject(jsonString);
                int errorCode = jsonObj.optInt("error_code");
                if (errorCode == 0) {

                    JSONObject dataJsonObj = jsonObj.getJSONObject("content");
                    // 必返回项
                    String qid = dataJsonObj.optString("id");
                    String name = dataJsonObj.optString("name");
                    String avatar = dataJsonObj.optString("avatar");

                    userInfo = new QihooUserInfo();
                    userInfo.setQid(qid);
                    userInfo.setName(name);
                    userInfo.setAvatar(avatar);

                    // 非必返回项
                    if (dataJsonObj.has("sex")) {
                        String sex = dataJsonObj.optString("sex");
                        userInfo.setSex(sex);
                    }

                    if (dataJsonObj.has("area")) {
                        String area = dataJsonObj.optString("area");
                        userInfo.setArea(area);
                    }

                    if (dataJsonObj.has("nick")) {
                        String nick = dataJsonObj.optString("nick");
                        userInfo.setNick(nick);
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        return userInfo;
    }

    public boolean isValid() {
        return !TextUtils.isEmpty(qid);
    }

    public String getQid() {
        return qid;
    }

    public void setQid(String qid) {
        this.qid = qid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getNick() {
        return nick;
    }

    public void setNick(String nick) {
        this.nick = nick;
    }

    public String toJsonString() {
        JSONObject obj = new JSONObject();
        try {
            obj.put("error_code", "0");

            JSONObject dataObj = new JSONObject();
            dataObj.put("qid", qid);
            dataObj.put("name", name);
            dataObj.put("avatar", avatar);
            dataObj.put("sex", sex);
            dataObj.put("area", area);
            dataObj.put("nick", nick);

            obj.put("content", dataObj);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return obj.toString();
    }

}
