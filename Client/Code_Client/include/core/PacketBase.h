#pragma once
#include <string>
//
const int PacketHead = 12;

namespace google{namespace protobuf{class Message;}}
class PacketBase
{
//public:
//	PacketBase(::google::protobuf::Message*,int opcode);
//	~PacketBase(void);
//	int getOpcode();
//	const ::google::protobuf::Message *getMessage();
//	std::string getInfoString();
//protected:
//	::google::protobuf::Message * mProtoMessage;
//	int mOpcode;
//	std::string mInfoString;
//private:
//	PacketBase(){;}
//	friend class PacketManager;
//	friend class pressureTest;
//	/**should delete buffer after use*/
//	void* PackPacket(int &length,const ::google::protobuf::Message *);
//	//add by zhenhui for the zlib inflate 2014/3/12
//	static int InflateMemoryWithHint(unsigned char *in, unsigned int inLength, unsigned char **out, unsigned int outLengthHint);
//	static int InflateMemoryWithHint(unsigned char *in, unsigned int inLength, unsigned char **out, unsigned int *outLength, unsigned int outLenghtHint);
//	static void* PackPacket(int opcode,int &length,const std::string&);
//	/**should delete buffer after use*/
//	bool UnpackPacket(void*buffer , int length, char cCompress);
//	static std::string UnpackPacket(int opcode, void *buffer, int _length,char cCompress);
};



class PacketFactoryBase
{
public:
	virtual PacketBase* createPacket() = 0;
};


#define AUTO_REGISITER_PACKET_FACTORY(PROTOBUF_MESSAGE,OPCODE) \
class factory_for_##PROTOBUF_MESSAGE : public PacketFactoryBase{ \
public:virtual PacketBase* createPacket(){return new PacketBase(new PROTOBUF_MESSAGE,OPCODE);}}; \
	static factory_for_##PROTOBUF_MESSAGE * __factory_for_##PROTOBUF_MESSAGE = new factory_for_##PROTOBUF_MESSAGE; \
	static bool __ret_for_##PROTOBUF_MESSAGE = PacketManager::Get()->_registerPacketFactory(OPCODE, #PROTOBUF_MESSAGE,__factory_for_##PROTOBUF_MESSAGE);

// #define AUTO_REGISITER_PACKET_FACTORY(PACKETNAME) \
// 	static factory_##PACKETNAME * __factory_ = new factory_##PACKETNAME; \
//	PacketManager::Get()->_regisiterPacketFactory(__factory_->getOpcode(),__factory_);
