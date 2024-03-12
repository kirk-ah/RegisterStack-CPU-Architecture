package assembler;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Scanner;
import java.util.regex.Pattern;
/**
 * Purpose: the main class will start the program that will assemble our
 * register-stack architecture assembly language into machine code. Assembly
 * code will be read and parsed from a text file, and passed to the Assembler
 * class.
 * 
 * @author kirkah
 *
 */

public class Main {

	public static void main(String[] args) throws IOException, InterruptedException {
		try {
			File assemblyCode = new File("./././assemblyCode"); 
			File machineCode = new File("./././machineCode");
			File globalVars = new File("./././globalvars");

			FileWriter machineCodeWriter = new FileWriter(machineCode);
			Scanner assemblyScanner = new Scanner(assemblyCode);
			Scanner globalScanner = new Scanner(globalVars);

			System.out.println("------------Assemble------------");
			Assembler assembler = new Assembler(assemblyCode, machineCode, assemblyScanner, globalScanner,
					machineCodeWriter);
			assembler.configureBranchTargets(); // need this because branch targets are used for condensing...
			assembler.condenseAssembly();
			assembler.configureBranchTargets(); // since code is condensed...
			assembler.readGlobalAddresses();
			assembler.assembleCode();
			System.out.println("------------End Assemble------------");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
}
