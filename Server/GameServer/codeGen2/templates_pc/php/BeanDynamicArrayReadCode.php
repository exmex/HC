
            //Read codes of /*FIELD_NAME*/
            //
            $__/*FIELD_NAME*/_arrlen = new XInteger();
            $__xv +=XByteArray::ReadDynamicArrayLength($__src,$__/*FIELD_NAME*/_arrlen);
            if($__/*FIELD_NAME*/_arrlen->_value<0)
            {
                return 0;
            }
            $this->/*FIELD_NAME*/ =array();
            for($i=0;$i<$__/*FIELD_NAME*/_arrlen->_value;$i++)
            {
               $__xvtmp_/*FIELD_NAME*/ = new /*TYPE_NAME*/();
               {
                   $__xvBeanSize =$__xvtmp_/*FIELD_NAME*/->FromBuffer($__src);
                   if($__xvBeanSize<=0) return 0;
                   $__xv +=$__xvBeanSize;
                   array_push($this->/*FIELD_NAME*/, $__xvtmp_/*FIELD_NAME*/);
               } 
            }
