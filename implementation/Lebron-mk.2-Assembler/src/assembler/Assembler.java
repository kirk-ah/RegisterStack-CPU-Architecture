package assembler;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

// TODO: Copy current machine code into design doc.

public class Assembler {
	File assemblyCode;
	File machineCode;
	FileWriter machineCodeWriter;
	BufferedWriter machineCodeBufferedWriter;
	Scanner assemblerScanner, branchTargetScanner, globalScanner;
	HashMap<String, Integer> branchTargets;
	HashMap<String, String> globalVariables = new HashMap<>();
	int instructionNumber;

	// static variables to represent opcodes for each instruction -- old
	private static String PUSH_OPCODE = "000010";
	private static String PUSHI_OPCODE = "100011";
	private static String POP_OPCODE = "000011";
	private static String PEEK_OPCODE = "000101";
	private static String JZ_OPCODE = "001101";
	private static String JNZ_OPCODE = "010011";
	private static String JMP_OPCODE = "001110";
	private static String LUP_OPCODE = "010001";
	private static String LLI_OPCODE = "010010";
	private static String DROP_OPCODE = "111101";
	private static String ADD_OPCODE = "000111";
	private static String SUB_OPCODE = "000110";
	private static String DUP_OPCODE = "001001";
	private static String SWAP_OPCODE = "001000";
	private static String EQ_OPCODE = "001010";
	private static String LT_OPCODE = "001011";
	private static String GT_OPCODE = "110110";
	private static String LE_OPCODE = "010111";
	private static String GEQ_OPCODE = "001100";
	private static String STORE_OPCODE = "001111";
	private static String RET_OPCODE = "010000";
	private static String SWAPPROC_OPCODE = "111111";
	private static String DUPPROC_OPCODE = "111110";
	
	// New
	private static String PUSHRA_OPCODE = "011111";
	private static String POPRA_OPCODE = "101101";
	private static String JAL_OPCODE = "111001";

	public Assembler(File assemblyCode, File machineCode, Scanner scanner, Scanner globalScanner,
			FileWriter machineCodeWriter) throws IOException {
		this.assemblyCode = assemblyCode;
		this.machineCode = machineCode;
		this.machineCodeWriter = machineCodeWriter;
		this.assemblerScanner = scanner;
		this.globalScanner = globalScanner;
		this.instructionNumber = 1;
		this.branchTargets = new HashMap<String, Integer>();
	}

	public void assembleCode() throws IOException, InterruptedException {
		while (assemblerScanner.hasNextLine()) {
			String line = assemblerScanner.nextLine();
			String[] parsedLine = line.split(" +");
			configureParametersBasedOnInstruction(parsedLine);
			instructionNumber++;
		}
		this.machineCodeWriter.close();

		
	}

	public void readGlobalAddresses() {
		boolean success = true;
		while (globalScanner.hasNext()) {
			String line = globalScanner.nextLine();
			String[] parsedLine = line.split(" +");
			globalVariables.put(parsedLine[0], parsedLine[1]);
		}

		if (success) {
			System.out.println("Global addresses scanned... Success");
		}
	}

