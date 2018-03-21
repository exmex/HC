
            //Read codes of /*FIELD_NAME*/
            //
            for($i=0;$i</*ARRAY_LENGTH*/;$i++)
            {
                 $__/*FIELD_NAME*/_szSize= new XInteger();
                 $__xvstrtemp =XByteArray::/*READ_METHOD*/($__src,$__/*FIELD_NAME*/_szSize);
                 if($__/*FIELD_NAME*/_szSize->_value<=0) return 0;
                 $__xv +=$__/*FIELD_NAME*/_szSize->_value;
                 $this->/*FIELD_NAME*/[$i] = $__xvstrtemp;
            }
