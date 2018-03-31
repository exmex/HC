using Network;
using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using Network.Packets;

namespace Network.Tests
{
    [TestFixture]
    public class TestClass
    {
        public static byte[] GetTestData(string fileName)
        {
            return File.ReadAllBytes(Path.Combine(TestContext.CurrentContext.TestDirectory, @"TestData\" + fileName));
        }

        public static bool IsSame(byte[] arr1, byte[] arr2)
        {
            if (arr1.Length != arr2.Length)
                return false;
            for (var index = 0; index < arr1.Length; index++)
            {
                var b = arr1[index];
                var b2 = arr2[index];
                if (b != b2)
                {
                    TestContext.WriteLine("Diff at index {0}: {1} != {2}", index, b, b2);
                    return false;
                }
            }

            return true;
        }

        [Test]
        public void TestLoginParsing()
        {
            var packets = XProtoPacket.ReadPackets(GetTestData("0login"));
            Assert.AreEqual(1, packets.Count);
            
            var packet = packets[0];
            Assert.AreEqual(XProtoPackets.SendProtoBuff, (int)packet.Id);
            
            var protoBufPacket = new ProtoBuffPacket(packet.Payload);
            Assert.AreEqual(3, protoBufPacket.Messages.Count);

            var protoBufMessage = protoBufPacket.Messages[0];
            Assert.IsAssignableFrom(typeof(Up_Login), protoBufMessage);
            
            TestContext.WriteLine((string)(new ProtoBuffPacket(packets[0].Payload).Messages[0]).ToString());
        }
    }
}