	/**
	 * This method decides how to assemble an individual instruction.
	 * 
	 * @param parsedLine
	 * @throws IOException
	 */
	private void configureParametersBasedOnInstruction(String[] parsedLine) throws IOException {
		// use indices for array instead of array values...!!!
		String switchValue;
		int secondLiteralIndex;
		if (branchTargets.containsKey(parsedLine[0].replace(":", ""))) {
			secondLiteralIndex = 2;
			switchValue = parsedLine[1];
		} else {
			switchValue = parsedLine[0];
			secondLiteralIndex = 1;
		}
		switch (switchValue) {
		case "push":
			// Assemble a P-type instruction with pusha opcode
			assemblePInstruction(parsedLine, PUSH_OPCODE, 16, secondLiteralIndex);
			break;
		case "pushi":
			// Assemble a P-type instruction with pushi opcode
			assemblePInstruction(parsedLine, PUSHI_OPCODE, 10, secondLiteralIndex);
			break;
		case "pushra":
			// TODO: assembly pushra
			assemblePInstruction(parsedLine, PUSHRA_OPCODE, 16, secondLiteralIndex);
			break;
		case "pop":
			// Assemble a P-type instruction with pop opcode
			assemblePInstruction(parsedLine, POP_OPCODE, 16, secondLiteralIndex);
			break;
		case "popra":
			// TODO: assemble popra
			assemblePInstruction(parsedLine, POPRA_OPCODE, 16, secondLiteralIndex);
			break;
		case "peek":
			// Assemble a P-type instruction with peek opcode
			assemblePInstruction(parsedLine, PEEK_OPCODE, 16, secondLiteralIndex);
			break;
		case "jal":
			// TODO: assemble jal
			assemblePInstruction(parsedLine, JAL_OPCODE, 16, secondLiteralIndex);
			break;
		case "jz":
			// Assemble a P-type instruction with jz opcode
			assemblePInstruction(parsedLine, JZ_OPCODE, 16, secondLiteralIndex);
			break;
		case "jnz":
			// Assemble a P-type instruction with jnz opcode
			assemblePInstruction(parsedLine, JNZ_OPCODE, 16, secondLiteralIndex);
			break;
		case "jmp":
			// Assemble a P-type instruction with jmp opcode
			assemblePInstruction(parsedLine, JMP_OPCODE, 16, secondLiteralIndex);
			break;
		case "lup":
			// Assemble a P-type instruction with lup opcode
			assemblePInstruction(parsedLine, LUP_OPCODE, 10, secondLiteralIndex);
			break;
		case "lli":
			// Assemble a P-type instruction with lli opcode
			assemblePInstruction(parsedLine, LLI_OPCODE, 10, secondLiteralIndex);
			break;
		case "add":
			// Assemble an A-type instruction with add opcode
			assembleAInstruction(parsedLine, ADD_OPCODE);
			break;
		case "sub":
			// Assemble an A-type instruction with sub opcode
			assembleAInstruction(parsedLine, SUB_OPCODE);
			break;
		case "swap":
			// Assemble an A-type instruction with swap opcode
			assembleAInstruction(parsedLine, SWAP_OPCODE);
			break;
		case "dup":
			// Assemble an A-type instruction with dup opcode
			assembleAInstruction(parsedLine, DUP_OPCODE);
			break;
		case "drop":
			// Assemble an A-type instruction with drop opcode
			assembleAInstruction(parsedLine, DROP_OPCODE);
			break;
		case "eq":
			// Assemble an A-type instruction with eq opcode
			assembleAInstruction(parsedLine, EQ_OPCODE);
			break;
		case "lt":
			// Assemble an A-type instruction with lt opcode
			assembleAInstruction(parsedLine, LT_OPCODE);
			break;
		case "le":
			// Assemble an A-type instruction with le opcode
			assembleAInstruction(parsedLine, LE_OPCODE);
			break;
		case "gt":
			assembleAInstruction(parsedLine, GT_OPCODE);
			break;
		case "geq":
			// Assemble an A-type instruction with geq opcode
			assembleAInstruction(parsedLine, GEQ_OPCODE);
			break;
		case "store":
			// Assemble an A-type instruction with store opcode
			assembleAInstruction(parsedLine, STORE_OPCODE);
			break;
		case "ret":
			// Assemble an A-type instruction with ret opcode
			assembleAInstruction(parsedLine, RET_OPCODE);
			break;
		case "swapproc":
			// Assemble an A-type instruction with swapproc opcode
			assembleAInstruction(parsedLine, SWAPPROC_OPCODE);
			break;
		case "dupproc":
			// Assemble an A-type instruction with dupproc opcode
			assembleAInstruction(parsedLine, DUPPROC_OPCODE);
			break;
		default:
			break;
		}
	}

	/**
	 * 
	 * @param parsedLine
	 * @param opcode
	 * @param radix
	 * @throws IOException
	 */
	private void assemblePInstruction(String[] parsedLine, String opcode, int radix, int secondLiteralIndex)
			throws IOException {
		StringBuilder machineCodeLineTypeP = new StringBuilder();
		String secondArgLiteral = parsedLine[secondLiteralIndex];
		String binarySecondArgument;
	
		try {
			// we have an immediate, not a global variable
			binarySecondArgument = decimalToBinary(Integer.parseInt(secondArgLiteral, 10), 10);
		} catch (NumberFormatException e) {
			// we have either a global variable or the start of a procedure
			if (branchTargets.containsKey(secondArgLiteral)) { // is a LOOP: or something like that
				// calculate branch target...
				secondArgLiteral.replace("\n", "");
				binarySecondArgument = calculateBranchTarget(secondArgLiteral);
			} else {

				// This is here to catch if the global variable is not in the global variables
				// list, or if a completely invalid argument is second.
				try {
					String addr = globalVariables.get(secondArgLiteral);
					int dec = Integer.parseInt(addr, 16);
					binarySecondArgument = decimalToBinary(dec, 10);
				} catch (NumberFormatException e1) {
					binarySecondArgument = ("00");
					// tells what invalid variable was read (i.e. global var is not in the text or
					// branch target somehow not hashed correctly).
					System.out.println("ERROR, GLOBAL VAR NOT IN TEXT FILE: " + " global var: " + secondArgLiteral
							+ " instruction number: " + instructionNumber + " instruction: "
							+ parsedLine[secondLiteralIndex - 1]);
				}
			}
		}

		// ------ putting the upper 10 bits into machine code ------ //
		machineCodeLineTypeP.append(binarySecondArgument + " ");

		// ------ putting the opcode into the lower 6 bits ------- //
		machineCodeLineTypeP.append(opcode);
//		this.machineCodeWriter.write(machineCodeLineTypeP.toString() + "\n");
		this.machineCodeWriter.write(machineCodeLineTypeP.toString() + "\n");
	}

