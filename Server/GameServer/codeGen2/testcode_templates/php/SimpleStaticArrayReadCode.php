
            //Read codes of /*FIELD_NAME*/
            //
            for($i=0;$i</*ARRAY_LENGTH*/;$i++)
            {
                if($__src->getBytesAvailable()>=/*SIZE*/)
                {
                    $this->/*FIELD_NAME*/[$i]= $__src->/*READ_METHOD*/();
                    $__xv +=/*SIZE*/;
                }
                else 
                {
                    return 0;
                }
            }
