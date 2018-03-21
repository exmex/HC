
            //Read codes of /*FIELD_NAME*/
            //
            for($i=0;$i</*ARRAY_LENGTH*/;$i++)
            {
               $__xvtmp_/*FIELD_NAME*/ = new /*TYPE_NAME*/();
               if($__src->getBytesAvailable()>=$__xvtmp_/*FIELD_NAME*/->Size())
               {
                   $__xvBeanSize=$__xvtmp_/*FIELD_NAME*/->FromBuffer($__src);
                   if($__xvBeanSize<=0)
                   { 
                   		return 0;
                   }
                   $__xv +=$__xvBeanSize;
                   $this->/*FIELD_NAME*/[$i] = $__xvtmp_/*FIELD_NAME*/;
               } 
               else 
               {
                   return 0;               
               } 
            }
