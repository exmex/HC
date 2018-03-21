
            //Read codes of /*FIELD_NAME*/
            //
            for(i=0;i</*ARRAY_LENGTH*/;i++)
            {
               var __xvtmp_/*FIELD_NAME*/:/*TYPE_NAME*/ = new /*TYPE_NAME*/();
               if(__src.bytesAvailable>=__xvtmp_/*FIELD_NAME*/.Size())
               {
                   __xvBeanSize=__xvtmp_/*FIELD_NAME*/.FromBuffer(__src);
                   if(__xvBeanSize<=0) return 0;
                   __xv +=__xvBeanSize;
                   /*FIELD_NAME*/[i] = __xvtmp_/*FIELD_NAME*/;
               } 
               else 
               {
                   return 0;               } 
            }
