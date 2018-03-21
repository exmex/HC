
package com.tencent.sdk.youai;


/**
 * 
 * @author luopeng (luopeng@staff.sina.com.cn)
 */
public class TencentException extends Exception {

	private static final long serialVersionUID = 475022994858770424L;
	private int statusCode = -1;
	
    public TencentException(String msg) {
        super(msg);
    }

    public TencentException(Exception cause) {
        super(cause);
    }

    public TencentException(String msg, int statusCode) {
        super(msg);
        this.statusCode = statusCode;
    }

    public TencentException(String msg, Exception cause) {
        super(msg, cause);
    }

    public TencentException(String msg, Exception cause, int statusCode) {
        super(msg, cause);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return this.statusCode;
    }
    
    
	public TencentException() {
		super(); 
	}

	public TencentException(String detailMessage, Throwable throwable) {
		super(detailMessage, throwable);
	}

	public TencentException(Throwable throwable) {
		super(throwable);
	}

	public TencentException(int statusCode) {
		super();
		this.statusCode = statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
	
	
	/*304 Not Modified: 没有数据返回.
	400 Bad Request: 请求数据不合法，或�?超过请求频率限制. 详细的错误代码如下：
	40028:内部接口错误(如果有详细的错误信息，会给出更为详细的错误提�?
	40033:source_user或�?target_user用户不存�?	40031:调用的微博不存在
	40036:调用的微博不是当前用户发布的微博
	40034:不能转发自己的微�?	40038:不合法的微博
	40037:不合法的评论
	40015:该条评论不是当前登录用户发布的评�?	40017:不能给不是你粉丝的人发私�?	40019:不合法的私信
	40021:不是属于你的私信
	40022:source参数(appkey)缺失
	40007:格式不支持，仅仅支持XML或JSON格式
	40009:图片错误，请确保使用multipart上传了图�?	40011:私信发布超过上限
	40012:内容为空
	40016:微博id为空
	40018:ids参数为空
	40020:评论ID为空
	40023:用户不存�?	40024:ids过多，请参�?API文档
	40025:不能发布相同的微�?	40026:请传递正确的目标用户uid或�?screen name
	40045:不支持的图片类型,支持的图片类型有JPG,GIF,PNG
	40008:图片大小错误，上传的图片大小上限�?M
	40001:参数错误，请参�?API文档
	40002:不是对象�?��者，没有操作权限
	40010:私信不存�?	40013:微博太长，请确认不超�?40个字�?	40039:地理信息输入错误
	40040:IP限制，不能请求该资源
	40041:uid参数为空
	40042:token参数为空
	40043:domain参数错误
	40044:appkey参数缺失
	40029:verifier错误
	40027:标签参数为空
	40032:列表名太长，请确保输入的文本不超�?0个字�?	40030:列表描述太长，请确保输入的文本不超过70个字�?	40035:列表不存�?	40053:权限不足，只有创建�?有相关权�?	40054:参数错误，请参�?API文档
	40059: 插入失败，记录已存在
	40060：数据库错误，请联系系统管理�?	40061：列表名冲突
	40062：id列表太长�?	40063：urls是空�?	40064：urls太多�?	40065：ip是空�?	40066：url是空�?	40067：trend_name是空�?	40068：trend_id是空�?	40069：userid是空�?	40070：第三方应用访问api接口权限受限�?	40071：关系错误，user_id必须是你关注的用�?	40072：授权关系已经被删除
	40073：目前不支持私有分组
	40074：创建list失败
	40075：需要系统管理员的权�?	40076：含有非法词
	40084：提醒失败，�?��权限
	40082：无效分�?
	40083：无效状态码
	40084：目前只支持私有分组
	401 Not Authorized: 没有进行身份验证.
	40101 version_rejected Oauth版本号错�?	40102 parameter_absent Oauth缺少必要的参�?	40103 parameter_rejected Oauth参数被拒�?	40104 timestamp_refused Oauth时间戳不正确
	40105 nonce_used Oauth nonce参数已经被使�?	40106 signature_method_rejected Oauth签名算法不支�?	40107 signature_invalid Oauth签名值不合法
	40108 consumer_key_unknown! Oauth consumer_key不存�?	40109 consumer_key_refused! Oauth consumer_key不合�?	40110 token_used! Oauth Token已经被使�?	40111 Oauth Error: token_expired! Oauth Token已经过期
	40112 token_revoked! Oauth Token不合�?	40113 token_rejected! Oauth Token不合�?	40114 verifier_fail! Oauth Pin码认证失�?	402 Not Start mblog: 没有�??微博
	403 Forbidden: 没有权限访问对应的资�?
	40301 too many lists, see doc for more info 已拥有列表上�?	40302 auth faild 认证失败
	40303 already followed 已经关注此用�?	40304 Social graph updates out of rate limit 发布微博超过上限
	40305 update comment out of rate 发布评论超过上限
	40306 Username and pwd auth out of rate limit 用户名密码认证超过请求限�?	40307 HTTP METHOD is not suported for this request 请求的HTTP METHOD不支�?	40308 Update weibo out of rate limit 发布微博超过上限
	40309 password error 密码不正�?	40314 permission denied! Need a high level appkey 该资源需要appkey拥有更高级的授权
	404 Not Found: 请求的资源不存在.
	500 Internal Server Error: 服务器内部错�?
	502 Bad Gateway: 微博接口API关闭或正在升�?.
	503 Service Unavailable: 服务端资源不可用.*/
}
