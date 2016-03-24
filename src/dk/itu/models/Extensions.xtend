package dk.itu.models

import com.google.common.collect.AbstractIterator
import com.google.common.collect.FluentIterable
import com.google.common.collect.UnmodifiableIterator
import java.io.BufferedReader
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.FileReader
import java.io.IOException
import java.io.PrintStream
import java.io.PrintWriter
import java.util.HashMap
import java.util.Iterator
import java.util.List
import org.eclipse.xtext.xbase.lib.Functions.Function1
import org.eclipse.xtext.xbase.lib.Functions.Function2
import us.cuny.qc.cs.babbage.Minimize
import xtc.lang.cpp.PresenceConditionManager.PresenceCondition
import xtc.tree.GNode
import xtc.tree.Node
import xtc.util.Pair

import static dk.itu.models.Extensions.*

class Extensions {
	public static def String folder(String filePath) {
		filePath.substring(0, filePath.lastIndexOf(File.separator) + 1)
	}
	
	public static def String relativeTo(String path, String base) {
		if (path.startsWith(base)) { '''«path.substring(base.length)»''' }
		else path
	}
	
	public static def void writeToFile(String text, String file) {
		try {
			var PrintWriter file_output = new PrintWriter(new FileOutputStream(file, true));
			file_output.write(text);
			file_output.flush();
			file_output.close();
		} catch (IOException e) {
			System.err.println("Can not recover from the input or output fault");
		}
	}
	
	public static def String readFile(String fileName) throws IOException {
	    val BufferedReader br = new BufferedReader(new FileReader(fileName));
	    try {
	        val StringBuilder sb = new StringBuilder();
	        var String line = br.readLine();
	
	        while (line != null) {
	            sb.append(line);
	            sb.append("\n");
	            line = br.readLine();
	        }
	        return sb.toString();
	    } finally {
	        br.close();
	    }
	}
	
	public static def void flushConsole() {
		Settings::systemOutPS.print(Settings::consoleBAOS)
		Settings::consoleBAOS.toString.writeToFile(Settings::consoleFile.path)
		Settings::consoleBAOS.reset()
	}
	
	public static def void summary(Object o) {
		Settings::summaryPS.print(o)
	}
	
	public static def void summaryln(Object o) {
		Settings::summaryPS.print(o + "\n")
	}
	
	public static def void summaryln() {
		Settings::summaryPS.print("\n")
	}
	
	public static def printCode(Object o) {
		PrintCode::printCode(o)
	}
	
	public static def printAST(Object o) {
		PrintAST::printAST(o)
	}
	
	
	public static def Pair<?> toPair(List<?> node) {
		node.toPair
	}

	public static def Pair<Object> toPair(Iterable<Object> node) {
		var Pair<Object> p = Pair.empty()
		for (var i = node.size - 1; i >= 0; i--) {
			p = new Pair(node.get(i), p)
		}
		p
	}
	
	
	
	private static def <T> UnmodifiableIterator<T> filterIndexedHelper(Iterable<T> unfiltered, Function2<? super T, Integer, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		if (predicate == null) throw new NullPointerException();
		return new AbstractIterator<T>() {
			val iterator = unfiltered.iterator
			private var index = 0
			override protected T computeNext() {
				while (iterator.hasNext()) {
					val T element = iterator.next();
					if (predicate.apply(element, index++)) {
						return element;
					}
				}
				return endOfData();
			}
		};
  	}
	
	public static def <T> Iterable<T> filterIndexed (Iterable<T> unfiltered, Function2<? super T, Integer, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		println ("start")
		return new FluentIterable<T>() {
			override public Iterator<T> iterator() {
				return filterIndexedHelper(unfiltered, predicate);
			}
		}
	}
	
	
	
	private static def <T> UnmodifiableIterator<T> filterFixedHelper(Iterable<T> unfiltered, Function2<? super T, Iterable<T>, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		if (predicate == null) throw new NullPointerException();
		return new AbstractIterator<T>() {
			val iterator = unfiltered.iterator
			override protected T computeNext() {
				while (iterator.hasNext()) {
					val T element = iterator.next();
					if (predicate.apply(element, unfiltered)) {
						return element;
					}
				}
				return endOfData();
			}
		};
  	}
	
