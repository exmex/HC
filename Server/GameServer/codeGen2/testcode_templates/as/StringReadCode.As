
            //Read codes of /*FIELD_NAME*/
            //
            var __/*FIELD_NAME*/_szSize:XInteger = new XInteger();
            /*FIELD_NAME*/ =XProtoMarshaling./*READ_METHOD*/(__src,__/*FIELD_NAME*/_szSize);
            if(__/*FIELD_NAME*/_szSize._value<=0) 
                return 0;
            __xv +=__/*FIELD_NAME*/_szSize._value;
