import de.prob.bmotion.IBMotionGroovyObserver;
import de.prob.ui.api.ITool;


bms.registerGroovyObserver(
	[
		update: { ITool tool ->
			return
		}
	] as IBMotionGroovyObserver
)