	public static def <T> Iterable<T> filterFixed (Iterable<T> unfiltered, Function2<? super T, Iterable<T>, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		return new FluentIterable<T>() {
			override public Iterator<T> iterator() {
				return filterFixedHelper(unfiltered, predicate);
			}
		}
	}
	
	
	private static def filterFixedHelper(Node unfiltered, Function2<Object, Node, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		if (predicate == null) throw new NullPointerException();
		return new AbstractIterator<Object>() {
			val iterator = unfiltered.iterator
			override protected computeNext() {
				while (iterator.hasNext()) {
					val Object element = iterator.next();
					println("hello")
					if (predicate.apply(element, unfiltered)) {
						return element;
					}
				}
				return endOfData();
			}
		};
  	}
	
	public static def filterFixed (Node unfiltered, Function2<Object, Node, Boolean> predicate) {
		if (unfiltered == null) throw new NullPointerException();
		return new FluentIterable<Object>() {
			override public Iterator<Object> iterator() {
				return filterFixedHelper(unfiltered, predicate);
			}
		}
	}
	
	
	public static def <T,U> U pipe(T it, Function1<? super T, U> f) {
		f.apply(it)
	}
	
	public static def Pair<Object> getChildrenGuardedBy(GNode node, PresenceCondition pc) {
		var Pair<Object> p = Pair.EMPTY
		var index = node.indexOf(pc) + 1
		while (index < node.size && !(node.get(index) instanceof PresenceCondition)) {
			p = p.add(node.get(index++))
		}
		p
	}
	
	public static def boolean containsConditional(Node node) {
		ContainsConditional::containsConditional(node)
	}
	
	public static def String PCtoMexp(PresenceCondition cond, HashMap<String, String> varMap) {
		val HashMap<String, String> varMapInverse = new HashMap<String, String>
		val char a = 'a'
		val bdd = cond.BDD
		val vars = Reconfigurator.presenceConditionManager.variableManager
		
		if (bdd.isOne()) {
			return "1"
		} else if (bdd.isZero()) {
			return "0"
      	}
		
		val StringBuilder mexp = new StringBuilder
		
		var firstConjunction = true;
		for (Object o : bdd.allsat()) {
			if (!firstConjunction) { mexp.append("+") } 

			var byte[] sat = o as byte[]
			for (var i = 0; i < sat.length; i++) {
//				if (sat.get(i) >= 0 && ! firstTerm) { print(" && "); }

				if(sat.get(i) >= 0) {
//					print("!")
					var id = vars.getName(i)
					id = id.substring(9, id.length-1)
					if (!varMapInverse.containsKey(id)) {
						val shortId = ((a + varMapInverse.size)as char).toString
						varMapInverse.put(id, shortId)
						varMap.put(shortId, id)
					}
					id = varMapInverse.get(id)
//					print(id)
					mexp.append(id)
				}
				if(sat.get(i) == 0) {	
					mexp.append("'")
				}
			}
        	firstConjunction = false
		}
		
		mexp.toString
	}
	
	public static def String MexptoCPPexp(String mexp, HashMap<String, String> varMap) {
		val StringBuilder output = new StringBuilder
		val input = mexp.toCharArray
		var firstConjunction = true
			
		for (var i = 0; i < input.length; i++) {
			val current = input.get(i)
			
			if ((current.toString).equals("+")) {
				output.append(" || ")
				firstConjunction = true
			} else if (!(current.toString).equals("'") && !(current.toString).equals(" ")) {
				if (firstConjunction == false) {
					output.append(" && ")
				}
				if(i < input.length -1 && (input.get(i+1).toString).equals("'"))
					output.append("!")
				output.append('''defined(«varMap.get(current.toString)»)''')
				firstConjunction = false
			}
		}
		output.toString
	}
	
	
	public static def String PCtoCPPexp(PresenceCondition condition) {
		if (condition.toString.equals("1")) "1"
		else if (condition.toString.equals("0")) "0"
		else {
			val varMap = new HashMap<String, String>
			val mexp = condition.PCtoMexp(varMap)
			val baos = new ByteArrayOutputStream
			var ps = new PrintStream(baos)
			Minimize::process(mexp, ps).MexptoCPPexp(varMap)
		}
	}
}