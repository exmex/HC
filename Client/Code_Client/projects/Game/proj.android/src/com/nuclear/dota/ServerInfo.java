package com.nuclear.dota;


public class ServerInfo {

	private String puid = "";//有爱id
	private int serverId = 0;//服务器id
	private String playerName = "";//角色名
	private String gameId = "";
	private String platform = "";
	
	private int playerId = 0;
	
	private int gameCoin1 = 0;//钻石
	private long gameCoin2 = 0;//贝里
	private int vipLv1 = 0; //vip等级
	private int playerLv1 = 0;//角色等级
	private Long lastLoginTime =0l;
	
	public String getPuid() {
		return puid;
	}
	public void setPuid(String puid) {
		this.puid = puid;
	}
	 
	public String getPlayerName() {
		return playerName;
	}
	public void setPlayerName(String playerName) {
		this.playerName = playerName;
	}
	 
	public Long getLastLoginTime() {
		return lastLoginTime;
	}
	public void setLastLoginTime(Long lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	public int getServerId() {
		return serverId;
	}
	public void setServerId(int serverId) {
		this.serverId = serverId;
	}
	 
	public String getGameId() {
		return gameId;
	}
	public void setGameId(String gameId) {
		this.gameId = gameId;
	}
	public int getGameCoin1() {
		return gameCoin1;
	}
	public void setGameCoin1(int gameCoin1) {
		this.gameCoin1 = gameCoin1;
	}
	public long getGameCoin2() {
		return gameCoin2;
	}
	public void setGameCoin2(long gameCoin2) {
		this.gameCoin2 = gameCoin2;
	}
	public int getVipLv1() {
		return vipLv1;
	}
	public void setVipLv1(int vipLv1) {
		this.vipLv1 = vipLv1;
	}
	public int getPlayerLv1() {
		return playerLv1;
	}
	public void setPlayerLv1(int playerLv1) {
		this.playerLv1 = playerLv1;
	}
	public String getPlatform() {
		return platform;
	}
	public void setPlatform(String platform) {
		this.platform = platform;
	}
	
	@Override
	public String toString() {
		return "ServerInfo [puid=" + puid + ", serverId=" + serverId
				+ ", playerName=" + playerName + ", gameId=" + gameId
				+ ", platform=" + platform + ", playerId=" + playerId
				+ ", gameCoin1=" + gameCoin1 + ", gameCoin2=" + gameCoin2
				+ ", vipLv1=" + vipLv1 + ", playerLv1=" + playerLv1
				+ ", lastLoginTime=" + lastLoginTime + "]";
	}
	public int getPlayerId() {
		return playerId;
	}
	public void setPlayerId(int playerId) {
		this.playerId = playerId;
	}
	
	
}
