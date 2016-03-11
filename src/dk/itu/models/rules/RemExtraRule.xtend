package dk.itu.models.rules

import xtc.lang.cpp.CTag
import xtc.lang.cpp.PresenceConditionManager.PresenceCondition
import xtc.lang.cpp.Syntax.Language
import xtc.tree.GNode
import xtc.util.Pair

class RemExtraRule extends Rule {

	override dispatch PresenceCondition transform(PresenceCondition cond) {
		cond
	}

	override dispatch Language<CTag> transform(Language<CTag> lang) {
		lang
	}

	override dispatch Pair<?> transform(Pair<?> pair) {
		pair
	}
	
	override dispatch Object transform(GNode node) {
		if (node.name == "Conditional" && node.size == 2) {
			val c = (node.get(0) as PresenceCondition)
			val g = guard(node) as PresenceCondition
			
			if (g.getBDD.imp(c.getBDD).isOne) {
//				println('''«g» implies «c»''')
//				println
				node.get(1)
			} else {
				node
			}
		} else {
			node
		}
	}

}