	private String calculateBranchTarget(String branchName) {
		int target = branchTargets.get(branchName);
		int instructionOffset = target - instructionNumber;
//		System.out.println("Byte offset: " + 2 * instructionOffset);
		return decimalToBinary(instructionOffset * 2, 10); // return the bytes, not the instruction offset
	}

	private void assembleAInstruction(String[] parsedLine, String opcode) throws IOException {
		StringBuilder machineCodeLineTypeA = new StringBuilder();
		// ------ Upper 10 bits are all 0's ---------------------- //
		// ------ putting the opcode into the lower 6 bits ------- //
		machineCodeLineTypeA.append(decimalToBinary(0, 10) + " ");
		machineCodeLineTypeA.append(opcode);
		this.machineCodeWriter.write(machineCodeLineTypeA.toString() + "\n");
	}

	public String decimalToBinary(int decimal, int length) {
		StringBuilder sb = new StringBuilder();
		String binary = Integer.toBinaryString(decimal);

		while (binary.length() > length) {
			binary = binary.substring(1);
		}

		while (binary.length() < length) {
			binary = "0" + binary.substring(0);
		}

		sb.append(binary);
		return sb.toString();
	}

	/**
	 * This method condenses the assembly file into the "standard" format. For now,
	 * this includes making all procedure starts, i.e. PROGRAM: or LOOP:, have a
	 * line of code with them, since these are merely names for addresses in memory
	 * where code is.
	 * 
	 * @throws IOException
	 */
	public void condenseAssembly() throws IOException {
		Scanner condenser = new Scanner(assemblyCode);
		StringBuilder writeLine = new StringBuilder();
		boolean success = true;
		while (condenser.hasNextLine()) {
			String line = condenser.nextLine();
			line.trim();
			String[] parsedLine = line.split(" +");
			if (parsedLine.length == 0) {
				continue;
			}
			if (branchTargets.containsKey(parsedLine[0].replace(":", "")) && parsedLine.length == 1) {
//				System.out.println("condense line: " + Arrays.toString(parsedLine));
				writeLine.append(parsedLine[0]);
				writeLine.append(" ");
				continue;
			}
			writeLine.append(Arrays.toString(parsedLine).replace(",", "").replace("[", "").replace("]", ""));
			writeLine.append("\n");
		}
		FileWriter assemblyWriter = new FileWriter(assemblyCode);
		assemblyWriter.write(writeLine.toString());
		condenser.close();
		assemblyWriter.close();
		if (success) {
			System.out.println("Assembly Condensed... Success");
		}
	}

	/**
	 * Creates a hash map. The keys are all the starts of procedure calls, which are
	 * the branch targets for all branch instructions. The value to each key is the
	 * line number in which that procedure start lies.
	 * 
	 * @throws FileNotFoundException
	 */
	public void configureBranchTargets() throws FileNotFoundException {
		Scanner branchTargetScanner = new Scanner(assemblyCode);
		int instructionNumber = 1;
		boolean success = true;
		while (branchTargetScanner.hasNext()) {
			String line = branchTargetScanner.nextLine();
			String[] parsedLine = line.split(" ");
			switch (parsedLine[0]) {
			case "push":
				break;
			case "pushi":
				break;
			case "pop":
				break;
			case "peek":
				break;
			case "jal":
				break;
			case "jz":
				break;
			case "jnz":
				break;
			case "jmp":
				break;
			case "lup":
				break;
			case "lli":
				break;
			case "add":
				break;
			case "sub":
				break;
			case "swap":
				break;
			case "dup":
				break;
			case "drop":
				break;
			case "eq":
				break;
			case "lt":
				break;
			case "le":
				break;
			case "geq":
				break;
			case "store":
				break;
			case "ret":
				break;
			case "swapproc":
				break;
			case "dupproc":
				break;
			case "gt":
				break;
			case "popra":
				break;
			default:
				// found a non-instruction (it is the start of a process)
				branchTargets.put(parsedLine[0].replace(":", ""), instructionNumber);
				break;
			}
			instructionNumber++;
		}
		branchTargetScanner.close();
		instructionNumber = 1;
		if (success) {
			System.out.println("Branch targets configured... Success");
		}
	}
}
