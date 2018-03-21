
            //Read codes of /*FIELD_NAME*/
            //
            $__/*FIELD_NAME*/_arrlen = new XInteger();
            $__xv +=XByteArray::ReadDynamicArrayLength($__src,$__/*FIELD_NAME*/_arrlen);
            if($__/*FIELD_NAME*/_arrlen->_value<0)
            {
                return 0;
            }
            $this->/*FIELD_NAME*/=array();
            for($i=0;$i<$__/*FIELD_NAME*/_arrlen->_value;$i++)
            {
                if($__src->getBytesAvailable()>=/*SIZE*/)
                {
                    array_push($this->/*FIELD_NAME*/,$__src->/*READ_METHOD*/());
                    $__xv +=/*SIZE*/;
                }
                else 
                {
                    return 0;
                }
            }
