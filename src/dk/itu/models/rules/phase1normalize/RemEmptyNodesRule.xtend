package dk.itu.models.rules.phase1normalize

import dk.itu.models.rules.Rule
import xtc.lang.cpp.CTag
import xtc.lang.cpp.PresenceConditionManager.PresenceCondition
import xtc.lang.cpp.Syntax.Language
import xtc.tree.GNode
import xtc.util.Pair

import static extension dk.itu.models.Extensions.*

class RemEmptyNodesRule extends Rule {
	
	override dispatch PresenceCondition transform(PresenceCondition cond) {
		cond
	}

	override dispatch Language<CTag> transform(Language<CTag> lang) {
		lang
	}

	override dispatch Pair<Object> transform(Pair<Object> pair) {
		if (
			!pair.empty
			&& pair.head.is_GNode
			&& #["ExpressionOpt", "AssemblyExpressionOpt", "AttributeSpecifierListOpt"].contains(pair.head.as_GNode.name)
			&& pair.head.as_GNode.empty
		) {
			return pair.tail
		} else {
			return pair
		}
	}
	
	override dispatch Object transform(GNode node) {
		node
	}
	
}