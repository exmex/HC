
            //read codes of /*FIELD_NAME*/
            //
            $__/*FIELD_NAME*/_arrlen	= new XInteger();
            $__xv +=XByteArray::ReadDynamicArrayLength($__src,$__/*FIELD_NAME*/_arrlen);
            if($__/*FIELD_NAME*/_arrlen->_value<0)
            {
                return 0;
            }
            $this->/*FIELD_NAME*/ =array();
            for($i=0;$i<$__/*FIELD_NAME*/_arrlen->_value;$i++)
            {
                 $__/*FIELD_NAME*/_szSize = new XInteger();
                 $__xvstrtemp =XByteArray::/*READ_METHOD*/($__src,$__/*FIELD_NAME*/_szSize);
                 if($__/*FIELD_NAME*/_szSize->_value<=0) 
                 		return 0;
                 $__xv +=$__/*FIELD_NAME*/_szSize->_value;
                 array_push($this->/*FIELD_NAME*/,$__xvstrtemp);
            }
