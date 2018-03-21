
            //Write codes of /*FIELD_NAME*/
            //
            __xv +=XProtoMarshaling.WriteDynamicArrayLength(__dst,/*FIELD_NAME*/.length);
            for(i=0;i</*FIELD_NAME*/.length;i++)
            {
                __dst./*WRITE_METHOD*/(/*FIELD_NAME*/[i]);
                __xv +=/*SIZE*/;
            }
