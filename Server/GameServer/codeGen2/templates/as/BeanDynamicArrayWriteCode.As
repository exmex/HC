
            //Write codes of /*FIELD_NAME*/
            //
            __xv +=XProtoMarshaling.WriteDynamicArrayLength(__dst,/*FIELD_NAME*/.length);
            for(i=0;i</*FIELD_NAME*/.length;i++)
            {
                 __xv +=/*FIELD_NAME*/[i].ToBuffer(__dst);
            }
