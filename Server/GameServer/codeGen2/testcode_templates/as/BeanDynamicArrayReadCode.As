
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
               var __xvtmp_/*FIELD_NAME*/:/*TYPE_NAME*/ = new /*TYPE_NAME*/();
               {
                   __xvBeanSize =__xvtmp_/*FIELD_NAME*/.FromBuffer(__src);
                   if(__xvBeanSize<=0) return 0;
                   __xv +=__xvBeanSize;
                   /*FIELD_NAME*/.push(__xvtmp_/*FIELD_NAME*/);
               } 
            }
