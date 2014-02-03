import com.cycling74.max.*;
import com.cycling74.jitter.*;
import java.io.*;

public class MxTutorial46 extends MaxObject{
	int PARTICLE_COUNT = 1000;
	int ATTRACTOR_COUNT = 3;
	JitterObject noisegen;
	JitterObject attgen;
	JitterObject myexpr;
	JitterObject myexpr2;
	//matrices
	JitterMatrix particlemat;
	JitterMatrix velomat;
	JitterMatrix attmat;
	JitterMatrix distmat;
	JitterMatrix tempmat;
	JitterMatrix summat;
	JitterMatrix summat2;
	JitterMatrix scalarmat;
	JitterMatrix amat;
	
	float a = 0.001f;
	float d = 0.01f;
	//String perform_mode = "op";
	//String perform_mode;
	int perform_mode;
	//String draw_primitive = "points";
	String draw_primitive;
	
	public MxTutorial46(){
		declareInlets(new int[]{DataTypes.ALL});
		declareOutlets(new int[]{DataTypes.ALL});
		
		//perform_mode = new String("op");
		perform_mode = 0;
		draw_primitive = new String("points");
		
		//declare the noise objects
		//noisegen = new JitterObject("jit.noise","float32");
		noisegen = new JitterObject("jit.noise");
		noisegen.setAttr("dim", PARTICLE_COUNT);
		noisegen.setAttr("planecount",3);
		noisegen.setAttr("type", "float32");
		
		attgen = new JitterObject("jit.noise");
		attgen.setAttr("dim", ATTRACTOR_COUNT);
		attgen.setAttr("planecount", 3);
		attgen.setAttr("type", "float32");
		
		myexpr = new JitterObject("jit.expr");
		myexpr.setAttr("expr", "in[0].p[0]+in[0].p[1]+in[0].p[2]");
		// second expression: evaluate a+((b-c)*d/e)
		
		myexpr2 = new JitterObject("jit.expr");
		myexpr2.setAttr("expr", "in[0]+((in[1]-in[2])*in[3]/in[4])");
		
		//matrices declaration
		particlemat = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		velomat = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		attmat = new JitterMatrix(3,"float32",ATTRACTOR_COUNT);
		distmat = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		tempmat = new JitterMatrix(3,"float32", PARTICLE_COUNT);
		summat = new JitterMatrix(3,"float32", PARTICLE_COUNT);
		summat2 = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		scalarmat = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		amat = new JitterMatrix(3,"float32",PARTICLE_COUNT);
		
		init();
		
		post("this is a port of tutorial 46!\n");
	}
	
	public void init(){
		noisegen.matrixcalc(particlemat, particlemat);
		particlemat.op("*", 2.0f);
		particlemat.op("-", 1.0f);
	    // generate a matrix of random velocities spread between -1 and 1
	    noisegen.matrixcalc(velomat, velomat);
	    velomat.op("*", 2.0);
	    velomat.op("-", 1.0);
	    // generate a matrix of random attractors spread between -1 and 1
	    attgen.matrixcalc(attmat, attmat);
	    attmat.op("*", 2.0);
	}
	
	public void bang(){
	    switch(perform_mode) { // choose from the following...
        case 0: // use Jitter matrix operators
            bang_op();
            break;
        case 1: // use [jit.expr] for the bulk of the algorithm
            bang_expr();
            break;
        case 2: // iterate cell-by-cell through the matrices
            bang_iter();
            break;
        default:
        	bang_op();
            break;
	    }
	    
	    outlet(0,"jit_matrix",particlemat.getName());
	}
	    
	public void bang_op(){
		//int plane = 0;
		
		
		for(int i =0;i<ATTRACTOR_COUNT;i++){
			scalarmat.setall(attmat.getcell1d(i));
			tempmat.op("-", scalarmat, particlemat);
			distmat.op("*", tempmat, tempmat); 
			
			//summat.planemap = 0;
			summat.setAttr("planemap", 0);
			summat.frommatrix(distmat);
			summat.setAttr("planemap", 1);
			summat.frommatrix(distmat);
			summat.setAttr("planemap", 2);
			summat2.frommatrix(distmat);
	        summat.op("+", summat, summat2);
	        
	        tempmat.op("*", a); 
	        // divide our distances by the sum of the distances 
	        // to derive gravity for this frame:
	        tempmat.op("/", summat); 
	        // add to the current velocity bearings to get the 
	        // amount of motion for this frame:
	        velomat.op("+", tempmat); 
		}
		
		particlemat.op("+", velomat); 
        // reduce our velocities by the decay factor for the next frame:
        velomat.op("*", d);
	}
	
	public void bang_expr(){
		//is this working?
		amat.setall((float)a);
		
		for(int i=0;i<ATTRACTOR_COUNT;i++){
			scalarmat.setall(attmat.getcell1dFloat(i));
			tempmat.op("-", scalarmat, particlemat); 
	        // square to create a cartesian distance matrix (x*x, y*y, z*z):
	        distmat.op("*", tempmat, tempmat);
	        
	        myexpr.matrixcalc(distmat, summat);
	        //myexpr2.matrixcalc([velomat,scalarmat,particlemat,amat,summat], velomat);
	        myexpr2.matrixcalc(velomat, velomat);
	        myexpr2.matrixcalc(scalarmat, velomat);
	        myexpr2.matrixcalc(particlemat, velomat);
	        myexpr2.matrixcalc(amat, velomat);
	        myexpr2.matrixcalc(summat, velomat);
		}
		// offset our current positions by the amount of motion:
        particlemat.op("+", velomat); 
        // reduce our velocities by the decay factor for the next frame:
        velomat.op("*", d); 
		
	}
	
	public void bang_iter(){
		//not implemented
		
	}
	
	public void particles(int v){
	    PARTICLE_COUNT = v;

	    // resize matrices
	    noisegen.setAttr("dim", PARTICLE_COUNT);
	    particlemat.setAttr("dim", PARTICLE_COUNT);
	    velomat.setAttr("dim", PARTICLE_COUNT);
	    distmat.setAttr("dim", PARTICLE_COUNT);
	    attmat.setAttr("dim",PARTICLE_COUNT);
	    tempmat.setAttr("dim", PARTICLE_COUNT);
	    summat.setAttr("dim", PARTICLE_COUNT);
	    summat2.setAttr("dim", PARTICLE_COUNT);
	    scalarmat.setAttr("dim",PARTICLE_COUNT);
	    amat.setAttr("dim",PARTICLE_COUNT);

	    init(); // re-initialize particle system
	}
	
	public void attractors(int v){
		ATTRACTOR_COUNT = v;
		
		attgen.setAttr("dim", ATTRACTOR_COUNT);
		
		init();
	}
	
	public void accel(int v){
		a = v * 0.001f;
	}
	
	public void decay(int v){
		d = v * 0.001f;
	}
	
//	public void mode(String v){
//		perform_mode = v;
//	}
	
	public void mode(int v){
		perform_mode = v;
	}
	
	public void primitive(String v){
		draw_primitive = v;
	}
	
	/*
	function smear(v) // turn on drawing smear by zeroing the alpha on the renderer's erase color
	{
	    if(v) {
	        // smear on (alpha=0):
	        outlet(0, "erase_color", 1., 1., 1., 0.); 
	    }
	    else {
	        // smear off (alpha=0.1):
	        outlet(0, "erase_color", 1., 1., 1., 0.1); 
	    }
	}
	*/

}
