
            //Read codes of /*FIELD_NAME*/
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
                if(__src.bytesAvailable>=/*SIZE*/)
                {
                    /*FIELD_NAME*/.push(__src./*READ_METHOD*/());
                    __xv +=/*SIZE*/;
                }
                else 
                {
                    return 0;
                }
            }
