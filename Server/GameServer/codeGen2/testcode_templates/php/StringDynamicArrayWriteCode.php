
            //Write codes of /*FIELD_NAME*/
            //
            $__num = count($/*FIELD_NAME*/);
            $__xv +=XByteArray::WriteDynamicArrayLength($__dst,$__num);
            for($i=0;$i<$__num;$i++)
            {
                $__xv +=XByteArray::/*WRITE_METHOD*/($__dst,$/*FIELD_NAME*/[$i]);
            }
