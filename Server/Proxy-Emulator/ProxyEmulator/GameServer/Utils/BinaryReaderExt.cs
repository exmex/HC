using System.IO;
using System.Text;

namespace GameServer.Utils
{
    public class BinaryReaderExt : BinaryReader
    {
        public BinaryReaderExt(Stream stream)
            : base(stream, Encoding.Unicode)
        {
        }
	
        public BinaryReaderExt(Stream input, Encoding encoding) : base(input, encoding)
        {
        }
        
        public string ReadAscii()
        {
            var sb = new StringBuilder();
            byte val;
            do
            {
                val = ReadByte();
                sb.Append((char) val);
            } while (val > 0);
            return sb.ToString();
        }
    }
}