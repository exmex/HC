package com.taobao.sdk.youai.api;

import com.taobao.sdk.youai.Oauth2AccessToken;
import com.taobao.sdk.youai.TaobaoParameters;
import com.taobao.sdk.youai.net.AsyncTaobaoRunner;
import com.taobao.sdk.youai.net.RequestListener;


public class TaobaoAPI {
	 /**
     * 访问淘宝服务接口的地址
     */
	public static final String API_SERVER = "https://api.douban.com/v2";
	/**
	 * post请求方式
	 */
	public static final String HTTPMETHOD_POST = "POST";
	/**
	 * get请求方式
	 */
	public static final String HTTPMETHOD_GET = "GET";
	private Oauth2AccessToken oAuth2accessToken;
	private String accessToken;
	/**
	 * 构造函数，使用各个API接口提供的服务前必须先获取Oauth2AccessToken
	 * @param accesssToken Oauth2AccessToken
	 */
	public TaobaoAPI(Oauth2AccessToken oauth2AccessToken){
	    this.oAuth2accessToken=oauth2AccessToken;
	    if(oAuth2accessToken!=null){
	        accessToken=oAuth2accessToken.getToken();
	    }
	   
	}
	public enum FEATURE {
		ALL, ORIGINAL, PICTURE, VIDEO, MUSICE
	}

	public enum SRC_FILTER {
		ALL, WEIBO, WEIQUN
	}

	public enum TYPE_FILTER {
		ALL, ORIGAL
	}

	public enum AUTHOR_FILTER {
		ALL, ATTENTIONS, STRANGER
	}

	public enum TYPE {
		STATUSES, COMMENTS, MESSAGE
	}

	public enum EMOTION_TYPE {
		FACE, ANI, CARTOON
	}

	public enum LANGUAGE {
		cnname, twname
	}

	public enum SCHOOL_TYPE {
		COLLEGE, SENIOR, TECHNICAL, JUNIOR, PRIMARY
	}

	public enum CAPITAL {
		A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
	}

	public enum FRIEND_TYPE {
		ATTENTIONS, FELLOWS
	}

	public enum RANGE {
		ATTENTIONS, ATTENTION_TAGS, ALL
	}

	public enum USER_CATEGORY {
		DEFAULT, ent, hk_famous, model, cooking, sports, finance, tech, singer, writer, moderator, medium, stockplayer
	}

	public enum STATUSES_TYPE {
		ENTERTAINMENT, FUNNY, BEAUTY, VIDEO, CONSTELLATION, LOVELY, FASHION, CARS, CATE, MUSIC
	}

	public enum COUNT_TYPE {
	    /**
	     * 新微博数
	     */
		STATUS, 
		/**
		 * 新粉丝数
		 */
		FOLLOWER, 
		/**
		 * 新评论数
		 */
		CMT, 
		/**
		 * 新私信数
		 */
		DM, 
		/**
		 * 新提及我的微博数
		 */
		MENTION_STATUS, 
		/**
		 * 新提及我的评论数
		 */
		MENTION_CMT
	}
	/**
	 * 分类
	 * @author xiaowei6@staff.sina.com.cn
	 *
	 */
	public enum SORT {
	    Oauth2AccessToken, 
	    SORT_AROUND
	}

	public enum SORT2 {
		SORT_BY_TIME, SORT_BY_HOT
	}
	
	public enum SORT3 {
		SORT_BY_TIME, SORT_BY_DISTENCE
	}
	
	public enum COMMENTS_TYPE {
		NONE, CUR_STATUSES, ORIGAL_STATUSES, BOTH
	}
	
	protected void request( final String url, final TaobaoParameters params,
			final String httpMethod,RequestListener listener) {
		params.add("access_token", accessToken);
		AsyncTaobaoRunner.request(url, params, httpMethod, listener);
	}
}
