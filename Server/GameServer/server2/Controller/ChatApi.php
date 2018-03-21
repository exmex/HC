<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/ChatModule.php");

function ChatApi($userId, Up_Chat $pPacket)
{
    Logger::getLogger()->debug("ChatApi");
    $reply = new Down_ChatReply();
    $fresh = $pPacket->getFresh();
    if (isset($fresh)) {
    	$freshReply = ChatFreshApi($userId, $fresh);
    	if (isset($freshReply)) {
    		$reply->setFresh($freshReply);
    	}
    }
    $say = $pPacket->getSay();
    if (isset($say)) {
        $sayReply = SayApi($userId, $say);
        if (isset($sayReply)) {
            $reply->setSay($sayReply);
        }
    }

    $fetch = $pPacket->getFetch();
    if (isset($fetch)) {
        $fetchReply = ChatFetchApi($userId, $fetch);
        if (isset($fetchReply)) {
            $reply->setFetch($fetchReply);
        }
    }
    Logger::getLogger()->debug("ChatReplyApi");
    return $reply;
}
function SayApi($userId, Up_ChatSay $pPacket)
{
    $reply = new Down_ChatSay();

    $channel = $pPacket->getChannel();
    if (empty($channel))
        $channel = Down_ChatChannel::world_channel;
    $targetId = $pPacket->getTargetId();
    $type = $pPacket->getContentType();
    $content = $pPacket->getContent();
    $accesory = $pPacket->getAccessory();
	
    $ret = ChatModule::chat($userId, $targetId, $channel, $type, $content, $accesory);
    if ($ret) {
        $reply->setResult(Down_Result::success);
        $reply->setChannel($channel);
        $contents = ChatModule::refresh($userId, $channel);
        if (isset($contents)) {
            foreach ($contents as $content) {
                $reply->appendContents($content);
            }
        }
    } else {
        $reply->setResult(Down_Result::fail);
    }
    return $reply;
}

function ChatFreshApi($userId, Up_ChatFresh $pPacket)
{
	$channel = $pPacket->getChannel();
	if (empty($channel))
		$channel = Down_ChatChannel::world_channel;
	$reply = new Down_ChatFresh();
	$reply->setChannel($channel);
	$contents = ChatModule::refresh($userId, $channel);
	if (isset($contents)) {
		foreach ($contents as $content) {
			$reply->appendContents($content);
		}
	}
	return $reply;
}
function ChatFetchApi($userId, Up_ChatFetch $pPacket)
{
    $channel = $pPacket->getChannel();
    $chatID = $pPacket->getChatId();
    if (!$channel) {
        $channel = Down_ChatChannel::world_channel;
    }
    $reply = ChatModule::fetch($userId, $channel, $chatID);
    return $reply;
}