
            //Write codes of /*FIELD_NAME*/
            //
            $__num = strlen($/*FIELD_NAME*/);
            $__xv +=XByteArray::WriteDynamicArrayLength($__dst,$__num);
            $__dst->writeBinary($/*FIELD_NAME*/,$__num);
            $__xv +=$__num;
            
