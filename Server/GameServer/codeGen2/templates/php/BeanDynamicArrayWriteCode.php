
            //Write codes of /*FIELD_NAME*/
            //
            $__num = count($/*FIELD_NAME*/,0);
            $__xv +=XByteArray::WriteDynamicArrayLength($__dst,$__num);
            for($i=0;$i<$__num;$i++)
            {
                 $__xv +=$/*FIELD_NAME*/[$i]->ToBuffer($__dst);
            }
