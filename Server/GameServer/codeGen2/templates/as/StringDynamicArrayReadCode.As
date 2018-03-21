
            //read codes of /*FIELD_NAME*/
            //
            var __/*FIELD_NAME*/_arrlen:XInteger = new XInteger();
            __xv +=XProtoMarshaling.ReadDynamicArrayLength(__src,__/*FIELD_NAME*/_arrlen);
            if(__/*FIELD_NAME*/_arrlen._value<0)
            {
                return 0;
            }
            /*FIELD_NAME*/.length=0;
            for(i=0;i<__/*FIELD_NAME*/_arrlen._value;i++)
            {
                 var __/*FIELD_NAME*/_szSize:XInteger = new XInteger();
                 var __xv_/*FIELD_NAME*/_temp:String =XProtoMarshaling./*READ_METHOD*/(__src,__/*FIELD_NAME*/_szSize);
                 if(__/*FIELD_NAME*/_szSize._value<=0) return 0;
                 __xv +=__/*FIELD_NAME*/_szSize._value;
                 /*FIELD_NAME*/.push(__xv_/*FIELD_NAME*/_temp);
            }
