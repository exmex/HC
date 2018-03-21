                if($__src->getBytesAvailable()>=/*ARRAY_LENGTH*/)
                {
                    $this->/*FIELD_NAME*/ = $__src->readBinary(/*ARRAY_LENGTH*/);
                    $__xv +=/*ARRAY_LENGTH*/;
                }
                else 
                {
                    return 0;
                }