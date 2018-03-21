
            //Read codes of /*FIELD_NAME*/
            //
            if(__src.bytesAvailable>=/*SIZE*/)
            {
                /*FIELD_NAME*/=__src./*READ_METHOD*/();
                __xv +=/*SIZE*/;
            }
            else
            {
                return 0;
            }
