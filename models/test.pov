// Persistence of Vision Ray Tracer Scene Description File
// File: mesh2.pov
// Vers: 3.5
// Desc: mesh2 demonstration scene
// Date: November/December 2001
// Auth: Christoph Hormann

// -w320 -h240
// -w512 -h384 +a0.3
#version 3.6;
global_settings { 
  assumed_gamma 1.0
}

#include "colors.inc"  
#include "glass.inc" 

/*
light_source {
  <5, 5, -3>*10000
  rgb 0.3
} 


light_source {
  <-5, 5, 5>*10000
  rgb 0.3
}
  */

light_source {
    <-19, 200, 16> color White
    area_light <8, 0, 0>, <0, 8, 0>, 17, 17
    adaptive 0
    jitter

    spotlight
    point_at <-19, 0, 16>
    tightness 0
    radius 0
    falloff 11
}

camera {
  perspective
  location    <-6.5, -2.5, -3>
  direction <0.8, 0.5, 1.5>
  up<0,-1,0>

  //up          <0,-1,0>
  //right       <-1,0,0>
  rotate <0,-14, 0>
  translate<0, 0, -1>//-1.215375, -0.038000, 0.636464>
  //look_at     <-9, 0, 16>
  //angle       20
}

background {
  color rgb < 1, 1, 1 >
} 

/*
plane {
  y, -20

  texture {
    pigment {SummerSky}
    finish {
      diffuse 0.6
      ambient 0.1
      specular 0.2
      //reflection {
      //  0.2, 0.6
      //  fresnel on
      //}
      conserve_energy
    }
  }
}  
  */     
  // sun ---------------------------------------------------------------
light_source{<1500,2500,-2500> color rgb<1,1,1> }
// sky ---------------------------------------------------------------
/*plane{<0,1,0>,1 hollow  // 
      
        texture{ pigment {color rgb<0.1,0.3,0.75>*0.7}
                 #if (version = 3.7 )  finish {emission 1 diffuse 0}
                 #else                 finish { ambient 1 diffuse 0}
                 #end 
               } // end texture 1

        texture{ pigment{ bozo turbulence 0.75
                          octaves 6  omega 0.7 lambda 2 
                          color_map {
                          [0.0  color rgb <0.95, 0.95, 0.95> ]
                          [0.05  color rgb <1, 1, 1>*1.25 ]
                          [0.15 color rgb <0.85, 0.85, 0.85> ]
                          [0.55 color rgbt <1, 1, 1, 1>*1 ]
                          [1.0 color rgbt <1, 1, 1, 1>*1 ]
                          } // end color_map 
                         translate< 3, 0,-1>
                         scale <0.3, 0.4, 0.2>*3
                        } // end pigment
                 #if (version = 3.7 )  finish {emission 1 diffuse 0}
                 #else                 finish { ambient 1 diffuse 0}
                 #end 
               } // end texture 2
       scale 10000
     } //-------------------------------------------------------------
*/ 
#declare Mesh_TextureA=
  texture{
    pigment{
      uv_mapping
      
      spiral2 8
      color_map {
        [0.5 color rgb <0.2,0,0> ]
        [0.5 color rgb 1 ]
      }
      scale 0.8
    }
    finish {
      specular 0.3
      roughness 0.01
    }
  }


#declare Mesh_TextureB=
  texture{
    pigment{
      uv_mapping
      
      spiral2 8
      color_map {
        [0.5 color rgb 1 ]
        [0.5 color rgb <0,0,1> ]
      }
      scale 0.8
    }
    finish {
      specular 0.3
      roughness 0.01
    }
  }

// ------- Mesh B - with normal vectors -------

#declare frame_id = clock; 
#declare frame_id_str = str( frame_id, -5, 0 );

#declare frame_id_str_3 = str( frame_id, -3, 0 );

#declare meshname = concat( frame_id_str_3, ".mesh2" );     
#declare meshfilename = concat( "", meshname );
#declare Mesh_B=
#include meshfilename

object {
  Mesh_B
  hollow    
    material {
      texture {
        pigment { color Col_Glass_Clear }
        finish { F_Glass6 }                          
        pigment{ color rgbf <1, 1, 0.5, 0.5> }
      }
    
    }    

  photons {
    target
    reflection on
    refraction on
    collect off
  }    
  no_shadow
}   
