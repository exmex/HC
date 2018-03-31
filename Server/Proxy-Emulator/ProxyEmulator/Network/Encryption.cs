using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Network
{
    public static class Encryption
    {
        public static int BlockSize = 128;
        public static byte[] Iv = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
        public static byte[] Key = new byte[9];
        public static CipherMode Cipher = CipherMode.CBC;

        /// <summary>
        /// The RC4 Key
        /// Default: goota123|}{
        /// </summary>
        public static byte[] RcKey = {0x67, 0x6F, 0x74, 0x61, 0x31, 0x32, 0x33, 0x7C, 0x7D, 0x7B};

        /// <summary>
        /// The key prefix
        /// Default: darogn
        /// </summary>
        public static string KeyPrefix = "darogn";

        public static bool OpenRc4Encrypt = false;

        private static string NormalizeKey(string key)
        {
            if (key.Length < 10)
            {
                var length = key.Length;
                key = KeyPrefix + key;
                for (var i = 0; i < 10 - length; i++)
                    key += "\0";
            }
            else if (key.Length > 9)
                key = KeyPrefix + key.Substring(0, 10);

            return key;
        }

        public static byte[] Encrypt_RC4(byte[] data)
        {
            int a, i, j;
            int tmp;

            var key = new int[256];
            var box = new int[256];
            var cipher = new byte[data.Length];

            for (i = 0; i < 256; i++)
            {
                key[i] = RcKey[i % RcKey.Length];
                box[i] = i;
            }
            for (j = i = 0; i < 256; i++)
            {
                j = (j + box[i] + key[i]) % 256;
                tmp = box[i];
                box[i] = box[j];
                box[j] = tmp;
            }
            for (a = j = i = 0; i < data.Length; i++)
            {
                a++;
                a %= 256;
                j += box[a];
                j %= 256;
                tmp = box[a];
                box[a] = box[j];
                box[j] = tmp;
                var k = box[((box[a] + box[j]) % 256)];
                cipher[i] = (byte) (data[i] ^ k);
            }
            return cipher;
        }

        public static byte[] Decrypt(byte[] data, string key)
        {
            if (OpenRc4Encrypt)
                data = Encrypt_RC4(data);
            key = NormalizeKey(key);

            using (var rj = new RijndaelManaged())
            {
                rj.Padding = PaddingMode.None;
                rj.Mode = CipherMode.CBC;

                rj.KeySize = 128;
                rj.BlockSize = 128;
                rj.Key = Encoding.Default.GetBytes(key);
                rj.IV = new byte[16];
                using (var ms = new MemoryStream())
                {
                    using (var cs = new CryptoStream(ms, rj.CreateDecryptor(rj.Key, rj.IV), CryptoStreamMode.Write))
                    {
                        cs.Write(data, 0, data.Length);
                        cs.Close();
                        return ms.ToArray();
                    }
                }
            }
        }

        public static byte[] Encrypt(byte[] data, string key)
        {
            key = NormalizeKey(key);

            using (var rj = new RijndaelManaged())
            {
                rj.Padding = PaddingMode.None;
                rj.Mode = CipherMode.CBC;

                rj.KeySize = 128;
                rj.BlockSize = 128;
                rj.Key = Encoding.Default.GetBytes(key);
                rj.IV = new byte[16];
                using (var ms = new MemoryStream())
                {
                    using (var cs = new CryptoStream(ms, rj.CreateEncryptor(rj.Key, rj.IV), CryptoStreamMode.Write))
                    {
                        cs.Write(data, 0, data.Length);
                        cs.Close();
                        data = ms.ToArray();
                    }
                }
            }

            if (OpenRc4Encrypt)
                data = Encrypt_RC4(data);

            return data;
        }
    }
}