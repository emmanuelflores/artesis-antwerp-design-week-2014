inlets=2;
var alwaysoutput=0;
var v=new Array();

v[0]=v[1]=0;

function msg_float(f)
{
    v[inlet]=f;
   //esto va a permitir que si no hay un nuevo input el valor se quede en el ultimo numero
    if((inlet==0)||alwaysoutput){
    bang();
    }
}

function list()
{
    //revision de los valores
    if(arguments.length>0)
    v[0]=arguments[0];
    if(arguments.length>1)
    v[1]=arguments[1];
    bang();
}

function bang()
{
    outlet(0,v[0]+v[1]);
}