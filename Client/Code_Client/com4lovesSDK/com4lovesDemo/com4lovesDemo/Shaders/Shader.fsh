//
//  Shader.fsh
//  com4lovesDemo
//
//  Created by fish on 13-8-22.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
