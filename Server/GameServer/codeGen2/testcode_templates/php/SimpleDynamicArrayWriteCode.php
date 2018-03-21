
            //Write codes of /*FIELD_NAME*/
            //
            $__num = count($/*FIELD_NAME*/);
            $__xv +=XByteArray::WriteDynamicArrayLength($__dst,$__num);
            for($i=0;$i<$__num;$i++)
            {
                $__dst->/*WRITE_METHOD*/($/*FIELD_NAME*/[$i]);
                $__xv +=/*SIZE*/;
            }
