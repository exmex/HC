
            //Read codes of /*FIELD_NAME*/
            //
            $__/*FIELD_NAME*/_arrlen = new XInteger();
            $__xv +=XByteArray::ReadDynamicArrayLength($__src,$__/*FIELD_NAME*/_arrlen);
            if($__/*FIELD_NAME*/_arrlen->_value<0)
            {
                return 0;
            }
            if($__src->getBytesAvailable()>=$__/*FIELD_NAME*/_arrlen->_value)
            {
                $this->/*FIELD_NAME*/=$__src->readBinary($__/*FIELD_NAME*/_arrlen->_value);
                $__xv +=$__/*FIELD_NAME*/_arrlen->_value;
            }
            else 
            {
                return 0;
            }
            
