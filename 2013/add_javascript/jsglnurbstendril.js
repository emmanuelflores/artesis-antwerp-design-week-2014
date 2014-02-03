// create our window with a depth buffer and full scene anti aliasing (if supported)
var window = new JitterObject("jit.window","tender");
window.depthbuffer = 1; 
window.fsaa = 1;

// create our render object for our window
var render = new JitterObject("jit.gl.render","tender");
render.camera = [3,3,3];
render.up = [0, 0, 1];

// create our handle object for our window
var handle = new JitterObject("jit.gl.handle","tender");
handle.radius = 2;
handle.auto_rotate = 1;
handle.inherit_transform = 1;

// create our nurbs object
var nurbs = new JitterObject("jit.gl.nurbs","tender");
nurbs.color= [0.6,0.9,0.3,1.];
nurbs.lighting_enable = 1;
nurbs.smooth_shading = 1;
nurbs.closed = [0,1];
nurbs.automatic = 0;
nurbs.dim = [48,12];
nurbs.cull_face = 1;
//nurbs.poly_mode = [1,1];
nurbs.order = [2,2];


// create our matrix object
var mat_a = new JitterMatrix(1,"float32",1);
var mat_b = new JitterMatrix(1,"float32",1);
var mat_c = new JitterMatrix(1,"float32",1);
var mat_d = new JitterMatrix(1,"float32",1);
var mat_x = new JitterMatrix(1,"float32",16);
var mat_y = new JitterMatrix(1,"float32",16);
var mat_r = new JitterMatrix(1,"float32",16);
var mat_out = new JitterMatrix(3,"float32",16,4);

// create our expression object
var expr_x = new JitterObject("jit.expr");
var expr_y = new JitterObject("jit.expr");
var expr_r = new JitterObject("jit.expr");
var expr_out = new JitterObject("jit.expr");
//expr_x.verbose = 1;

// x and y offset are noise
expr_x.expr = "in[2]*(norm[0])*(noise.gradient(norm[0]*in[0],in[1],@seed 777)-0.5)";
expr_y.expr = "in[2]*(norm[0])*(noise.gradient(norm[0]*in[0],in[1],@seed 329)-0.5)";
// r is tapered noise
//expr_r.expr = "0.2*sin(norm[0]*HALFPI)*(1.-norm[0])*(noise.gradient(norm[0]*in[0],in[1],@seed 219))";
expr_r.expr = "in[2]*(1.-norm[0]*norm[0])*(noise.gradient(norm[0]*in[0],in[1],@seed 219)+0.2)";

expr_out.expr = [ 
	"in[0]+in[2]*cos((cell[1]/dim[1])*TWOPI)", // x is center + r*cos(theta)
	"in[1]+in[2]*sin((cell[1]/dim[1])*TWOPI)", // y is center + r*sin(theta)
	"norm[0]*2"]; // z is just along z axis

var vphase = 0.;
var vfreq = 3.;
var vspread = 5.;
var vwidth = 0.1;
var vcount = 10;

var xpos = new Array();
var ypos = new Array();
var zpos = new Array();
var xrot = new Array();
var yrot = new Array();
var zrot = new Array();
var green = new Array();
var awidth = new Array();
var afreq = new Array();
var aspread = new Array();

count(10);
	
function phase(v)
{
	vphase = v;
}

function freq(v)
{
	vfreq = v;
}

function spread(v)
{
	vspread = v;
}

function width(v)
{
	vwidth = v;
}

function dim(x,y)
{
	nurbs.dim = [x,y];
}

function count(v)
{
	vcount = Math.max(1,v);
	for (var i=0;i<vcount;i++) {
		xpos[i] = Math.random()*2-1.;
		ypos[i] = Math.random()*2-1.;
		zpos[i] = Math.random()*2-1.;
		xrot[i] = Math.random()*2-1.;
		yrot[i] = Math.random()*2-1.;
		zrot[i] = Math.random()*2-1.;
		green[i] = Math.random()*2-1.;
		awidth[i] = Math.random()+0.5;
		afreq[i] = Math.random()+0.5;
		aspread[i] = Math.random()+0.5;
	}
}


function bang()
{
	render.position = handle.position;
	render.rotate = handle.rotate;

	render.erase_color = [1,1,1,1];
	render.erase();
	render

	for (var i=0;i<vcount;i++) {
		mat_a.setall(vfreq+afreq[i]);
		mat_b.setall(vphase+i*1.37);	
		mat_c.setall(vspread*aspread[i]);
		mat_d.setall(vwidth*awidth[i]);

		// evaluate expresions
		expr_x.matrixcalc([mat_a,mat_b,mat_c],mat_x);
		expr_y.matrixcalc([mat_a,mat_b,mat_c],mat_y);
		expr_r.matrixcalc([mat_a,mat_b,mat_d],mat_r);

		// extrude along axis
		expr_out.matrixcalc([mat_x,mat_y,mat_r],mat_out);

		// set as ctl points for nurbs surface
		nurbs.ctlmatrix(mat_out.name);

		// rotate nurbs to given position
		//nurbs.position = [xpos[i],ypos[i],0.];
		nurbs.color = [0.8,0.4+green[i]*0.05,0.1];
		nurbs.rotate = [720*green[i],xrot[i],yrot[i],zrot[i]]

		// draw surface
		nurbs.draw();	
	}
		
	render.drawswap(); //combo of draw clients and swap
	//outlet(0,"jit_matrix",mat_out.name);
}

