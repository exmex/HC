
            //Read codes of /*FIELD_NAME*/
            //
            for(i=0;i</*ARRAY_LENGTH*/;i++)
            {
                 var __/*FIELD_NAME*/_szSize:XInteger = new XInteger();
                 var __xv_/*FIELD_NAME*/_temp:String =XProtoMarshaling./*READ_METHOD*/(__src,__/*FIELD_NAME*/_szSize);
                 if(__/*FIELD_NAME*/_szSize._value<=0) return 0;
                 __xv +=__/*FIELD_NAME*/_szSize._value;
                 /*FIELD_NAME*/[i] = __xv_/*FIELD_NAME*/_temp;
            }
