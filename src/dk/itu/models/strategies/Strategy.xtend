package dk.itu.models.strategies

import dk.itu.models.rules.Rule
import java.util.ArrayList
import xtc.lang.cpp.CTag
import xtc.lang.cpp.PresenceConditionManager.PresenceCondition
import xtc.lang.cpp.Syntax.Language
import xtc.tree.GNode
import xtc.util.Pair

abstract class Strategy {

	protected val ArrayList<Rule> rules

	new() {
		this.rules = new ArrayList<Rule>
	}

	def register(Rule rule) {
		rules.add(rule.init())
	}

	def dispatch PresenceCondition transform(PresenceCondition cond) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def dispatch Language<CTag> transform(Language<CTag> lang) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def dispatch Pair<Object> transform(Pair<Object> pair) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def dispatch Object transform(GNode node) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}